#!/usr/bin/env bash
# Edit the kernel cmdline baked into the signed UKI, then rebuild and re-sign it.
#
# On this machine the cmdline lives only in /etc/kernel/cmdline; mkinitcpio bakes
# it into /boot/EFI/Linux/arch-linux.efi and sbctl signs that for Secure Boot.
# A rebuild without a re-sign leaves an unbootable machine, so both happen here.
#
#   set-cmdline.sh remove <param> [param...]
#   set-cmdline.sh add <param=value> [param...]
#   set-cmdline.sh revert                        restore the newest backup
#   set-cmdline.sh show
set -euo pipefail

CMDLINE=/etc/kernel/cmdline
UKI=/boot/EFI/Linux/arch-linux.efi
BACKUPS=/var/lib/neZha/cmdline-backups

[[ $EUID -eq 0 ]] || { echo "must run as root" >&2; exit 1; }

RESTORE_CMDLINE=""
RESTORE_UKI=""

# Any failure after a backup exists must leave the machine bootable. Putting the
# cmdline back is not enough: a rebuild that succeeds and a sign that fails
# leaves a new unsigned UKI that Secure Boot rejects, so the signed one goes back
# too. Both halves come from the same stamp, so they always agree.
rollback() {
    local rc=$?
    (( rc == 0 )) && return 0
    if [[ -n $RESTORE_CMDLINE && -f $RESTORE_CMDLINE ]]; then
        cp "$RESTORE_CMDLINE" "$CMDLINE"
        echo "rolled back $CMDLINE" >&2
    fi
    if [[ -n $RESTORE_UKI && -f $RESTORE_UKI ]]; then
        cp "$RESTORE_UKI" "$UKI"
        echo "rolled back $UKI (the signed one)" >&2
    fi
    echo "failed with status $rc, previous state restored. Safe to reboot." >&2
    exit $rc
}
trap rollback EXIT

show() { echo "current: $(cat "$CMDLINE")"; }

backup() {
    mkdir -p "$BACKUPS"
    local stamp; stamp=$(date +%Y%m%d-%H%M%S)
    cp "$CMDLINE" "$BACKUPS/cmdline.$stamp"
    # The signed UKI is the real safety net: restoring it needs no rebuild.
    cp "$UKI" "$BACKUPS/arch-linux.efi.$stamp"
    RESTORE_CMDLINE="$BACKUPS/cmdline.$stamp"
    RESTORE_UKI="$BACKUPS/arch-linux.efi.$stamp"
    echo "$BACKUPS/*.$stamp"
}

rebuild() {
    echo "rebuilding UKI..."
    mkinitcpio -P
    echo "signing..."
    sbctl sign-all
    echo "verifying..."
    # Fail closed. Only an explicit "is signed" line naming this exact file
    # passes; sbctl erroring out, or not mentioning the UKI at all, is treated
    # as unsigned rather than as success.
    local line
    line=$(sbctl verify 2>&1 | grep -F "$UKI" | head -1) || true
    echo "  ${line:-no verify line for $UKI}"
    if [[ $line != *"is signed"* || $line == *"not signed"* ]]; then
        echo "REFUSING TO FINISH: $UKI is not verifiably signed." >&2
        exit 1
    fi
    echo "done. new cmdline:"; cat "$CMDLINE"
}

case "${1:-}" in
show) show ;;

remove)
    shift; [[ $# -gt 0 ]] || { echo "nothing to remove" >&2; exit 1; }
    backup
    # Tokenise and filter so console=ttyS0 can go while console=tty1 stays.
    read -ra params < "$CMDLINE"
    kept=()
    for p in "${params[@]}"; do
        drop=false
        for target in "$@"; do [[ $p == "$target" ]] && drop=true; done
        $drop && echo "  dropping $p" || kept+=("$p")
    done
    printf '%s\n' "${kept[*]}" > "$CMDLINE"
    rebuild ;;

add)
    shift; [[ $# -gt 0 ]] || { echo "nothing to add" >&2; exit 1; }
    backup
    read -ra params < "$CMDLINE"
    for target in "$@"; do
        for p in "${params[@]}"; do
            [[ $p == "$target" ]] && { echo "  already present: $target"; continue 2; }
        done
        params+=("$target"); echo "  adding $target"
    done
    printf '%s\n' "${params[*]}" > "$CMDLINE"
    rebuild ;;

revert)
    newest=$(ls -1t "$BACKUPS"/cmdline.* 2>/dev/null | head -1)
    [[ -n $newest ]] || { echo "no backups" >&2; exit 1; }
    # Roll forward to this backup; if the rebuild fails, roll back to the same one.
    RESTORE_CMDLINE="$newest"
    RESTORE_UKI="${newest/cmdline./arch-linux.efi.}"
    cp "$newest" "$CMDLINE"
    echo "restored $newest"
    rebuild ;;

*) sed -n '3,12p' "$0" | sed 's/^# \?//'; exit 2 ;;
esac
