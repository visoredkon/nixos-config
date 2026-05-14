local H = require("hyprland.helpers")
local V = require("hyprland.variables")

H.register({
  { V.mainMod .. " + Q", hl.dsp.window.close() },
  { V.mainMod .. " + ALT + Q", hl.dsp.window.kill() },
  { V.mainMod .. " + Return", hl.dsp.window.fullscreen({ action = "toggle" }) },
  { V.mainMod .. " + G", hl.dsp.group.toggle() },
  { V.mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }) },
  { V.mainMod .. " + CTRL + P", hl.dsp.window.pin() },
  { V.mainMod .. " + P", hl.dsp.window.pseudo() },
  { V.mainMod .. " + J", hl.dsp.layout("togglesplit") },
})

local dirs = { H = "l", J = "d", K = "u", L = "r" }
for letter, dir in pairs(dirs) do
  hl.bind(V.mainMod .. " + CTRL + " .. letter, hl.dsp.focus({ direction = dir }))
  hl.bind(V.mainMod .. " + SHIFT + " .. letter, hl.dsp.window.move({ direction = dir }))
end

local resize = {
  H = { x = -10, y = 0 },
  J = { x = 0, y = 10 },
  K = { x = 0, y = -10 },
  L = { x = 10, y = 0 },
}
for letter, delta in pairs(resize) do
  hl.bind(
    V.mainMod .. " + SHIFT + CTRL + " .. letter,
    hl.dsp.window.resize({
      x = delta.x,
      y = delta.y,
      relative = true,
    }),
    { repeating = true }
  )
end

hl.bind(V.mainMod .. " + Z", hl.dsp.window.drag())
hl.bind(V.mainMod .. " + X", hl.dsp.window.resize())
hl.bind(V.mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(V.mainMod .. " + mouse:273", hl.dsp.window.resize())
