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
      color = colors.grey,
      highlight_color = colors.white,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:12.0",
      y_offset = 1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg2,
      border_width = 1,
      height = 26,
      border_color = colors.bg1,
    },
    blur_radius = 20,
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[i] = space

  -- Padding space
  local padding = sbar.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = settings.group_paddings,
  })

  paddings[i] = padding

  no_apps[i] = true
  selects[i] = false

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left= 5,
    padding_right= 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and colors.white or colors.bg1 },
      drawing = selected or not no_apps[tonumber(env.SID)]
    })
    selects[tonumber(env.SID)] = selected
  end)

  padding:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    padding:set({
      drawing = selected or not no_apps[tonumber(env.SID)]
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
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
    no_app = false
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
    icon_line = icon_line .. icon
  end

  if (no_app) then
    icon_line = " —"
  end
  spaces[env.INFO.space]:set( { drawing = not no_app or selects[env.INFO.space] } )
  paddings[env.INFO.space]:set( { drawing = not no_app or selects[env.INFO.space] } )
  no_apps[env.INFO.space] = no_app

  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)
