# Keybindings Reference
Keybindings for the neZha desktop.
Updated: 2026-09-27

---

## Hyprland

> `SUPER` = Windows/Meta key. `code:20` = `-`, `code:21` = `=`, `code:61` = `/`

### Hardware / Function Keys

| Key | Action |
|-----|--------|
| `Vol Up / Down` | Volume raise / lower |
| `Alt + Vol Up/Down` | Volume +1 / -1 (fine) |
| `Mute` | Toggle mute |
| `Mic Mute` | Toggle mic mute |
| `Brightness Up/Down` | Screen brightness +5% / -5% |
| `Alt + Brightness Up/Down` | Brightness +1% / -1% (fine) |
| `Shift + Brightness Up` | Brightness 100% |
| `Shift + Brightness Down` | Brightness 1% |
| `Kbd Brightness Up/Down` | Keyboard backlight up / down |
| `Kbd Light On/Off` | Cycle keyboard backlight |
| `Touchpad Toggle/On/Off` | Toggle touchpad |
| `Media Next/Prev` | Next / previous track |
| `Media Play/Pause` | Play / pause |
| `SUPER + Mute` | Cycle audio output |
| `F9` (hold) | Dictation (voxtype) — hold to record |
| `Print` | Screenshot (region, opens satty) |
| `Alt + Print` | Screen recording menu |
| `SUPER + Print` | Color picker (hyprpicker) |
| `SUPER + Ctrl + Print` | OCR (extract text from screen region) |
| `XF86Calculator` | Calculator |
| `XF86PowerOff` | System / power menu |

### Window

| Key | Action |
|-----|--------|
| `SUPER + Q` | Close window |
| `SUPER + T` | Toggle float |
| `SUPER + F` | Fullscreen |
| `SUPER + Ctrl + F` | Fake fullscreen (client thinks it's fullscreen) |
| `SUPER + Alt + F` | Maximize (fill monitor, keep borders) |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + J` | Toggle split direction |
| `SUPER + L` | Toggle layout (dwindle ↔ scrolling) |
| `SUPER + O` | Pop window out (float / pin / center toggle) |
| `SUPER + Backspace` | Toggle window transparency |
| `SUPER + Shift + Backspace` | Toggle gaps |
| `SUPER + Ctrl + Backspace` | Toggle single-window aspect ratio |
| `SUPER + ←/→/↑/↓` | Move focus in direction |
| `SUPER + Shift + ←/→/↑/↓` | Swap window in direction |
| `Alt + Tab` | Cycle windows forward |
| `Alt + Shift + Tab` | Cycle windows backward |
| `Ctrl + Alt + Delete` | Close all windows |

### Workspace

| Key | Action |
|-----|--------|
| `SUPER + 1–10` | Switch to workspace 1–10 |
| `SUPER + Shift + 1–10` | Move window to workspace 1–10 |
| `SUPER + Shift + Alt + 1–10` | Move window silently to workspace 1–10 |
| `SUPER + Tab` | Next workspace |
| `SUPER + Shift + Tab` | Previous workspace |
| `SUPER + Ctrl + Tab` | Previous (last visited) workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + Alt + S` | Send window to scratchpad |
| `SUPER + Shift + Alt + ←/→/↑/↓` | Move workspace to monitor in direction |
| `SUPER + mouse scroll` | Cycle workspaces |

### Groups

| Key | Action |
|-----|--------|
| `SUPER + G` | Toggle group |
| `SUPER + Alt + G` | Move window into group |
| `SUPER + Alt + ←/→/↑/↓` | Move window to group in direction |
| `SUPER + Alt + Tab` | Next tab in group |
| `SUPER + Alt + Shift + Tab` | Previous tab in group |
| `SUPER + Ctrl + ←` | Previous tab in group |
| `SUPER + Ctrl + →` | Next tab in group |
| `SUPER + Alt + 1–5` | Jump to group tab by index |
| `SUPER + Alt + mouse scroll` | Cycle group tabs |

### Monitor / Display

| Key | Action |
|-----|--------|
| `SUPER + /` | Cycle monitor scale up |
| `SUPER + Alt + /` | Cycle monitor scale down |
| `Ctrl + Alt + Tab` | Focus next monitor |
| `Ctrl + Alt + Shift + Tab` | Focus previous monitor |
| `SUPER + Ctrl + Delete` | Toggle laptop display |
| `SUPER + Ctrl + Alt + Delete` | Toggle display mirroring |
| `SUPER + mouse:LMB` (drag) | Move floating window |
| `SUPER + mouse:RMB` (drag) | Resize floating window |

### Resize (floating / tiled)

| Key | Action |
|-----|--------|
| `SUPER + -` / `SUPER + =` | Resize width -100 / +100 |
| `SUPER + Shift + -/=` | Resize height -100 / +100 |
| `SUPER + Alt + -/=` | Resize width -25 / +25 (fine) |
| `SUPER + Shift + Alt + -/=` | Resize height -25 / +25 (fine) |
| `SUPER + Ctrl + -/=` | Resize width -300 / +300 (coarse) |

### Clipboard

| Key | Action |
|-----|--------|
| `SUPER + C` | Copy |
| `SUPER + X` | Cut |
| `SUPER + V` | Paste |
| `SUPER + Ctrl + V` | Clipboard history (walker) |

### Notifications

| Key | Action |
|-----|--------|
| `SUPER + ,` | Dismiss notification |
| `SUPER + Shift + ,` | Dismiss all notifications |
| `SUPER + Ctrl + ,` | Toggle DND (silence notifications) |
| `SUPER + Alt + ,` | Invoke last notification action |
| `SUPER + Shift + Alt + ,` | Restore dismissed notification |

### System

| Key | Action |
|-----|--------|
| `SUPER + Space` | nZlauncher |
| `SUPER + Ctrl + E` | Emoji picker (nZlauncher) |
| `SUPER + Ctrl + L` | Lock screen |
| `SUPER + Ctrl + I` | Toggle idle / auto-lock |
| `SUPER + Ctrl + N` | Toggle nightlight (4000K ↔ 6000K) |
| `SUPER + Ctrl + Z` | Zoom in |
| `SUPER + Ctrl + Alt + Z` | Reset zoom |
| `SUPER + Ctrl + Alt + T` | Show time (notification) |
| `SUPER + Ctrl + Alt + B` | Show battery status |
| `SUPER + Ctrl + Alt + W` | Show weather |
| `SUPER + Shift + Space` | Toggle waybar |
| `SUPER + K` | Show keybindings (nZlauncher) |
| `SUPER + Escape` | System / power menu |
| `SUPER + Ctrl + X` | Toggle dictation |

### App Launchers

| Key | Action |
|-----|--------|
| `SUPER + Return` | Terminal in tmux (attach or new session) |
| `SUPER + Shift + Return` | Terminal (ghostty, cwd-aware) |
| `SUPER + B` | Browser, personal profile (Default), new window |
| `SUPER + Shift + B` | Browser, incognito |
| `SUPER + Shift + F` | File manager (yazi, tiled) |
| `SUPER + Shift + E` | Email (Thunderbird) |

---

## tmux

> Prefix: `Alt+Space` or `Ctrl+Space`

### No-prefix (always active)

| Key | Action |
|-----|--------|
| `Alt + 1–9` | Switch to window 1–9 |
| `Alt + ←` / `Alt + →` | Previous / next window |
| `Alt + Shift + ←` | Swap window left |
| `Alt + Shift + →` | Swap window right |
| `Alt + ↑` / `Alt + ↓` | Previous / next session |
| `Ctrl + Alt + ←/→/↑/↓` | Move focus to pane in direction |
| `Ctrl + Alt + Shift + ←/→/↑/↓` | Resize pane in direction (×5) |

### Prefix + key

| Key | Action |
|-----|--------|
| `prefix + h` | Split pane horizontal (new pane below) |
| `prefix + v` | Split pane vertical (new pane right) |
| `prefix + x` | Kill pane |
| `prefix + c` | New window (cwd) |
| `prefix + k` | Kill window |
| `prefix + r` | Rename window |
| `prefix + C` | New session (cwd) |
| `prefix + K` | Kill session |
| `prefix + R` | Rename session |
| `prefix + P` | Switch to previous session |
| `prefix + N` | Switch to next session |
| `prefix + q` | Reload tmux config |

### Copy mode (`prefix + [` to enter)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Copy selection and exit |
| (vi motions) | Navigate — mode is vi |

---

## Neovim (LazyVim)

> Leader: `Space`. All custom keymaps: none (using LazyVim defaults).

### Essential LazyVim defaults

| Key | Action |
|-----|--------|
| `Space + Space` | Find files |
| `Space + /` | Grep in project |
| `Space + e` | File explorer (neo-tree) |
| `Space + gg` | Lazygit |
| `Space + bd` | Delete buffer |
| `Space + l` | Lazy (plugin manager) |
| `Space + cm` | Mason (LSP installer) |
| `Space + cr` | Rename symbol |
| `Space + ca` | Code action |
| `Space + cf` | Format file |
| `Space + xx` | Diagnostics |
| `Ctrl + h/j/k/l` | Navigate splits |
| `Ctrl + s` | Save file |
| `g + d` | Go to definition |
| `g + r` | Go to references |
| `K` | Hover docs |
| `[d` / `]d` | Previous / next diagnostic |

---

## Yazi (custom bindings only)

> All standard yazi bindings apply. These are additions or overrides.
> Launch with `y` to have the shell follow yazi's directory on quit (`q`), `Q` to stay put.

### Navigation

| Key | Action |
|-----|--------|
| `l` / `Enter` | Enter directory or open file (smart-enter) |
| `F` | Smart filter, auto-enters a single matching directory |
| `T` | Maximize / restore the preview pane |
| `b b` | Jump to bookmark by key |
| `b f` | Jump to bookmark via fzf |
| `b a` | Bookmark current directory |
| `b d` / `b D` | Delete bookmark (by key / fzf) |
| `b r` | Rename bookmark |

Fixed bookmarks: `h` home, `D` Development, `w` Work, `d` Downloads, `s` Screenshots, `n` neZha-desktop, `c` ~/.config.

### Convert (`C`, via `nz-convert`)

Output is written next to the source, never overwriting (`name-1.ext`, ...).

| Key | Target | Sources |
|-----|--------|---------|
| `C p` | PNG | image, svg, pdf (one per page), video (frame) |
| `C j` | JPG | image, pdf (one per page), video (frame) |
| `C w` | WebP | image |
| `C a` | AVIF | image |
| `C i` | ICO | image (16 to 256 px multi-size) |
| `C m` | MP4 | video, gif |
| `C e` | WebM | video, gif |
| `C g` | GIF | video, image |
| `C 3` | MP3 | audio, video (audio track) |
| `C o` | Opus | audio, video |
| `C f` | FLAC | audio, video |
| `C v` | WAV | audio, video |
| `C d` | PDF | office docs, markdown, html, image |
| `C x` | DOCX | office docs, markdown, html |
| `C h` | HTML | office docs, markdown |
| `C M` | Markdown | docx, odt, epub, html |

### Archive (`X`)

| Key | Action |
|-----|--------|
| `X x` | Extract here |
| `X a` | Archive selection |
| `X p` | Archive with password |
| `X h` | Archive with password + encrypted header |
| `X l` | Archive with compression level |
| `X u` | Archive with password + header + level |

### Images (`i`)

| Key | Action |
|-----|--------|
| `i i` | Compress hovered image |
| `i d` | Compress all images in directory |
| `i 5` / `i 7` / `i 9` | Resize to 50% / 70% / 90% |

### Files and tools

| Key | Action |
|-----|--------|
| `u` | Restore last trashed files |
| `U` | Restore trashed files (pick) |
| `c y` | Copy selected files to clipboard (paste into browser, chat, file pickers) |
| `c Y` | Copy hovered file contents (text or image) |
| `c m` | Chmod selection |
| `=` | Diff selected file with hovered |
| `M` | Mount / unmount drives |
| `Ctrl + n` | Drag selection into another app (ripdrag) |
| `Ctrl + g` | lazygit in current directory |
| `!` | Shell in current directory |

### Previews

Markdown renders through glow, audio/video show mediainfo (codec, bitrate, duration),
opaque binaries show a hexyl dump, and the file list carries a git status column.
