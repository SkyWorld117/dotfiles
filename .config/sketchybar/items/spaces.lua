local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.icon_map")

local spaces = {}
local paddings = {}
local no_apps = {}
local selects = {}

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers },
			string = i,
			padding_left = 15,
			padding_right = 8,
			color = settings.item_color.border,
			highlight_color = settings.item_color.highlight,
		},
		label = {
			padding_right = 20,
			color = settings.item_color.border,
			highlight_color = settings.item_color.highlight,
			font = "sketchybar-app-font:Regular:12.0",
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			height = 26,
		},
		blur_radius = settings.blur_radius,
	})

	spaces[i] = space

	-- Padding space
	local padding = sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
		background = { drawing = false },
	})

	paddings[i] = padding

	no_apps[i] = true
	selects[i] = false

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and settings.item_color.highlight or settings.item_color.border },
			drawing = selected or not no_apps[tonumber(env.SID)],
		})
		selects[tonumber(env.SID)] = selected
	end)

	padding:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		padding:set({
			drawing = selected or not no_apps[tonumber(env.SID)],
		})
	end)

	space:subscribe("mouse.clicked", function(env)
		sbar.exec("yabai -m space --focus " .. env.SID)
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
	local icon_line = ""
	local no_app = true

	for app, count in pairs(env.INFO.apps) do
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["Default"] or lookup)
		no_app = false
		icon_line = icon_line .. icon
	end

	if no_app then
		icon_line = " —"
	end
	spaces[env.INFO.space]:set({ drawing = not no_app or selects[env.INFO.space] })
	paddings[env.INFO.space]:set({ drawing = not no_app or selects[env.INFO.space] })
	no_apps[env.INFO.space] = no_app

	sbar.animate("tanh", 10, function()
		spaces[env.INFO.space]:set({ label = icon_line })
	end)
end)
