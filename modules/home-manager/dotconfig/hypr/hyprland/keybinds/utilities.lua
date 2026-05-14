local H = require("hyprland.helpers")
local V = require("hyprland.variables")

H.register({
  { V.mainMod .. " + ALT + G", hl.dsp.exec_cmd(V.scriptGame) },
  { V.mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock") },
  { V.mainMod .. " + DELETE", hl.dsp.exec_cmd("uwsm stop") },
  { V.mainMod .. " + ESCAPE", hl.dsp.exec_cmd(V.killAllCommand .. " waybar || waybar") },
  { V.mainMod .. " + A", hl.dsp.exec_cmd(V.scriptToggle .. " " .. V.menu) },
  { V.mainMod .. " + C", hl.dsp.exec_cmd(V.scriptToggle .. " " .. V.terminal .. " --class nvim -e nvim") },
  { V.mainMod .. " + E", hl.dsp.exec_cmd(V.scriptToggle .. " " .. V.terminal .. " --class yazi -e yazi") },
  { "CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd(V.scriptToggle .. " " .. V.terminal .. " --class btop -e btop") },
  { V.mainMod .. " + V", hl.dsp.exec_cmd("pkill rofi || " .. V.scriptClipboard .. " c") },
  { V.mainMod .. " + CTRL + V", hl.dsp.exec_cmd("pkill rofi || " .. V.scriptClipboard .. " d") },
  { V.mainMod .. " + ALT + V", hl.dsp.exec_cmd("pkill rofi || " .. V.scriptClipboard .. " w") },
  { V.mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(V.scriptScreenshot .. " all") },
  { "print", hl.dsp.exec_cmd(V.scriptScreenshot .. " silent") },
  { V.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(V.scriptScreenshot .. " rect") },
  { V.mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(V.scriptScreenshot .. " window") },
})
