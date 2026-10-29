# neZha-desktop

A Unix setup in one versioned tree, symlinked into place: a Hyprland desktop
on Arch, and the same terminal environment (zsh, neovim, tmux, ghostty, CLI
tools) on Linux and macOS.

## Install

```sh
git clone https://github.com/tuklu/neZha-desktop ~/Development/neZha-desktop
cd ~/Development/neZha-desktop && ./install.sh --packages
```

The first run opens a picker (fzf) to choose modules, or falls back to the
default profile for the OS: `desktop` on Linux, `dev` on macOS. The choice is
saved, so after every pull a plain `./install.sh` repeats it.

```sh
./install.sh --profile dev          # terminal setup only
./install.sh --only nvim,tmux       # exactly these modules
./install.sh --pick                 # choose again
./install.sh --packages             # install what the modules need, first
./install.sh --private <path|url>   # overlay a private repo, applied last
./install.sh --check                # report link status, change nothing
./install.sh --dry-run              # show what would change
```

`install.sh` is idempotent and runs on the bash 3.2 that macOS ships. Anything
already sitting at a target path is moved to `~/.local/state/nezha/backups/`
rather than deleted. With the `git` module and no identity of your own, it asks
for a name and email once.

## Layout

Each directory in `modules/` is one module. `module.conf` says which OS it
applies to, `links` maps its contents to target paths, and optional
`pacman.txt`, `aur.txt` and `brew.txt` list the packages it needs. A
`displace` file lists second config locations the app would also read, which
are backed up out of the way. `profiles` names the module sets.

| Module | OS | Contents |
|---|---|---|
| `theme` | any | links `~/.config/nezha/theme` to the active theme |
| `shell` | any | zsh (vi mode, fzf-tab), starship |
| `git` | any | shared defaults, delta; identity in `~/.config/git/local` |
| `nvim` | any | neovim |
| `tmux` | any | tmux |
| `terminal` | any | ghostty |
| `cli` | any | btop, eza, fastfetch, yazi |
| `zed` | any | zed editor |
| `desktop` | linux | hyprland, waybar, OSD, input, user units, scripts |
| `system` | linux | root-owned SDDM files, never linked; apply by hand |

## Themes

`themes/<name>/` holds everything that is look rather than structure: colors
for each app, wallpapers, the lock screen images. Base configs never carry
colors; they include from the active theme. `themes/current` points at it
(local state, `n1` on a fresh clone). Inside the repo, configs reach it by
repo-relative symlinks; outside it, through `~/.config/nezha/theme`.

`themes/<name>/sources` pins upstream pieces to exact commits. n1 takes its
lock screen layout from
[neZha-Hyprlock-Theme](https://github.com/tuklu/neZha-Hyprlock-Theme);
`install.sh` checks it out and renders it with the theme's colors and images.

Switch with `ln -sfn <name> themes/current`, then reload the desktop.

## Making it yours

Nothing personal or machine-specific lives here. A private overlay repo, in the
same module format, holds it and is applied last with `--private`. Its modules
apply when the selection names them, or always when their `module.conf` says
`always=true`; when it links a target the public tree also links, the private
one wins. Files it links into these directories load last when present:

| Directory | Loaded by |
|---|---|
| `~/.config/nezha/local/zsh/*.zsh` | zsh |
| `~/.config/nezha/local/hypr/*.lua` | Hyprland, before hyprmoncfg's layout |
| `~/.config/nezha/local/window-rules/*.lua` | Hyprland window rules |
| `~/.config/git/local` | git |

Hardware is detected rather than named: the built-in panel is the first eDP
output, the touchpad comes from sysfs.

## Not in git

Images are excluded from history; 120MB of wallpapers and screenshots would be
carried by every clone forever. `assets.txt` records what belongs at each
ignored path.

## Secrets

There are none in this tree, and none should ever land here. Credentials
resolve from a password manager at call time (`op run --env-file` with `op://`
references), and those references live in the private overlay too.

## Vendored

`themes/n1` started from the Ayaka theme (MIT), copied in rather than
submoduled; its LICENSE and README stay with it.
