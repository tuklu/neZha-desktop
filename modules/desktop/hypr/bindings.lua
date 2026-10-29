local actions = require("actions")

-- ── Media controls ────────────────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",    hl.dsp.exec_cmd("osd --output-volume raise"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",    hl.dsp.exec_cmd("osd --output-volume lower"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",           hl.dsp.exec_cmd("osd --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",        hl.dsp.exec_cmd("audio-mute-input"),                { locked = true })
hl.bind("XF86MonBrightnessUp",     hl.dsp.exec_cmd("brightness +5%"),                 { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",   hl.dsp.exec_cmd("brightness 5%-"),                 { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightness 100%"),          { locked = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness 1%"),            { locked = true })
hl.bind("XF86KbdBrightnessUp",    hl.dsp.exec_cmd("brightness-kbd up"),               { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown",  hl.dsp.exec_cmd("brightness-kbd down"),             { locked = true, repeating = true })
hl.bind("XF86KbdLightOnOff",      hl.dsp.exec_cmd("brightness-kbd show"),             { locked = true })
hl.bind("XF86TouchpadToggle",     function() actions.toggle_touchpad() end,            { locked = true })
hl.bind("XF86TouchpadOn",         function() actions.toggle_touchpad("on") end,        { locked = true })
hl.bind("XF86TouchpadOff",        function() actions.toggle_touchpad("off") end,       { locked = true })
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("osd --output-volume +1"),      { locked = true, repeating = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd("osd --output-volume -1"),      { locked = true, repeating = true })
hl.bind("code:473",               hl.dsp.exec_cmd("fn-lock-osd"),                      { locked = true })
hl.bind("ALT + XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightness +1%"),              { locked = true, repeating = true })
hl.bind("ALT + XF86MonBrightnessDown",hl.dsp.exec_cmd("brightness 1%-"),              { locked = true, repeating = true })
hl.bind("XF86AudioNext",   hl.dsp.exec_cmd("osd --playerctl next"),                   { locked = true })
hl.bind("XF86AudioPause",  hl.dsp.exec_cmd("osd --playerctl play-pause"),             { locked = true })
hl.bind("XF86AudioPlay",   hl.dsp.exec_cmd("osd --playerctl play-pause"),             { locked = true })
hl.bind("XF86AudioPrev",   hl.dsp.exec_cmd("osd --playerctl previous"),               { locked = true })
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("audio-switch-output"),              { locked = true })

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

hl.bind("SUPER + C",      clipboard_send("CTRL",  "Insert"))
hl.bind("SUPER + V",      clipboard_send("SHIFT", "Insert"))
hl.bind("SUPER + X",      clipboard_send("CTRL",  "X"))
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd('nz bar "clip "'), { desc = "Clipboard manager" })

-- ── Window management ─────────────────────────────────────────────────────────
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen(0))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ client = 0, internal = 2 }))
hl.bind("SUPER + ALT + F",  hl.dsp.window.fullscreen(1))
hl.bind("SUPER + O", function() actions.window_pop() end)
hl.bind("SUPER + L", function() actions.toggle_workspace_layout() end)

hl.bind("SUPER + LEFT",  hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP",    hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN",  hl.dsp.focus({ direction = "d" }))

-- Workspace switching + window movement (1-10)
for i = 1, 10 do
    local code = 9 + i
    hl.bind("SUPER + code:"               .. code, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + code:"       .. code, hl.dsp.window.move({ workspace = i }))
    hl.bind("SUPER + SHIFT + ALT + code:" .. code, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Scratchpad
hl.bind("SUPER + S",       hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", silent = true }))

-- Tab workspace navigation
hl.bind("SUPER + TAB",         hl.dsp.focus({ workspace = "e+1"      }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1"      }))
hl.bind("SUPER + CTRL + TAB",  hl.dsp.focus({ workspace = "previous" }))

-- Move workspace to monitor
hl.bind("SUPER + SHIFT + ALT + LEFT",  function() actions.move_workspace_to_monitor("l") end)
hl.bind("SUPER + SHIFT + ALT + RIGHT", function() actions.move_workspace_to_monitor("r") end)
hl.bind("SUPER + SHIFT + ALT + UP",    function() actions.move_workspace_to_monitor("u") end)
hl.bind("SUPER + SHIFT + ALT + DOWN",  function() actions.move_workspace_to_monitor("d") end)

-- Swap windows
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP",    hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN",  hl.dsp.window.swap({ direction = "d" }))

-- Alt-Tab cycle
hl.bind("ALT + Tab",         hl.dsp.window.cycle_next())
hl.bind("ALT + Tab",         hl.dsp.window.bring_to_top())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ prev = true }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.bring_to_top())

-- Monitor focus
hl.bind("CTRL + ALT + Tab",         hl.dsp.focus({ monitor = "+1" }))
hl.bind("CTRL + ALT + SHIFT + Tab", hl.dsp.focus({ monitor = "-1" }))

-- Resize
hl.bind("SUPER + code:20",               hl.dsp.window.resize({ x = -100, y = 0   }))
hl.bind("SUPER + code:21",               hl.dsp.window.resize({ x =  100, y = 0   }))
hl.bind("SUPER + SHIFT + code:20",       hl.dsp.window.resize({ x = 0,   y = -100 }))
hl.bind("SUPER + SHIFT + code:21",       hl.dsp.window.resize({ x = 0,   y =  100 }))
hl.bind("SUPER + ALT + code:20",         hl.dsp.window.resize({ x = -25,  y = 0   }))
hl.bind("SUPER + ALT + code:21",         hl.dsp.window.resize({ x =  25,  y = 0   }))
hl.bind("SUPER + SHIFT + ALT + code:20", hl.dsp.window.resize({ x = 0,   y = -25  }))
hl.bind("SUPER + SHIFT + ALT + code:21", hl.dsp.window.resize({ x = 0,   y =  25  }))
hl.bind("SUPER + CTRL + code:20",        hl.dsp.window.resize({ x = -300, y = 0   }))
hl.bind("SUPER + CTRL + code:21",        hl.dsp.window.resize({ x =  300, y = 0   }))

-- Mouse
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Groups
hl.bind("SUPER + G",                 hl.dsp.group.toggle())
hl.bind("SUPER + ALT + G",           hl.dsp.group.move_window())
hl.bind("SUPER + ALT + LEFT",        hl.dsp.group.move_window({ direction = "l" }))
hl.bind("SUPER + ALT + RIGHT",       hl.dsp.group.move_window({ direction = "r" }))
hl.bind("SUPER + ALT + UP",          hl.dsp.group.move_window({ direction = "u" }))
hl.bind("SUPER + ALT + DOWN",        hl.dsp.group.move_window({ direction = "d" }))
hl.bind("SUPER + ALT + Tab",         hl.dsp.group.next())
hl.bind("SUPER + ALT + SHIFT + Tab", hl.dsp.group.prev())
hl.bind("SUPER + CTRL + LEFT",       hl.dsp.group.prev())
hl.bind("SUPER + CTRL + RIGHT",      hl.dsp.group.next())
hl.bind("SUPER + ALT + mouse_down",  hl.dsp.group.next())
hl.bind("SUPER + ALT + mouse_up",    hl.dsp.group.prev())

for i = 1, 5 do
    hl.bind("SUPER + ALT + code:" .. (9 + i), hl.dsp.group.active({ index = i }))
end

-- Monitor scaling
hl.bind("SUPER + code:61",       function() actions.cycle_monitor_scale() end)
hl.bind("SUPER + ALT + code:61", function() actions.cycle_monitor_scale(true) end)

hl.bind("CTRL + ALT + DELETE", function() actions.close_all_windows() end)

-- ── System / utilities ────────────────────────────────────────────────────────
hl.bind("SUPER + SPACE",            hl.dsp.exec_cmd("nz bar"),                          { desc = "nZlauncher"         })
hl.bind("SUPER + CTRL + E",         hl.dsp.exec_cmd('nz bar "emoji "'),                 { desc = "Emoji picker"        })
hl.bind("SUPER + CTRL + C",         hl.dsp.exec_cmd('nz bar "capture "'),             { desc = "Capture menu"        })
hl.bind("SUPER + ESCAPE",           hl.dsp.exec_cmd('nz bar "power "'),               { desc = "Power menu"          })
hl.bind("XF86PowerOff",             hl.dsp.exec_cmd('nz bar "power "'),               { locked = true, desc = "Power menu" })
hl.bind("SUPER + K",                hl.dsp.exec_cmd('nz bar "keys "'),                { desc = "Show key bindings"   })
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

hl.bind("SUPER + CTRL + PERIOD", hl.dsp.exec_cmd('nz bar "transcode "'),                { desc = "Transcode"  })

hl.bind("SUPER + CTRL + R",          hl.dsp.exec_cmd('nz bar "remind "'),            { desc = "Set reminder"     })
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
