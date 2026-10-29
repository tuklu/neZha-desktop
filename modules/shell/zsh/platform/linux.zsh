open() { xdg-open "$@" >/dev/null 2>&1 & }

alias emu='QT_QPA_PLATFORM=xcb emulator @px10 -no-metrics'
