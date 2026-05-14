hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })

for _, a in ipairs({
  { leaf = "fade", enabled = true, speed = 10, bezier = "default" },
  { leaf = "border", enabled = true, speed = 1, bezier = "liner" },
  { leaf = "borderangle", enabled = true, speed = 100, bezier = "liner", style = "loop" },
  { leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" },
  { leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" },
  { leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" },
  { leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" },
  { leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" },
}) do
  hl.animation(a)
end
