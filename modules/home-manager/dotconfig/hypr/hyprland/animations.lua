hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1.0 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1.0 }, { 0.32, 1.0 } } })
hl.curve("easy", { type = "spring", mass = 1.0, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0.0 }, { 0.1, 1.0 } } })

local wsSpeed = 1.94
local wsInSpeed = 1.21

hl.animation({ leaf = "global", enabled = true, speed = 10.0, bezier = "default" })

hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100.0, bezier = "linear", style = "loop" })

hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })

hl.animation({ leaf = "monitorAdded", enabled = true, speed = 7.0, bezier = "quick" })

hl.animation({ leaf = "windows", enabled = true, speed = wsSpeed, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = wsInSpeed, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = wsSpeed, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, spring = "easy" })

hl.animation({ leaf = "workspaces", enabled = true, speed = wsSpeed, bezier = "easeOutQuint", style = "slidefade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = wsInSpeed, bezier = "easeOutQuint", style = "slidefade" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7.0, bezier = "quick" })
