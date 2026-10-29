#!/usr/bin/env bash
# Makes notifications on the SDDM greeter look like the desktop ones.
# mako is D-Bus activated for the sddm user with no config of its own, so it
# falls back to the stock blue style. Symlinking the sddm user's mako config to
# the live theme file keeps both in sync with no copying. Idempotent; run as root.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_MAKO="$(cd "$REPO/../.." && pwd)/themes/current/mako.ini"
GREETER_HOME="$(getent passwd sddm | cut -d: -f6)"

[[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }

install -d -o sddm -g sddm "$GREETER_HOME/.config" "$GREETER_HOME/.config/mako"
ln -sfn "$THEME_MAKO" "$GREETER_HOME/.config/mako/config"
chown -h sddm:sddm "$GREETER_HOME/.config/mako/config"

# The sddm user must be able to traverse to the theme file through the symlinks.
sudo -u sddm test -r "$THEME_MAKO" || { echo "sddm cannot read $THEME_MAKO" >&2; exit 1; }

echo "greeter notifications themed"
