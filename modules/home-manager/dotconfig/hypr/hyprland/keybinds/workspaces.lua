local V = require("hyprland.variables")

hl.bind(V.mainMod .. " + L", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(V.mainMod .. " + H", hl.dsp.focus({ workspace = "r-1" }))

hl.bind(V.mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))
hl.bind(V.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind(V.mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:special", follow = false }))

hl.bind(V.mainMod .. " + ALT + S", function()
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  hl.dispatch(hl.dsp.window.move({ workspace = "magic" }))
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

for i = 1, 10 do
  local k = i % 10
  hl.bind(V.mainMod .. " + " .. k, hl.dsp.focus({ workspace = i }))
  hl.bind(V.mainMod .. " + SHIFT + " .. k, hl.dsp.window.move({ workspace = i }))
  hl.bind(V.mainMod .. " + CTRL + " .. k, hl.dsp.window.move({ workspace = i, follow = false }))
end
