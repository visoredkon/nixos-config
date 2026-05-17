Name = "brightness"
NamePretty = "Brightness"
Icon = "video-display"

function GetEntries()
  local handle = io.popen("brightnessctl get 2>/dev/null")
  if not handle then
    return {}
  end
  local current = tonumber(handle:read("*a"))
  handle:close()

  local max_handle = io.popen("brightnessctl max 2>/dev/null")
  if not max_handle then
    return {}
  end
  local max = tonumber(max_handle:read("*a"))
  max_handle:close()

  if not current or not max or max == 0 then
    return {}
  end

  local pct = math.floor((current / max) * 100)
  local bar_length = 10
  local filled = math.floor(pct / 100 * bar_length)
  local bar = string.rep("━", filled) .. string.rep("─", bar_length - filled)

  return {
    {
      Text = bar .. " " .. pct .. "%",
      Subtext = "Brightness",
      Actions = {
        activate = "brightnessctl -q set 5%+",
        increase = "brightnessctl -q set 5%+",
        decrease = "brightnessctl -q set 5%-",
      },
    },
  }
end
