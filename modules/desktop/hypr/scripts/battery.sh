#!/usr/bin/env zsh

BATTERY_DIR=$(find /sys/class/power_supply -maxdepth 1 -mindepth 1 -exec sh -c '[ -f "$1/type" ] && grep -q "Battery" "$1/type"' _ {} \; -print -quit)

if [[ -z "$BATTERY_DIR" ]]; then
    echo "No Battery"
    exit 0
fi

CAPACITY=$(cat "$BATTERY_DIR/capacity")
STATUS=$(cat "$BATTERY_DIR/status")

CHARGE_ICONS=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
DISCHARGE_ICONS=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

INDEX=$(( CAPACITY / 10 ))
[[ $INDEX -eq 10 ]] && INDEX=9

if [[ "$STATUS" == "Charging" ]]; then
    ICON="${CHARGE_ICONS[$INDEX]}"
elif [[ "$STATUS" == "Full" ]]; then
    ICON="󰂅"
else
    ICON="${DISCHARGE_ICONS[$INDEX]}"
fi

echo "${CAPACITY}%  ${ICON}"
