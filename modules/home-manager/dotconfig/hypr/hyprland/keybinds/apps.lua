local H = require("hyprland.helpers")
local V = require("hyprland.variables")

H.register({
  { V.mainMod .. " + D", hl.dsp.exec_cmd("discord") },
  { V.mainMod .. " + F", hl.dsp.exec_cmd(V.browser) },
  { V.mainMod .. " + O", hl.dsp.exec_cmd("obsidian --force-device-scale-factor=1.5") },
  { V.mainMod .. " + T", hl.dsp.exec_cmd(V.terminal) },
})
