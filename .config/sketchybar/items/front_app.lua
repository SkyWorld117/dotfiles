local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = {
		string = "󰅂",
		font = {
			style = settings.font.style_map["Heavy"],
			size = 13.0,
		},
	},
	label = {
		font = {
			style = settings.font.style_map["Heavy"],
			size = 13.0,
		},
	},
	updates = true,
	background = { drawing = false },
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)
