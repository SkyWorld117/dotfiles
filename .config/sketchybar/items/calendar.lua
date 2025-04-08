local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Heavy"],
      size = 13.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = 75,
    align = "right",
    font = {
      family = settings.font.number,
      style = settings.font.style_map["Light"]
    },
  },
  position = "right",
  update_freq = 1,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.bg1,
    border_width = 2
  },
  blur_radius = settings.blur_radius
})

-- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
--  background = {
--    color = colors.transparent,
--    height = 30,
--    border_color = colors.bg2,
--    border_width = 2
--  }
-- })

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a, %b %d"), label = os.date("%H:%M:%S") })
end)

cal:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Calendar'")
end)
