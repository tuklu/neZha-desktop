-- PATH for Hyprland-dispatched commands
local _home = os.getenv("HOME") or ""
hl.env("PATH", _home .. "/.local/share/nezha/bin:" .. _home .. "/.local/bin:" .. (os.getenv("PATH") or "/usr/local/bin:/usr/bin:/bin"))

-- Cursor
hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Force Wayland
hl.env("GDK_BACKEND",                 "wayland,x11,*")
hl.env("QT_QPA_PLATFORM",             "wayland;xcb")
hl.env("QT_STYLE_OVERRIDE",           "kvantum")
hl.env("MOZ_ENABLE_WAYLAND",          "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT","wayland")
hl.env("OZONE_PLATFORM",              "wayland")
hl.env("XDG_SESSION_TYPE",            "wayland")

-- Screen sharing / desktop identification
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Compose key input
hl.env("XCOMPOSEFILE", "~/.XCompose")

hl.config({ xwayland   = { force_zero_scaling = true } })
hl.config({ ecosystem  = { no_update_news     = true } })
