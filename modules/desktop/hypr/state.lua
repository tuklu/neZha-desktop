local M   = {}
local dir = os.getenv("HOME") .. "/.config/hypr/state/"

os.execute("mkdir -p " .. dir)

function M.enabled(name)
    local f = io.open(dir .. name, "r")
    if f then f:close(); return true end
    return false
end

function M.enable(name)
    local f = io.open(dir .. name, "w")
    if f then f:close() end
end

function M.disable(name)
    os.remove(dir .. name)
end

function M.toggle(name)
    if M.enabled(name) then M.disable(name); return false
    else                     M.enable(name);  return true  end
end

function M.reload()
    os.execute("hyprctl reload &")
end

return M
