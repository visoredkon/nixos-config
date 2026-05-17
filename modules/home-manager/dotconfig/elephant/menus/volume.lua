Name = "volume"
NamePretty = "Volume"
Icon = "audio-speakers"

function GetEntries()
  local handle = io.popen("wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null")
  if not handle then
    return {}
  end
  local output = handle:read("*a")
  handle:close()

  if not output or output == "" then
    return {}
  end

  local vol = tonumber(output:match("([%d.]+)"))
  if not vol then
    return {}
  end

  local muted = output:find("%[MUTED%]") ~= nil
  local pct = math.floor(vol * 100)
  local bar_length = 10
  local filled = math.floor(pct / 100 * bar_length)
  local bar = string.rep("━", filled) .. string.rep("─", bar_length - filled)

  local text = bar .. " " .. pct .. "%"
  if muted then
    text = text .. " [MUTED]"
  end

  return {
    {
      Text = text,
      Subtext = "Volume",
      Actions = {
        activate = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
        increase = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
        decrease = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
      },
    },
  }
end
