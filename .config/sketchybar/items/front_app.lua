local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    string = "󰅂",
    color = colors.white,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Heavy"],
      size = 13.0,
    },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Heavy"],
      size = 13.0,
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

-- front_app:subscribe("mouse.clicked", function(env)
--   sbar.trigger("swap_menus_and_spaces")
-- end)
