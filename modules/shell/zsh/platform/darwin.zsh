# Kept from the previous macOS setup.
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT CORRECT

export LESS=${LESS:--FRX}
# Brew refreshes metadata at most monthly; upgrades stay explicit.
export HOMEBREW_AUTO_UPDATE_SECS=${HOMEBREW_AUTO_UPDATE_SECS:-2592000}
[[ -t 1 ]] && export GPG_TTY=$TTY
