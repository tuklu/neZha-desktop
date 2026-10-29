-- ── Global rules ──────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = ".*" }, tag = "+default-opacity" })
hl.window_rule({
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- ── Floating-window tag behaviour ─────────────────────────────────────────────
hl.window_rule({ match = { tag = "floating-window" }, float  = true      })
hl.window_rule({ match = { tag = "floating-window" }, center = true      })
hl.window_rule({ match = { tag = "floating-window" }, size   = "875 600" })

-- Default opacity
hl.window_rule({ match = { tag = "default-opacity" }, opacity = "0.97 0.9" })

-- ── System popups ─────────────────────────────────────────────────────────────
hl.window_rule({
    match = { class = "(tui\\..*|org.codeberg.dnkl.foot|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|About|TUI.float|imv|mpv)" },
    tag = "+floating-window",
})
hl.window_rule({
    match = {
        class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)",
        title = "(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
    },
    tag = "+floating-window",
})
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true               })

-- ── TUI overrides ────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "^tui\\.yazi$" }, tag  = "-floating-window" })
hl.window_rule({ match = { class = "^tui\\.yazi$" }, tile = true               })
-- Waybar logo click; sized to fit the fastfetch boxes without wrapping
hl.window_rule({ match = { class = "^tui\\.fastfetch-hold$" }, tag    = "-floating-window" })
hl.window_rule({ match = { class = "^tui\\.fastfetch-hold$" }, float  = true               })
hl.window_rule({ match = { class = "^tui\\.fastfetch-hold$" }, center = true               })
hl.window_rule({ match = { class = "^tui\\.fastfetch-hold$" }, size   = "1062 559"         })

-- ── Screensaver ───────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "^org\\.nezha\\.screensaver$" }, tag        = "-floating-window" })
hl.window_rule({ match = { class = "^org\\.nezha\\.screensaver$" }, tile       = true               })
hl.window_rule({ match = { class = "^org\\.nezha\\.screensaver$" }, fullscreen = true               })
hl.window_rule({ match = { class = "^org\\.nezha\\.screensaver$" }, opacity    = "1 1"              })

-- ── nZlauncher ────────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "^nz\\.launcher$" }, float   = true       })
hl.window_rule({ match = { class = "^nz\\.launcher$" }, center  = true       })
hl.window_rule({ match = { class = "^nz\\.launcher$" }, size    = "720 420"  })
hl.window_rule({ match = { class = "^nz\\.launcher$" }, opacity = "0.97 0.97" })
hl.window_rule({ match = { class = "^nz\\.pick$" }, float   = true        })
hl.window_rule({ match = { class = "^nz\\.pick$" }, center  = true        })
hl.window_rule({ match = { class = "^nz\\.pick$" }, size    = "620 360"   })
hl.window_rule({ match = { class = "^nz\\.pick$" }, opacity = "0.97 0.97" })
-- GTK face in window mode (gtk_mode = "window"); overlay mode is a layer surface
hl.window_rule({ match = { class = "^dev\\.tuklu\\.nz$" }, float  = true      })
hl.window_rule({ match = { class = "^dev\\.tuklu\\.nz$" }, center = true      })
hl.window_rule({ match = { class = "^dev\\.tuklu\\.nz$" }, size   = "760 500" })

-- ── Terminals ─────────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "(kitty|com.mitchellh.ghostty|foot)" }, tag = "+terminal"        })
hl.window_rule({ match = { tag   = "terminal"                                     }, tag = "-default-opacity" })
hl.window_rule({ match = { tag   = "terminal"                                     }, opacity = "0.97 0.9"     })

-- ── Browsers ──────────────────────────────────────────────────────────────────
hl.window_rule({ match = { class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)" }, tag = "+chromium-based-browser" })
hl.window_rule({ match = { class = "([fF]irefox|zen|librewolf)"                                                           }, tag = "+firefox-based-browser"  })
hl.window_rule({ match = { tag   = "chromium-based-browser" }, tag     = "-default-opacity" })
hl.window_rule({ match = { tag   = "chromium-based-browser" }, tile    = true               })
hl.window_rule({ match = { tag   = "chromium-based-browser" }, opacity = "1.0 0.97"         })
hl.window_rule({ match = { tag   = "firefox-based-browser"  }, tag     = "-default-opacity" })
hl.window_rule({ match = { tag   = "firefox-based-browser"  }, opacity = "1.0 0.97"         })
-- Hide screen-sharing notification
hl.window_rule({ match = { title = ".*is sharing.*" }, workspace = "special silent" })

-- ── Picture-in-picture ────────────────────────────────────────────────────────
hl.window_rule({ match = { title = "(Picture.?in.?[Pp]icture)" }, tag = "+pip"            })
hl.window_rule({ match = { tag   = "pip" }, tag             = "-default-opacity"           })
hl.window_rule({ match = { tag   = "pip" }, float           = true                         })
hl.window_rule({ match = { tag   = "pip" }, pin             = true                         })
hl.window_rule({ match = { tag   = "pip" }, size            = "600 338"                    })
hl.window_rule({ match = { tag   = "pip" }, keep_aspect_ratio = true                       })
hl.window_rule({ match = { tag   = "pip" }, border_size     = 0                            })
hl.window_rule({ match = { tag   = "pip" }, opacity         = "1 1"                        })
hl.window_rule({ match = { tag   = "pip" }, move = "(monitor_w-window_w-40) (monitor_h*0.04)" })

-- ── Password managers ─────────────────────────────────────────────────────────
-- nosharingusage has no Lua equivalent yet; floating-window tag still applied
hl.window_rule({ match = { class = "^(1[p|P]assword)$"                           }, tag = "+floating-window" })
hl.window_rule({ match = { class = "^(Bitwarden)$"                               }, tag = "+floating-window" })
hl.window_rule({ match = { class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default" }, tag = "+floating-window" })

-- ── Media apps ────────────────────────────────────────────────────────────────
local media_class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
hl.window_rule({ match = { class = media_class }, tag     = "-default-opacity" })
hl.window_rule({ match = { class = media_class }, opacity = "1 1"              })

-- ── App-specific ──────────────────────────────────────────────────────────────
-- Rules for individual apps live outside this repo. Every *.lua in
-- ~/.config/nezha/local/window-rules is loaded here, in name order.
do
    local dir = os.getenv("HOME") .. "/.config/nezha/local/window-rules"
    local listing = io.popen("ls -1 '" .. dir .. "'/*.lua 2>/dev/null")
    for path in listing:lines() do dofile(path) end
    listing:close()
end

-- ── Common tags ───────────────────────────────────────────────────────────────
hl.window_rule({ match = { tag = "pop"    }, rounding     = 8       })
hl.window_rule({ match = { tag = "noidle" }, idle_inhibit = "always" })

-- ── Layer rules ───────────────────────────────────────────────────────────────
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^(notifications|swayosd|waybar|nz-bar)$" }, blur         = true })
hl.layer_rule({ match = { namespace = "^(notifications|swayosd|waybar|nz-bar)$" }, ignore_alpha = 0.1  })
