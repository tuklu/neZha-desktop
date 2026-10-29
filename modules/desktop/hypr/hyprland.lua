require("envs")
require("monitors")
require("looknfeel")
require("input")
require("windows")
require("bindings")
require("autostart")

-- Machine and personal additions, linked in by the private overlay. Loaded before
-- hyprmoncfg so its generated layout still has the last word.
do
    local dir = os.getenv("HOME") .. "/.config/nezha/local/hypr"
    local listing = io.popen("ls -1 '" .. dir .. "'/*.lua 2>/dev/null")
    for path in listing:lines() do dofile(path) end
    listing:close()
end

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"; local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
