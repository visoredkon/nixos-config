local H = require("hyprland.helpers")
local V = require("hyprland.variables")

local xdg_runtime = os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. tostring(os.getenv("UID") or 1000))

H.register({
  { V.mainMod .. " + A", hl.dsp.exec_cmd("nc -U " .. xdg_runtime .. "/walker/walker.sock") },
  { V.mainMod .. " + V", hl.dsp.exec_cmd("walker -m clipboard") },
  { V.mainMod .. " + period", hl.dsp.exec_cmd("walker -m symbols") },
  { V.mainMod .. " + K", hl.dsp.exec_cmd("walker -m calc") },
  { V.mainMod .. " + B", hl.dsp.exec_cmd("walker -m providerlist") },
})
