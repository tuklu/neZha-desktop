local actions = require("actions")

-- ── Media controls ────────────────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",    hl.dsp.exec_cmd("osd --output-volume raise"),       { locked = true, repeating = true, desc = "Volume up" })
hl.bind("XF86AudioLowerVolume",    hl.dsp.exec_cmd("osd --output-volume lower"),       { locked = true, repeating = true, desc = "Volume down" })
hl.bind("XF86AudioMute",           hl.dsp.exec_cmd("osd --output-volume mute-toggle"), { locked = true, desc = "Mute" })
hl.bind("XF86AudioMicMute",        hl.dsp.exec_cmd("audio-mute-input"),                { locked = true, desc = "Mute microphone" })
hl.bind("XF86MonBrightnessUp",     hl.dsp.exec_cmd("brightness +5%"),                 { locked = true, repeating = true, desc = "Brightness up" })
hl.bind("XF86MonBrightnessDown",   hl.dsp.exec_cmd("brightness 5%-"),                 { locked = true, repeating = true, desc = "Brightness down" })
hl.bind("SHIFT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightness 100%"),          { locked = true, desc = "Brightness to full" })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness 1%"),            { locked = true, desc = "Brightness to minimum" })
hl.bind("XF86KbdBrightnessUp",    hl.dsp.exec_cmd("brightness-kbd up"),               { locked = true, repeating = true, desc = "Keyboard light up" })
hl.bind("XF86KbdBrightnessDown",  hl.dsp.exec_cmd("brightness-kbd down"),             { locked = true, repeating = true, desc = "Keyboard light down" })
hl.bind("XF86KbdLightOnOff",      hl.dsp.exec_cmd("brightness-kbd show"),             { locked = true, desc = "Show keyboard light level" })
hl.bind("XF86TouchpadToggle",     function() actions.toggle_touchpad() end,            { locked = true, desc = "Toggle touchpad" })
hl.bind("XF86TouchpadOn",         function() actions.toggle_touchpad("on") end,        { locked = true, desc = "Touchpad on" })
hl.bind("XF86TouchpadOff",        function() actions.toggle_touchpad("off") end,       { locked = true, desc = "Touchpad off" })
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("osd --output-volume +1"),      { locked = true, repeating = true, desc = "Volume up a little" })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd("osd --output-volume -1"),      { locked = true, repeating = true, desc = "Volume down a little" })
hl.bind("code:473",               hl.dsp.exec_cmd("fn-lock-osd"),                      { locked = true, desc = "Show Fn lock state" })
hl.bind("ALT + XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightness +1%"),              { locked = true, repeating = true, desc = "Brightness up a little" })
hl.bind("ALT + XF86MonBrightnessDown",hl.dsp.exec_cmd("brightness 1%-"),              { locked = true, repeating = true, desc = "Brightness down a little" })
hl.bind("XF86AudioNext",   hl.dsp.exec_cmd("osd --playerctl next"),                   { locked = true, desc = "Next track" })
hl.bind("XF86AudioPause",  hl.dsp.exec_cmd("osd --playerctl play-pause"),             { locked = true, desc = "Play or pause" })
hl.bind("XF86AudioPlay",   hl.dsp.exec_cmd("osd --playerctl play-pause"),             { locked = true, desc = "Play or pause" })
hl.bind("XF86AudioPrev",   hl.dsp.exec_cmd("osd --playerctl previous"),               { locked = true, desc = "Previous track" })
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("audio-switch-output"),              { locked = true, desc = "Switch audio output" })

-- ── Clipboard ─────────────────────────────────────────────────────────────────
-- send_shortcut leaves synthetic key state stuck/repeating in HL 0.55 (github.com/hyprwm/Hyprland/discussions/14099)
-- workaround: manually fire key_state down then up with a 50ms gap
local function clipboard_send(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = "activewindow" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = "activewindow" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

hl.bind("SUPER + C",      clipboard_send("CTRL",  "Insert"), { desc = "Copy" })
hl.bind("SUPER + V",      clipboard_send("SHIFT", "Insert"), { desc = "Paste" })
hl.bind("SUPER + X",      clipboard_send("CTRL",  "X"), { desc = "Cut" })
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd('nzlauncher bar "clip "'), { desc = "Clipboard manager" })

-- ── Window management ─────────────────────────────────────────────────────────
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), { desc = "Toggle split direction" })
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { desc = "Pseudo-tile window" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle floating" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen(0), { desc = "Fullscreen" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ client = 0, internal = 2 }), { desc = "Fake fullscreen (window only)" })
hl.bind("SUPER + ALT + F",  hl.dsp.window.fullscreen(1), { desc = "Maximize" })
hl.bind("SUPER + O", function() actions.window_pop() end, { desc = "Pop window out" })
hl.bind("SUPER + L", function() actions.toggle_workspace_layout() end, { desc = "Toggle workspace layout" })

hl.bind("SUPER + LEFT",  hl.dsp.focus({ direction = "l" }), { desc = "Focus left" })
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }), { desc = "Focus right" })
hl.bind("SUPER + UP",    hl.dsp.focus({ direction = "u" }), { desc = "Focus up" })
hl.bind("SUPER + DOWN",  hl.dsp.focus({ direction = "d" }), { desc = "Focus down" })

-- Workspace switching + window movement (1-10)
for i = 1, 10 do
    local code = 9 + i
    hl.bind("SUPER + code:"               .. code, hl.dsp.focus({ workspace = i }),                       { desc = "Workspace " .. i })
    hl.bind("SUPER + SHIFT + code:"       .. code, hl.dsp.window.move({ workspace = i }),                 { desc = "Move window to workspace " .. i })
    hl.bind("SUPER + SHIFT + ALT + code:" .. code, hl.dsp.window.move({ workspace = i, silent = true }), { desc = "Send window to workspace " .. i })
end

-- Scratchpad
hl.bind("SUPER + S",       hl.dsp.workspace.toggle_special("scratchpad"), { desc = "Scratchpad" })
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", silent = true }), { desc = "Move window to scratchpad" })

-- Tab workspace navigation
hl.bind("SUPER + TAB",         hl.dsp.focus({ workspace = "e+1"      }), { desc = "Next workspace" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1"      }), { desc = "Previous workspace" })
hl.bind("SUPER + CTRL + TAB",  hl.dsp.focus({ workspace = "previous" }), { desc = "Last workspace" })

-- Move workspace to monitor
hl.bind("SUPER + SHIFT + ALT + LEFT",  function() actions.move_workspace_to_monitor("l") end, { desc = "Move workspace to left monitor" })
hl.bind("SUPER + SHIFT + ALT + RIGHT", function() actions.move_workspace_to_monitor("r") end, { desc = "Move workspace to right monitor" })
hl.bind("SUPER + SHIFT + ALT + UP",    function() actions.move_workspace_to_monitor("u") end, { desc = "Move workspace to upper monitor" })
hl.bind("SUPER + SHIFT + ALT + DOWN",  function() actions.move_workspace_to_monitor("d") end, { desc = "Move workspace to lower monitor" })

-- Swap windows
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.swap({ direction = "l" }), { desc = "Swap window left" })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }), { desc = "Swap window right" })
hl.bind("SUPER + SHIFT + UP",    hl.dsp.window.swap({ direction = "u" }), { desc = "Swap window up" })
hl.bind("SUPER + SHIFT + DOWN",  hl.dsp.window.swap({ direction = "d" }), { desc = "Swap window down" })

-- Alt-Tab cycle
hl.bind("ALT + Tab",         hl.dsp.window.cycle_next(), { desc = "Next window" })
hl.bind("ALT + Tab",         hl.dsp.window.bring_to_top(), { desc = "Next window" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ prev = true }), { desc = "Previous window" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.bring_to_top(), { desc = "Previous window" })

-- Monitor focus
hl.bind("CTRL + ALT + Tab",         hl.dsp.focus({ monitor = "+1" }), { desc = "Next monitor" })
hl.bind("CTRL + ALT + SHIFT + Tab", hl.dsp.focus({ monitor = "-1" }), { desc = "Previous monitor" })

-- Resize
hl.bind("SUPER + code:20",               hl.dsp.window.resize({ x = -100, y = 0   }), { desc = "Narrower" })
hl.bind("SUPER + code:21",               hl.dsp.window.resize({ x =  100, y = 0   }), { desc = "Wider" })
hl.bind("SUPER + SHIFT + code:20",       hl.dsp.window.resize({ x = 0,   y = -100 }), { desc = "Shorter" })
hl.bind("SUPER + SHIFT + code:21",       hl.dsp.window.resize({ x = 0,   y =  100 }), { desc = "Taller" })
hl.bind("SUPER + ALT + code:20",         hl.dsp.window.resize({ x = -25,  y = 0   }), { desc = "Narrower a little" })
hl.bind("SUPER + ALT + code:21",         hl.dsp.window.resize({ x =  25,  y = 0   }), { desc = "Wider a little" })
hl.bind("SUPER + SHIFT + ALT + code:20", hl.dsp.window.resize({ x = 0,   y = -25  }), { desc = "Shorter a little" })
hl.bind("SUPER + SHIFT + ALT + code:21", hl.dsp.window.resize({ x = 0,   y =  25  }), { desc = "Taller a little" })
hl.bind("SUPER + CTRL + code:20",        hl.dsp.window.resize({ x = -300, y = 0   }), { desc = "Much narrower" })
hl.bind("SUPER + CTRL + code:21",        hl.dsp.window.resize({ x =  300, y = 0   }), { desc = "Much wider" })

-- Mouse
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "Next workspace" })
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { desc = "Previous workspace" })
hl.bind("SUPER + mouse:272",  hl.dsp.window.drag(),   { mouse = true, desc = "Drag window" })
hl.bind("SUPER + mouse:273",  hl.dsp.window.resize(), { mouse = true, desc = "Resize window" })

-- Groups
hl.bind("SUPER + G",                 hl.dsp.group.toggle(), { desc = "Toggle group" })
hl.bind("SUPER + ALT + G",           hl.dsp.group.move_window(), { desc = "Move window out of group" })
hl.bind("SUPER + ALT + LEFT",        hl.dsp.group.move_window({ direction = "l" }), { desc = "Move window into group left" })
hl.bind("SUPER + ALT + RIGHT",       hl.dsp.group.move_window({ direction = "r" }), { desc = "Move window into group right" })
hl.bind("SUPER + ALT + UP",          hl.dsp.group.move_window({ direction = "u" }), { desc = "Move window into group above" })
hl.bind("SUPER + ALT + DOWN",        hl.dsp.group.move_window({ direction = "d" }), { desc = "Move window into group below" })
hl.bind("SUPER + ALT + Tab",         hl.dsp.group.next(), { desc = "Next in group" })
hl.bind("SUPER + ALT + SHIFT + Tab", hl.dsp.group.prev(), { desc = "Previous in group" })
hl.bind("SUPER + CTRL + LEFT",       hl.dsp.group.prev(), { desc = "Previous in group" })
hl.bind("SUPER + CTRL + RIGHT",      hl.dsp.group.next(), { desc = "Next in group" })
hl.bind("SUPER + ALT + mouse_down",  hl.dsp.group.next(), { desc = "Next in group" })
hl.bind("SUPER + ALT + mouse_up",    hl.dsp.group.prev(), { desc = "Previous in group" })

for i = 1, 5 do
    hl.bind("SUPER + ALT + code:" .. (9 + i), hl.dsp.group.active({ index = i }), { desc = "Group tab " .. i })
end

-- Monitor scaling
hl.bind("SUPER + code:61",       function() actions.cycle_monitor_scale() end, { desc = "Cycle display scale" })
hl.bind("SUPER + ALT + code:61", function() actions.cycle_monitor_scale(true) end, { desc = "Cycle display scale back" })

hl.bind("CTRL + ALT + DELETE", function() actions.close_all_windows() end, { desc = "Close all windows" })

-- ── System / utilities ────────────────────────────────────────────────────────
hl.bind("SUPER + SPACE",            hl.dsp.exec_cmd("nzlauncher bar"),                          { desc = "nZlauncher"         })
hl.bind("SUPER + CTRL + E",         hl.dsp.exec_cmd('nzlauncher bar "emoji "'),                 { desc = "Emoji picker"        })
hl.bind("SUPER + CTRL + C",         hl.dsp.exec_cmd('nzlauncher bar "capture "'),             { desc = "Capture menu"        })
hl.bind("SUPER + ESCAPE",           hl.dsp.exec_cmd('nzlauncher bar "power "'),               { desc = "Power menu"          })
hl.bind("XF86PowerOff",             hl.dsp.exec_cmd('nzlauncher bar "power "'),               { locked = true, desc = "Power menu" })
hl.bind("SUPER + K",                hl.dsp.exec_cmd('nzlauncher bar "keys "'),                { desc = "Show key bindings"   })
hl.bind("XF86Calculator",           hl.dsp.exec_cmd("gnome-calculator"),                { desc = "Calculator"          })

hl.bind("SUPER + SHIFT + SPACE",        function() actions.toggle_waybar() end,         { desc = "Toggle top bar"              })
hl.bind("SUPER + BACKSPACE",            function() actions.toggle_transparency() end,   { desc = "Toggle window transparency"  })
hl.bind("SUPER + SHIFT + BACKSPACE",    function() actions.toggle_gaps() end,           { desc = "Toggle window gaps"          })
hl.bind("SUPER + CTRL + BACKSPACE",     function() actions.toggle_single_window_aspect() end, { desc = "Toggle single-window aspect" })

hl.bind("SUPER + COMMA",             hl.dsp.exec_cmd("makoctl dismiss"),                { desc = "Dismiss notification"        })
hl.bind("SUPER + SHIFT + COMMA",     hl.dsp.exec_cmd("makoctl dismiss --all"),         { desc = "Dismiss all notifications"   })
hl.bind("SUPER + CTRL + COMMA",      function() actions.toggle_notification_silencing() end, { desc = "Toggle silencing"       })
hl.bind("SUPER + ALT + COMMA",       hl.dsp.exec_cmd("makoctl invoke"),                { desc = "Invoke last notification"    })
hl.bind("SUPER + SHIFT + ALT + COMMA", hl.dsp.exec_cmd("makoctl restore"),             { desc = "Restore notification"        })

hl.bind("SUPER + CTRL + I",          function() actions.toggle_idle() end,              { desc = "Toggle idle locking"         })
hl.bind("SUPER + CTRL + N",          function() actions.toggle_nightlight() end,        { desc = "Toggle nightlight"           })
hl.bind("SUPER + CTRL + DELETE",       function() actions.toggle_internal_monitor("toggle") end, { desc = "Toggle laptop display"    })
hl.bind("SUPER + CTRL + ALT + DELETE", function() actions.toggle_internal_mirror("toggle") end,  { desc = "Toggle display mirroring" })

hl.bind("PRINT",             hl.dsp.exec_cmd("screenshot fullscreen"),                  { desc = "Screenshot (instant, full screen)" })
hl.bind("SHIFT + PRINT",     hl.dsp.exec_cmd("screenshot"),                             { desc = "Screenshot (snip region/window)"   })
hl.bind("ALT + PRINT",       hl.dsp.exec_cmd("screenrecord --audio"),                   { desc = "Screen recording toggle"     })
hl.bind("SUPER + PRINT",     hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"),     { desc = "Color picker"                })
hl.bind("SUPER + CTRL + PRINT", hl.dsp.exec_cmd("ocr"),                               { desc = "Extract text (OCR)"          })

hl.bind("SUPER + CTRL + PERIOD", hl.dsp.exec_cmd('nzlauncher bar "transcode "'),                { desc = "Transcode"  })

hl.bind("SUPER + CTRL + R",          hl.dsp.exec_cmd('nzlauncher bar "remind "'),            { desc = "Set reminder"     })
hl.bind("SUPER + CTRL + ALT + R",    hl.dsp.exec_cmd("reminder show"),                 { desc = "Show reminders"   })
hl.bind("SUPER + SHIFT + CTRL + R",  hl.dsp.exec_cmd("reminder clear"),                { desc = "Clear reminders"  })

hl.bind("SUPER + CTRL + ALT + T", function() actions.show_time()    end, { desc = "Show time"    })
hl.bind("SUPER + CTRL + ALT + B", function() actions.show_battery() end, { desc = "Show battery" })
hl.bind("SUPER + CTRL + ALT + W", function() actions.show_weather() end, { desc = "Show weather" })

hl.bind("SUPER + CTRL + X",  hl.dsp.exec_cmd("voxtype record toggle"),                 { desc = "Toggle dictation"  })
hl.bind("F9",                hl.dsp.exec_cmd("voxtype record start"),                  { desc = "Start dictation"   })
hl.bind("F9",                hl.dsp.exec_cmd("voxtype record stop"),                   { release = true, desc = "Stop dictation" })

hl.bind("SUPER + CTRL + Z",       function() actions.zoom_in()    end, { desc = "Zoom in"    })
hl.bind("SUPER + CTRL + ALT + Z", function() actions.zoom_reset() end, { desc = "Reset zoom" })

hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("lock-screen"), { desc = "Lock system" })

-- ── Application launchers ─────────────────────────────────────────────────────
hl.bind("SUPER + RETURN",       hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(terminal-cwd)" bash -c "tmux attach || tmux new -s Work"]]), { desc = "Tmux"              })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(terminal-cwd)"]]),                                          { desc = "Terminal"          })
hl.bind("SUPER + B",            hl.dsp.exec_cmd("uwsm-app -- chromium --profile-directory=Default --new-window"),    { desc = "Browser"           })
hl.bind("SUPER + SHIFT + B",    hl.dsp.exec_cmd("uwsm-app -- chromium --incognito"),                                 { desc = "Browser (private)" })
hl.bind("SUPER + SHIFT + F",    hl.dsp.exec_cmd("xdg-terminal-exec yazi"),                                          { desc = "File manager"      })
hl.bind("SUPER + SHIFT + E",    hl.dsp.exec_cmd("uwsm-app -- thunderbird"),                                         { desc = "Email"             })

-- ── Overrides ─────────────────────────────────────────────────────────────────
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + W")
hl.bind("SUPER + Q", hl.dsp.window.close(), { desc = "Close window" })
