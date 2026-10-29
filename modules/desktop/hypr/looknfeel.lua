-- neZha palette
local background      = "rgba(000000ff)"
local accent          = "rgba(e65c5cff)"
local inactive_border = "rgba(404040ff)"
local shadow_color    = "rgba(00000066)"

hl.config({
    general = {
        gaps_in                 = 4,
        gaps_out                = 6,
        border_size             = 2,
        col                     = {
            active_border   = accent,
            inactive_border = inactive_border,
        },
        resize_on_border        = true,
        extend_border_grab_area = 15,
        allow_tearing           = false,
        layout                  = "dwindle",
    },

    decoration = {
        rounding          = 10,
        active_opacity    = 0.98,
        inactive_opacity  = 0.9,
        fullscreen_opacity = 1.0,

        shadow = {
            enabled        = true,
            range          = 16,
            render_power   = 3,
            color          = shadow_color,
            color_inactive = shadow_color,
            offset         = "0 0",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            contrast          = 1.5,
            brightness        = 0.8,
            vibrancy          = 0.2,
            vibrancy_darkness = 0.2,
            noise             = 0.07,
            ignore_opacity    = true,
            new_optimizations = true,
            special           = true,
        },
    },

    group = {
        col = {
            border_active          = accent,
            border_inactive        = inactive_border,
            border_locked_active   = accent,
            border_locked_inactive = inactive_border,
        },
        groupbar = {
            font_size                 = 12,
            font_family               = "monospace",
            font_weight_active        = "ultraheavy",
            font_weight_inactive      = "normal",
            indicator_height          = 0,
            indicator_gap             = 5,
            height                    = 22,
            gaps_in                   = 5,
            gaps_out                  = 0,
            text_color                = "rgb(ffffff)",
            text_color_inactive       = "rgba(ffffff90)",
            col                       = {
                active   = "rgba(00000040)",
                inactive = "rgba(00000020)",
            },
            gradients                 = true,
            gradient_rounding         = 0,
            gradient_round_only_edges = false,
        },
    },

    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },

    scrolling = {
        column_width = 0.49,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        disable_scale_notification = true,
        focus_on_activate          = true,
        anr_missed_pings           = 3,
        on_focus_under_fullscreen  = 1,
        background_color           = background,
        key_press_enables_dpms     = true,
        mouse_move_enables_dpms    = true,
    },

    cursor = {
        hide_on_key_press        = true,
        warp_on_change_workspace = 1,
    },

    binds = {
        hide_special_on_workspace_change = true,
    },

    animations = {
        enabled = true,
    },
})

-- Bezier curves
hl.curve("snappy",       { type = "bezier", points = { {0.22, 1.0},  {0.35, 1.0}  } })
hl.curve("smooth",       { type = "bezier", points = { {0.23, 1.0},  {0.32, 1.0}  } })
hl.curve("slide",        { type = "bezier", points = { {0.165, 0.84},{0.44, 1.0}  } })
hl.curve("overshot",     { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.08} } })
hl.curve("macspring",    { type = "bezier", points = { {0.18, 1.08}, {0.35, 1.06} } })
hl.curve("md3_standard", { type = "bezier", points = { {0.2,  0.0},  {0.0,  1.0}  } })
hl.curve("md3_accel",    { type = "bezier", points = { {0.3,  0.0},  {0.8,  0.15} } })

-- Animations
hl.animation({ leaf = "windows",         enabled = true, speed = 3,   bezier = "snappy",       style = "slide"     })
hl.animation({ leaf = "windowsIn",       enabled = true, speed = 4,   bezier = "macspring",    style = "popin 85%" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 3,   bezier = "snappy",       style = "popin 85%" })
hl.animation({ leaf = "windowsMove",     enabled = true, speed = 3,   bezier = "snappy"                           })
hl.animation({ leaf = "fade",            enabled = true, speed = 4,   bezier = "smooth"                           })
hl.animation({ leaf = "fadeIn",          enabled = true, speed = 3,   bezier = "smooth"                           })
hl.animation({ leaf = "fadeOut",         enabled = true, speed = 2,   bezier = "smooth"                           })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 4,   bezier = "slide"                            })
hl.animation({ leaf = "layersIn",        enabled = true, speed = 1.5, bezier = "overshot",     style = "popin 80%" })
hl.animation({ leaf = "layersOut",       enabled = true, speed = 1.3, bezier = "md3_accel",    style = "popin 90%" })
hl.animation({ leaf = "layers",          enabled = true, speed = 1.5, bezier = "md3_standard"                     })
hl.animation({ leaf = "specialWorkspace",enabled = true, speed = 3,   bezier = "smooth"                           })
hl.animation({ leaf = "border",          enabled = true, speed = 5,   bezier = "smooth"                           })
hl.animation({ leaf = "borderangle",     enabled = true, speed = 7,   bezier = "smooth"                           })

-- ── State-based overrides ─────────────────────────────────────────────────────
local state = require("state")

if state.enabled("no-gaps") then
    hl.config({ general    = { gaps_in = 0, gaps_out = 0, border_size = 0 } })
    hl.config({ decoration = { rounding = 0 } })
end

if state.enabled("single-window-aspect") then
    hl.config({ layout = { single_window_aspect_ratio = { 1, 1 } } })
end
