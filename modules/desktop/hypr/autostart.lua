local state = require("state")
local NEZHA = os.getenv("HOME") .. "/.local/share/neZha/bin/"

hl.on("hyprland.start", function()
	hl.exec_cmd(NEZHA .. "wallpaper")
	hl.exec_cmd("uwsm-app -- hypridle")
	hl.exec_cmd("uwsm-app -- mako")
	if not state.enabled("waybar-off") then
		hl.exec_cmd("uwsm-app -- waybar")
	end
	hl.exec_cmd("uwsm-app -- fcitx5 --disable notificationitem")
	hl.exec_cmd("uwsm-app -- wl-paste --type text --watch cliphist store")
	hl.exec_cmd("uwsm-app -- wl-paste --type image --watch cliphist store")
	hl.exec_cmd(NEZHA .. "powerprofiles-init")
	hl.exec_cmd(
		"systemctl --user set-environment PATH="
			.. os.getenv("HOME")
			.. "/.local/share/neZha/bin:"
			.. os.getenv("HOME")
			.. "/.local/bin:"
			.. (os.getenv("PATH") or "/usr/local/bin:/usr/bin:/bin")
	)
	hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("uwsm-app -- chromium --profile-directory=Default --no-startup-window")
end)

hl.on("monitor.added", function()
	hl.exec_cmd('rm -f "${XDG_RUNTIME_DIR:-/tmp}"/brightness-bus-*')
end)
hl.on("monitor.removed", function()
	hl.exec_cmd('rm -f "${XDG_RUNTIME_DIR:-/tmp}"/brightness-bus-*')
end)
