local V = require("hyprland.variables")

hl.on("hyprland.start", function()
  hl.exec_cmd(V.browser, { workspace = "2" })
end)
