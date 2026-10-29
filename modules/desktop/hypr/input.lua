hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "compose:ralt",

        repeat_rate  = 40,
        repeat_delay = 600,

        numlock_by_default = true,

        touchpad = {
            natural_scroll       = true,
            clickfinger_behavior = false,
            scroll_factor        = 0.4,
            disable_while_typing = true,
            drag_lock            = 1,
        },
    },
})

hl.device({
    name        = "logitech-mx-master-3s",
    sensitivity = -0.75,
})

-- Per-app touchpad scroll speed
hl.window_rule({ match = { class = "(kitty|foot)" }, scroll_touchpad = 1.5 })
hl.window_rule({ match = { class = "com.mitchellh.ghostty"  }, scroll_touchpad = 0.2 })

-- Three-finger swipe to change workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
