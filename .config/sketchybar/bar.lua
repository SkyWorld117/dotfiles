local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 40,
	color = settings.bar_color.bg,
	padding_right = 8,
	padding_left = 8,
})
