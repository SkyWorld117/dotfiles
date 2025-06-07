local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", {
	icon = {
		-- color = colors.white,
		padding_left = 8,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Heavy"],
			size = 13.0,
		},
	},
	label = {
		-- color = colors.white,
		padding_right = 8,
		width = 75,
		align = "right",
		font = {
			family = settings.font.number,
			style = settings.font.style_map["Light"],
		},
	},
	position = "right",
	update_freq = 1,
	padding_left = 1,
	padding_right = 1,
	blur_radius = settings.blur_radius,
})

-- Padding item required
sbar.add("item", { position = "right", width = settings.group_paddings, background = { drawing = false } })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a, %b %d"), label = os.date("%H:%M:%S") })
end)

cal:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Calendar'")
end)
