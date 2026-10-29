require("full-border"):setup({ type = ui.Border.ROUNDED })

require("git"):setup({ order = 1500 })

require("smart-enter"):setup({ open_multi = true })

require("restore"):setup({
	position = { "center", w = 70, h = 40 },
	show_confirm = true,
	suppress_success_notification = true,
})

-- Fixed bookmarks; ones added at runtime go to ~/.config/yazi/bookmark (gitignored).
local home = os.getenv("HOME")
require("yamb"):setup({
	bookmarks = {
		{ tag = "Home", path = home .. "/", key = "h" },
		{ tag = "Development", path = home .. "/Development/", key = "D" },
		{ tag = "Work", path = home .. "/Work/", key = "w" },
		{ tag = "Downloads", path = home .. "/Downloads/", key = "d" },
		{ tag = "Screenshots", path = home .. "/Pictures/Screenshots/", key = "s" },
		{ tag = "neZha-desktop", path = home .. "/Development/neZha-desktop/", key = "n" },
		{ tag = "Config", path = home .. "/.config/", key = "c" },
	},
	jump_notify = false,
	cli = "fzf",
})
