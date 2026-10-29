#!/usr/bin/env zsh

if ! command -v iwctl &> /dev/null; then
    echo "󰤮" # Or leave blank: echo ""
    exit 1
fi

# 1. Grab the device name (e.g., wlan0)
DEVICE=$(iwctl station list | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | awk '/connected/ {for(i=1;i<=NF;i++) if($i=="connected") print $(i-1)}')

if [[ -z "$DEVICE" ]]; then
    echo "󰤯" # Disconnected icon
    exit 0
fi

# 2. Extract exact RSSI value
RSSI=$(iwctl station "$DEVICE" show | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | awk '/^[ \t]*RSSI/ {print $2}')

# 3. Map dBm to Waybar icons
if [[ -n "$RSSI" && "$RSSI" =~ ^-[0-9]+$ ]]; then
    if (( RSSI >= -60 )); then ICON="󰤨"      # Excellent
    elif (( RSSI >= -70 )); then ICON="󰤥"    # Good
    elif (( RSSI >= -80 )); then ICON="󰤢"    # Fair
    elif (( RSSI >= -89 )); then ICON="󰤟"    # Weak
    else ICON="󰤯"                            # Terrible/None
    fi
else
    ICON="󰤨" # Fallback if parsing fails but we are connected
fi

echo "${ICON}"
