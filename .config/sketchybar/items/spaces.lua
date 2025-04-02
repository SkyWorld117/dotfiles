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
      border_width = 2,
      height = 26,
      border_color = colors.bg1,
    },
    blur_radius = settings.blur_radius,
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

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

space_window_observer:subscribe("space_windows_change", function(env)
    -- Orion needs to be handled separately
    -- It creates Orion Preview windows on every space change

    local json = io.popen("yabai -m query --windows --space " .. env.INFO.space .. " | jq -c '.[]'"):read("*a")

    local icon_line = ""
    local no_app = true
    local window_table = {}

    for entry in json:gmatch("{.-}") do
        local app = entry:match('"app"%s*:%s*"([^"]+)"')
        local title = entry:match('"title"%s*:%s*"([^"]+)"')
        if app and title then
            table.insert(window_table, { app = app, title = title })
        end
    end

    for _, entry in ipairs(window_table) do
        if (entry.app == "Orion" and entry.title ~= "Orion Preview") then
            local icon = app_icons["Orion"]
            icon_line = icon_line .. icon
            no_app = false
        end
    end

    -- local orion_preview = 0
    -- for entry in json:gmatch('"title"%s*:%s*"Orion Preview"') do
    --     orion_preview = orion_preview + 1
    -- end

    for app, count in pairs(env.INFO.apps) do
        if (app ~= "Orion") then
            local lookup = app_icons[app]
            local icon = ((lookup == nil) and app_icons["Default"] or lookup)
            no_app = false
            icon_line = icon_line .. icon
        end
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
