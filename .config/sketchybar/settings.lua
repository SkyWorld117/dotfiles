-- Imports
local fonts = require("fonts")
local colors = require("colors")

-- Settings

-- Paddings and margins
local paddings = 3
local group_paddings = 5

-- Icons and fonts
local icons = "sf-symbols" -- alternatively available: NerdFont
local font = fonts.caskaydia

-- Colors
local bar_color = {
	bg = colors.transparent,
}
local item_color = {
	bg = 0x80000000,
	border = 0xff414550,
	icon = colors.white,
	label = colors.white,
	highlight = colors.white,
}
local popup_color = {
	bg = 0x80000000,
	border = colors.white,
}

-- Blur radius
local blur_radius = 60

-- Defaults
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = font.text,
			style = font.style_map["Bold"],
			size = 14.0,
		},
		color = item_color.icon,
		padding_left = paddings,
		padding_right = paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = font.text,
			style = font.style_map["SemiBold"],
			size = 13.0,
		},
		color = item_color.label,
		padding_left = paddings,
		padding_right = paddings,
	},
	background = {
		height = 28,
		corner_radius = 9,
		color = item_color.bg,
		border_width = 2,
		border_color = item_color.border,
		image = {
			corner_radius = 9,
			border_color = colors.grey,
			border_width = 1,
		},
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			color = popup_color.bg,
			border_color = popup_color.border,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})

-- Return settings table
return {
	paddings = paddings,
	group_paddings = group_paddings,

	icons = icons,
	font = font,

	bar_color = bar_color,
	popup_color = popup_color,
	item_color = item_color,

	blur_radius = blur_radius,
}
