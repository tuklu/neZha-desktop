#!/usr/bin/env bash

if ! command -v hyprctl &> /dev/null; then
    echo "hyprctl missing"
    exit 1
fi

# Directly grabs the first active keymap line and strips extra spaces
RAW_LAYOUT=$(hyprctl devices | awk -F': ' '/active keymap:/ {print $2; exit}' | xargs)

if [[ "$RAW_LAYOUT" == "English (US)" ]]; then
    LAYOUT="U.S"
elif [[ "$RAW_LAYOUT" == "English (UK)" ]]; then
    LAYOUT="U.K"
elif [[ "$RAW_LAYOUT" == "English (Dvorak)" ]]; then
    LAYOUT="DVK"
else
    # Fallback: grabs text inside parentheses, or just the first 3 letters
    LAYOUT=$(echo "$RAW_LAYOUT" | awk -F '[()]' '{print $2}')
    [[ -z "$LAYOUT" ]] && LAYOUT="${RAW_LAYOUT:0:3}"
fi

echo "${LAYOUT} "
