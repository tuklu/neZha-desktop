local M     = {}
local state = require("state")

local SCALES     = { 1, 1.25, 1.6, 2, 3, 4 }
local SCALE_FILE = os.getenv("HOME") .. "/.config/hypr/state/monitor-scale"

local function notify(msg, urgency)
    urgency = urgency or "low"
    os.execute(string.format("notify-send -u %s '%s' &", urgency, msg))
end

local function hypreval(expr)
    os.execute("hyprctl eval '" .. expr:gsub("'", "'\\''") .. "' &")
end

-- The built-in panel: the first eDP output Hyprland has enabled.
local function internal_monitor()
    for _, m in ipairs(hl.get_monitors()) do
        if m.name:match("^eDP") then return m end
    end
end

-- Hyprland names input devices by their kernel name, lowercased, spaces as dashes.
-- Read from sysfs: calling hyprctl from inside a bind would wait on Hyprland itself.
local function touchpad_device()
    local names = io.popen("cat /sys/class/input/event*/device/name 2>/dev/null")
    local found
    for line in names:lines() do
        local name = line:lower()
        if not found and name:find("touchpad", 1, true) then found = name:gsub(" ", "-") end
    end
    names:close()
    return found
end

-- ── Window actions ────────────────────────────────────────────────────────────

function M.close_all_windows()
    for _, w in ipairs(hl.get_windows()) do
        hl.dispatch(hl.dsp.window.close({ window = "address:" .. w.address }))
    end
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end

function M.toggle_transparency()
    local w = hl.get_active_window()
    if not w then return end
    hl.dispatch(hl.dsp.window.set_prop({
        window = "address:" .. w.address,
        prop   = "opaque",
        value  = "toggle",
    }))
end

function M.window_pop(w, h)
    w = w or 875
    h = h or 600
    local win = hl.get_active_window()
    if not win then return end

    local has_pop = false
    if win.tags then
        for _, tag in ipairs(win.tags) do
            if tag == "pop" then has_pop = true; break end
        end
    end

    if has_pop then
        hl.dispatch(hl.dsp.window.tag({ tag = "-pop" }))
        hl.dispatch(hl.dsp.window.pin())
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    else
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = false }))
        hl.dispatch(hl.dsp.window.center())
        hl.dispatch(hl.dsp.window.pin())
        hl.dispatch(hl.dsp.window.tag({ tag = "+pop" }))
    end
end

-- ── Workspace layout ──────────────────────────────────────────────────────────

function M.toggle_workspace_layout()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local next_layout = (ws.tiled_layout == "dwindle") and "scrolling" or "dwindle"
    -- workspace_rule is init-time only; use hyprctl eval for runtime apply
    hypreval(string.format(
        "hl.workspace_rule({ match = { id = %d }, default_layout = '%s' })",
        ws.id, next_layout
    ))
end

local function monitor_logical_rect(m)
    local scale = tonumber(m.scale) or 1
    if scale == 0 then scale = 1 end

    return {
        x = tonumber(m.x) or 0,
        y = tonumber(m.y) or 0,
        w = (tonumber(m.width) or 0) / scale,
        h = (tonumber(m.height) or 0) / scale,
    }
end

local function active_workspace_monitor(monitors, ws)
    for _, m in ipairs(monitors) do
        if m.active_workspace and ws and m.active_workspace.id == ws.id then
            return m
        end
    end

    for _, m in ipairs(monitors) do
        if m.focused then return m end
    end

    return monitors[1]
end

local function monitor_in_direction(monitors, current, direction)
    local cur = monitor_logical_rect(current)
    local cur_cx = cur.x + cur.w / 2
    local cur_cy = cur.y + cur.h / 2
    local best, best_score

    for _, m in ipairs(monitors) do
        if m.name ~= current.name and not m.disabled then
            local r = monitor_logical_rect(m)
            local cx = r.x + r.w / 2
            local cy = r.y + r.h / 2
            local dx = cx - cur_cx
            local dy = cy - cur_cy
            local primary, secondary

            if direction == "l" and dx < 0 then
                primary, secondary = -dx, math.abs(dy)
            elseif direction == "r" and dx > 0 then
                primary, secondary = dx, math.abs(dy)
            elseif direction == "u" and dy < 0 then
                primary, secondary = -dy, math.abs(dx)
            elseif direction == "d" and dy > 0 then
                primary, secondary = dy, math.abs(dx)
            end

            if primary then
                local score = primary * 100000 + secondary
                if not best_score or score < best_score then
                    best, best_score = m, score
                end
            end
        end
    end

    return best
end

function M.move_workspace_to_monitor(direction)
    local monitors = hl.get_monitors()
    if #monitors < 2 then return end

    local ws = hl.get_active_workspace()
    local current = active_workspace_monitor(monitors, ws)
    if not current then return end

    local target = monitor_in_direction(monitors, current, direction)

    -- With side-by-side monitors, vertical arrows still mean "the other monitor".
    if not target and (direction == "u" or direction == "d") then
        for _, m in ipairs(monitors) do
            if m.name ~= current.name and not m.disabled then
                target = m
                break
            end
        end
    end

    if target then
        hl.dispatch(hl.dsp.workspace.move({ monitor = target.name }))
    end
end

-- ── Monitor scale ─────────────────────────────────────────────────────────────

local function read_scale()
    local f = io.open(SCALE_FILE, "r")
    if f then
        local v = tonumber(f:read("*l"))
        f:close()
        if v then return v end
    end
    return nil
end

local function write_scale(s)
    local f = io.open(SCALE_FILE, "w")
    if f then f:write(tostring(s)); f:close() end
end

function M.cycle_monitor_scale(reverse)
    local mon = hl.get_active_monitor()
    if not mon then return end

    local current = read_scale() or mon.scale
    local idx = 1
    for i, s in ipairs(SCALES) do
        if math.abs(s - current) < 0.01 then idx = i; break end
    end

    local next_idx = reverse
        and ((idx - 2) % #SCALES) + 1
        or  (idx % #SCALES) + 1

    local new_scale = SCALES[next_idx]
    write_scale(new_scale)
    local panel = internal_monitor()
    if not panel then return end
    hypreval(string.format(
        "hl.monitor({ output = '%s', mode = '%dx%d@%.2f', position = '%dx%d'," ..
        " scale = %s, sdr_min_luminance = 0.2, sdr_max_luminance = 80 })",
        panel.name, panel.width, panel.height, panel.refresh_rate, panel.x, panel.y, new_scale
    ))
end

-- ── Internal monitor ──────────────────────────────────────────────────────────

function M.toggle_internal_monitor(action)
    if action == "on" then
        state.disable("internal-monitor-disabled")
    elseif action == "off" then
        state.enable("internal-monitor-disabled")
    else
        state.toggle("internal-monitor-disabled")
    end
    state.reload()
end

-- Mirror: disables internal so external is the sole display
function M.toggle_internal_mirror(action)
    if action == "on" then
        state.enable("internal-monitor-mirror")
    elseif action == "off" then
        state.disable("internal-monitor-mirror")
    else
        state.toggle("internal-monitor-mirror")
    end
    state.reload()
end

function M.recover_monitors()
    local monitors    = hl.get_monitors()
    local has_external = false
    for _, m in ipairs(monitors) do
        if not m.name:match("^eDP") then
            has_external = true
            break
        end
    end
    if not has_external and state.enabled("internal-monitor-disabled") then
        state.disable("internal-monitor-disabled")
        state.reload()
    end
end

-- ── System toggles ───────────────────────────────────────────────────────────

function M.toggle_waybar()
    local cmd = [=[
        lock="${XDG_RUNTIME_DIR:-/tmp}/nezha-waybar-toggle.lock"
        state_dir="${HOME}/.config/hypr/state"
        action=""
        mkdir -p "$state_dir"

        exec 9>"$lock"
        flock -n 9 || exit 0

        if pgrep -u "$USER" -x waybar >/dev/null 2>&1 ||
           pgrep -u "$USER" -f '(^|/)waybar([[:space:]]|$)' >/dev/null 2>&1; then
            pkill -u "$USER" -x waybar 2>/dev/null || true
            pkill -u "$USER" -f '(^|/)waybar([[:space:]]|$)' 2>/dev/null || true
            sleep 0.2
            pkill -KILL -u "$USER" -x waybar 2>/dev/null || true
            pkill -KILL -u "$USER" -f '(^|/)waybar([[:space:]]|$)' 2>/dev/null || true
            : > "$state_dir/waybar-off"
        else
            rm -f "$state_dir/waybar-off"
            action="start"
        fi

        flock -u 9
        exec 9>&-

        if [ "$action" = "start" ]; then
            uwsm-app -- waybar >/dev/null 2>&1 &
        fi
    ]=]

    os.execute(cmd)
end

function M.toggle_touchpad(action)
    local device  = touchpad_device()
    if not device then return end
    local enable
    if action == "on" then
        enable = true
    elseif action == "off" then
        enable = false
    else
        enable = state.enabled("touchpad-disabled")
    end
    if enable then
        state.disable("touchpad-disabled")
        hypreval(string.format("hl.device({ name = '%s', enabled = true })", device))
        -- Trailing space matches the width of 'disabled' so the icon keeps its place.
        os.execute("osd --custom-icon input-touchpad-symbolic --custom-message 'Touchpad enabled ' &")
    else
        state.enable("touchpad-disabled")
        hypreval(string.format("hl.device({ name = '%s', enabled = false })", device))
        os.execute("osd --custom-icon nezha-touchpad-disabled-symbolic --custom-message 'Touchpad disabled' &")
    end
end

function M.toggle_notification_silencing()
    os.execute("makoctl mode -t do-not-disturb")
    local f = io.popen("makoctl mode 2>/dev/null")
    local mode = f and f:read("*l") or ""
    if f then f:close() end
    if mode:find("do%-not%-disturb") then
        notify("Silenced notifications")
    else
        notify("Notifications enabled")
    end
    os.execute("pkill -RTMIN+10 waybar 2>/dev/null; true")
end

function M.toggle_idle()
    -- os.execute's return value is unreliable in Hyprland's Lua, so capture
    -- pgrep's output directly: a PID means hypridle is running.
    local h = io.popen("pgrep -x hypridle 2>/dev/null")
    local running = h and h:read("*a"):match("%d") or false
    if h then h:close() end
    if running then
        os.execute("pkill -x hypridle")
        notify("Stop locking when idle")
    else
        os.execute("setsid uwsm-app -- hypridle >/dev/null 2>&1 &")
        notify("Now locking when idle")
    end
    os.execute("pkill -RTMIN+9 waybar 2>/dev/null; true")
end

function M.toggle_nightlight()
    local ON_TEMP  = 4000
    local OFF_TEMP = 6000
    if not os.execute("pgrep -x hyprsunset >/dev/null 2>&1") then
        os.execute("setsid uwsm-app -- hyprsunset &")
        os.execute("sleep 1")
    end
    local f = io.popen("hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+'")
    local current = tonumber(f and f:read("*l") or "")
    if f then f:close() end
    if current == OFF_TEMP then
        os.execute("hyprctl hyprsunset temperature " .. ON_TEMP .. " &")
        notify("Nightlight on")
    else
        os.execute("hyprctl hyprsunset temperature " .. OFF_TEMP .. " &")
        notify("Daylight temperature")
    end
end

-- ── Zoom ─────────────────────────────────────────────────────────────────────

function M.zoom_in()
    local f = io.popen("hyprctl getoption cursor:zoom_factor -j 2>/dev/null")
    local out = f and f:read("*a") or ""
    if f then f:close() end
    local current = tonumber(out:match('"float"%s*:%s*([%d%.]+)')) or 1.0
    hypreval(string.format("hl.config({ cursor = { zoom_factor = %g } })", current + 1.0))
end

function M.zoom_reset()
    hypreval("hl.config({ cursor = { zoom_factor = 1.0 } })")
end

-- ── Notifications ────────────────────────────────────────────────────────────

function M.show_time()
    notify(os.date("%A %H:%M  ·  %d %B %Y  ·  Week ") .. os.date("%V"))
end

function M.show_battery()
    local f = io.popen("battery-status 2>/dev/null")
    local msg = f and f:read("*a"):gsub("%s+$", "") or "No data"
    if f then f:close() end
    notify(msg)
end

function M.show_weather()
    local f = io.popen("weather 2>/dev/null")
    local msg = f and f:read("*a"):gsub("%s+$", "") or "No data"
    if f then f:close() end
    notify(msg)
end

-- ── Visual toggles ────────────────────────────────────────────────────────────

function M.toggle_gaps()
    state.toggle("no-gaps")
    state.reload()
end

function M.toggle_single_window_aspect()
    local on = state.toggle("single-window-aspect")
    notify(on and "Aspect: square" or "Aspect: default")
    state.reload()
end

return M
