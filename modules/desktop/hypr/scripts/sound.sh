#!/usr/bin/env bash

if ! command -v pamixer &> /dev/null; then
    echo "pamixer missing"
    exit 1
fi

MUTED=$(pamixer --get-mute)
VOLUME=$(pamixer --get-volume)

if [[ "$MUTED" == "true" ]]; then
    echo ""
    exit 0
fi

if (( VOLUME <= 33 )); then ICON=""
elif (( VOLUME <= 66 )); then ICON=""
else ICON=""
fi

echo "${ICON}"
