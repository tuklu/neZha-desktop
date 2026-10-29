#!/usr/bin/env bash
# Links the selected modules into place. Idempotent: safe to re-run after every pull.
# Written for bash 3.2 as well, since that is what macOS ships.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/nezha"
BACKUP="$STATE/backups/$(date +%Y%m%d-%H%M%S)"
DEFAULT_PRIVATE_DIR="$HOME/.local/share/nezha/dots"
DEFAULT_THEME=n1
SOURCES_DIR="$HOME/.local/share/nezha/sources"

usage() {
    cat <<'EOF'
usage: install.sh [options]

  --profile NAME    install a profile from ./profiles (dev, desktop)
  --only A,B        install exactly these modules
  --pick            choose modules interactively (needs fzf)
  --private SRC     overlay a private repo: a local path or a git URL
  --packages        install the packages the selected modules need, first
  --check           report link status, change nothing
  --dry-run         show what would change, change nothing
  --list            list modules available on this OS

With no selection flag, the last selection is reused. On a first run the
picker opens if fzf is available, otherwise the default profile for this OS
is used (desktop on Linux, dev on macOS).
EOF
}

current_os() {
    case "$(uname -s)" in
        Linux)  echo linux ;;
        Darwin) echo macos ;;
        *)      echo unknown ;;
    esac
}

default_profile() {
    [[ $(current_os) == linux ]] && echo desktop || echo dev
}

conf_value() {
    local file=$1/module.conf key=$2
    [[ -r $file ]] || return 0
    sed -n "s/^$key=//p" "$file" | head -n1
}

# Manual modules (root-owned files) are listed but never linked.
module_applies() {
    local dir=$1 os
    [[ -r $dir/links ]] || return 1
    [[ $(conf_value "$dir" manual) == true ]] && return 1
    os=$(conf_value "$dir" os)
    [[ -z $os || $os == any || $os == "$(current_os)" ]]
}

available_modules() {
    local root=$1 dir
    for dir in "$root"/modules/*/; do
        dir=${dir%/}
        module_applies "$dir" && basename "$dir"
    done
    return 0
}

profile_modules() {
    local name=$1 line
    line=$(grep -E "^$name[[:space:]]*:" "$REPO/profiles" || true)
    [[ -n $line ]] || { echo "unknown profile: $name" >&2; return 1; }
    echo "${line#*:}"
}

pick_modules() {
    command -v fzf >/dev/null || { echo "--pick needs fzf" >&2; return 1; }
    local m
    for m in $(available_modules "$REPO"); do
        printf '%-10s %s\n' "$m" "$(conf_value "$REPO/modules/$m" desc)"
    done | fzf --multi --bind 'start:select-all' --prompt 'modules> ' \
               --header 'tab toggles, enter installs' | awk '{print $1}' | tr '\n' ' '
}

is_git_url() {
    [[ $1 == *@*:* || $1 == https://* || $1 == ssh://* ]]
}

resolve_private() {
    local src=$1
    if is_git_url "$src"; then
        if [[ ! -d $DEFAULT_PRIVATE_DIR/.git ]]; then
            mkdir -p "$(dirname "$DEFAULT_PRIVATE_DIR")"
            git clone --quiet "$src" "$DEFAULT_PRIVATE_DIR"
        fi
        echo "$DEFAULT_PRIVATE_DIR"
    else
        (cd "$src" && pwd)
    fi
}

# Targets the private overlay links itself; the public link for those is skipped.
private_targets() {
    local m line dst
    [[ -n $private_root ]] || return 0
    for m in $(private_modules "$private_root"); do
        while IFS= read -r line || [[ -n $line ]]; do
            line="${line%%#*}"
            [[ -z ${line// } ]] && continue
            dst="${line#*:}"; dst="${dst// }"
            echo "${dst/#\~/$HOME}"
        done < "$private_root/modules/$m/links"
    done
}

link_one() {
    local abs=$1 dst=$2

    if [[ $abs == "$REPO"/* ]] && grep -qxF -- "$dst" <<< "$overridden"; then
        printf 'private wins     %s\n' "$dst"
        return
    fi

    if [[ ! -e $abs ]]; then
        printf 'missing in repo  %s\n' "$abs"
        status=1
        return
    fi

    if [[ -L $dst && "$(readlink -f "$dst")" == "$(readlink -f "$abs")" ]]; then
        printf 'ok               %s\n' "$dst"
        return
    fi

    if [[ $mode == check ]]; then
        printf 'NOT LINKED       %s\n' "$dst"
        status=1
        return
    fi

    if [[ $mode == dry-run ]]; then
        [[ -e $dst || -L $dst ]] && printf 'would back up    %s\n' "$dst"
        printf 'would link       %s -> %s\n' "$dst" "$abs"
        return
    fi

    # Anything already sitting at the target is preserved, never deleted.
    if [[ -e $dst || -L $dst ]]; then
        mkdir -p "$BACKUP/$(dirname "${dst#$HOME/}")"
        mv "$dst" "$BACKUP/${dst#$HOME/}"
        printf 'backed up        %s -> %s\n' "$dst" "$BACKUP/${dst#$HOME/}"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sfn "$abs" "$dst"
    printf 'linked           %s -> %s\n' "$dst" "$abs"
}

link_module() {
    local dir=$1 line src dst
    while IFS= read -r line || [[ -n $line ]]; do
        line="${line%%#*}"
        [[ -z ${line// } ]] && continue
        src="${line%%:*}"; src="${src// }"
        dst="${line#*:}";  dst="${dst// }"
        link_one "$dir/$src" "${dst/#\~/$HOME}"
    done < "$dir/links"
}

# Paths a module needs out of the way, such as a second config location the
# app would also read. They are backed up like anything else replaced.
displace_paths() {
    local dir=$1 os path
    [[ -r $dir/displace ]] || return 0
    while read -r os path || [[ -n $os ]]; do
        [[ -z $os || $os == \#* ]] && continue
        [[ $os == any || $os == "$(current_os)" ]] || continue
        path=${path/#\~/$HOME}
        [[ -e $path && ! -L $path ]] || continue
        case $mode in
            check)   printf 'NOT DISPLACED    %s\n' "$path"; status=1 ;;
            dry-run) printf 'would back up    %s\n' "$path" ;;
            link)
                mkdir -p "$BACKUP/$(dirname "${path#$HOME/}")"
                mv "$path" "$BACKUP/${path#$HOME/}"
                printf 'backed up        %s\n' "$path" ;;
        esac
    done < "$dir/displace"
}

# Private modules apply when the selection names them or they opt in with always=true.
private_modules() {
    local root=$1 m
    for m in $(available_modules "$root"); do
        if [[ " $selection " == *" $m "* || $(conf_value "$root/modules/$m" always) == true ]]; then
            echo "$m"
        fi
    done
    return 0
}

# Upstream pieces the active theme pins, checked out at the exact commit.
sync_theme_sources() {
    local file=$REPO/themes/current/sources name url rev dir head
    [[ -r $file ]] || return 0
    while read -r name url rev; do
        [[ -z $name || $name == \#* ]] && continue
        dir=$SOURCES_DIR/$name
        head=$(git -C "$dir" rev-parse HEAD 2>/dev/null || true)
        if [[ $head == "$rev" ]]; then
            printf 'ok               %s @ %s\n' "$name" "${rev:0:7}"
        elif [[ $mode != link ]]; then
            printf 'NOT PINNED       %s (want %s)\n' "$name" "${rev:0:7}"
            [[ $mode == check ]] && status=1
        else
            [[ -d $dir/.git ]] || git clone --quiet "$url" "$dir"
            git -C "$dir" fetch --quiet origin
            git -C "$dir" checkout --quiet --detach "$rev"
            printf 'pinned           %s @ %s\n' "$name" "${rev:0:7}"
        fi
    done < "$file"
}

# hyprlock: layout from the pinned repo, images and colors from the active theme.
render_hyprlock() {
    local src=$SOURCES_DIR/hyprlock/hyprlock.conf out=$STATE/hyprlock.conf
    [[ $mode == link && -r $src ]] || return 0
    mkdir -p "$STATE"
    sed -e 's|\./assets/|~/.config/nezha/theme/hyprlock/|g' \
        -e 's|\./colors\.conf|~/.config/nezha/theme/hyprlock.conf|' "$src" > "$out"
    printf 'rendered         %s\n' "$out"
}

read_list() {
    [[ -r $1 ]] || return 0
    sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$1"
}

# Every package list of the selected modules, public and private, for this OS.
collect_lists() {
    local name=$1 m root
    for m in $selection; do
        read_list "$REPO/modules/$m/$name"
    done
    if [[ -n $private_root ]]; then
        for m in $(private_modules "$private_root"); do
            read_list "$private_root/modules/$m/$name"
        done
    fi
}

install_packages() {
    local repo aur missing helper formulae casks cask
    if [[ $(current_os) == linux ]]; then
        repo=$(collect_lists pacman.txt | sort -u | tr '\n' ' ')
        aur=$(collect_lists aur.txt | sort -u | tr '\n' ' ')
        # shellcheck disable=SC2086
        missing=$(pacman -T $repo $aur 2>/dev/null | tr '\n' ' ' || true)
        printf '\n[packages]\n'
        [[ -z ${missing// } ]] && { echo "all installed"; return 0; }
        printf 'missing: %s\n' "$missing"
        [[ $mode == link ]] || return 0
        repo=$(comm -12 <(tr ' ' '\n' <<< "$missing" | sort) <(tr ' ' '\n' <<< "$repo" | sort) | tr '\n' ' ')
        aur=$(comm -12 <(tr ' ' '\n' <<< "$missing" | sort) <(tr ' ' '\n' <<< "$aur" | sort) | tr '\n' ' ')
        # shellcheck disable=SC2086
        [[ -n ${repo// } ]] && sudo pacman -S --needed $repo
        if [[ -n ${aur// } ]]; then
            helper=$(command -v paru || command -v yay || true)
            # shellcheck disable=SC2086
            if [[ -n $helper ]]; then "$helper" -S --needed $aur
            else printf 'no AUR helper found; install by hand: %s\n' "$aur"; fi
        fi
    else
        command -v brew >/dev/null || { echo "Homebrew is not installed: https://brew.sh" >&2; return 1; }
        formulae=$(collect_lists brew.txt | grep -v '^cask ' | sort -u | tr '\n' ' ')
        casks=$(collect_lists brew.txt | sed -n 's/^cask //p' | sort -u | tr '\n' ' ')
        printf '\n[packages]\nformulae: %s\ncasks: %s\n' "$formulae" "$casks"
        [[ $mode == link ]] || return 0
        # shellcheck disable=SC2086
        [[ -n ${formulae// } ]] && brew install $formulae
        # One at a time: an app installed outside brew makes its cask fail, and
        # that should not stop the rest.
        for cask in $casks; do
            brew list --cask "$cask" >/dev/null 2>&1 && continue
            brew install --cask "$cask" || printf 'cask %s failed, likely installed outside brew\n' "$cask"
        done
    fi
    return 0
}

# Runs after the private overlay, so a provided identity is never asked for.
ask_git_identity() {
    local file=$HOME/.config/git/local name email
    [[ $mode == link && " $selection " == *" git "* ]] || return 0
    [[ -e $file || ! -t 0 ]] && return 0
    printf '\n[git identity] blank to skip\n'
    read -r -p 'name:  ' name
    read -r -p 'email: ' email
    [[ -n $name && -n $email ]] || { echo "skipped, edit $file later"; return 0; }
    mkdir -p "$(dirname "$file")"
    printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$file"
    printf 'wrote            %s\n' "$file"
}

mode=link
selection=""
private_src=""
with_packages=false
status=0

while (( $# )); do
    case $1 in
        --profile) selection=$(profile_modules "$2"); shift ;;
        --only)    selection=${2//,/ }; shift ;;
        --pick)    selection=$(pick_modules) ;;
        --private) private_src=$2; shift ;;
        --packages) with_packages=true ;;
        --check)   mode=check ;;
        --dry-run) mode=dry-run ;;
        --list)    available_modules "$REPO"; exit 0 ;;
        -h|--help) usage; exit 0 ;;
        *)         echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

if [[ -z $selection && -r $STATE/selection ]]; then
    selection=$(cat "$STATE/selection")
fi
if [[ -z $selection && -t 0 && $mode == link ]] && command -v fzf >/dev/null; then
    selection=$(pick_modules)
fi
[[ -n $selection ]] || selection=$(profile_modules "$(default_profile)")

if [[ -z $private_src && -r $STATE/private ]]; then
    private_src=$(cat "$STATE/private")
fi
private_root=""
[[ -n $private_src ]] && private_root=$(resolve_private "$private_src")

overridden=$(private_targets)

if $with_packages; then
    install_packages
fi

# The repo's own pre-commit check keeps personal lines out of public history.
if [[ $mode == link && -d $REPO/.git ]]; then
    git -C "$REPO" config core.hooksPath .githooks
fi

# The active theme is local state; a fresh clone starts on the default.
if [[ $mode == link && ! -e $REPO/themes/current ]]; then
    ln -sfn "$DEFAULT_THEME" "$REPO/themes/current"
fi

for m in $selection; do
    if [[ ! -d $REPO/modules/$m ]]; then
        printf 'unknown module   %s\n' "$m"
        status=1
        continue
    fi
    if ! module_applies "$REPO/modules/$m"; then
        printf 'skipped          %s (not available on %s)\n' "$m" "$(current_os)"
        continue
    fi
    printf '\n[%s]\n' "$m"
    displace_paths "$REPO/modules/$m"
    link_module "$REPO/modules/$m"
done

if [[ " $selection " == *" desktop "* ]]; then
    printf '\n[theme sources]\n'
    sync_theme_sources
    render_hyprlock
fi

if [[ -n $private_root ]]; then
    for m in $(private_modules "$private_root"); do
        printf '\n[private/%s]\n' "$m"
        link_module "$private_root/modules/$m"
    done
fi

ask_git_identity

# Tracked relative symlinks break silently when files move.
if [[ $mode == check ]]; then
    while IFS= read -r link; do
        printf 'BROKEN SYMLINK   %s -> %s\n' "${link#$REPO/}" "$(readlink "$link")"
        status=1
    done < <(git -C "$REPO" ls-files -s -- modules themes 2>/dev/null \
                 | awk '$1 == "120000" {print $4}' \
                 | while IFS= read -r rel; do [[ -e $REPO/$rel ]] || echo "$REPO/$rel"; done)
fi

if [[ $mode == link && $status == 0 ]]; then
    mkdir -p "$STATE"
    echo "$selection" > "$STATE/selection"
    [[ -n $private_src ]] && echo "$private_src" > "$STATE/private"
    [[ -d $BACKUP ]] && printf '\nreplaced files kept at %s\n' "$BACKUP"
fi

exit $status
