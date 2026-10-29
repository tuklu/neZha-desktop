-- Minimal Hyprland config for the SDDM Wayland greeter.
-- SDDM starts the greeter itself after the compositor is ready.
hl.config({
  misc = {
    disable_hyprland_logo    = true,
    disable_splash_rendering = true,
    force_default_wallpaper  = 0,
    -- The console before this is black and the theme fades in over black, so
    -- painting black here removes the one intermediate surface at boot.
    background_color         = "rgb(000000)",
  },
  animations = {
    enabled = false,
  },
})
