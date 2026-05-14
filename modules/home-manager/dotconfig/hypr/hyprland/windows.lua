hl.window_rule({
  name = "fix-xwayland-dragging",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "float-btop",
  match = { class = "(btop)" },
  float = true,
  size = "952 522",
  center = true,
})

hl.window_rule({
  name = "float-yazi",
  match = { class = "(yazi)" },
  float = true,
  size = "952 522",
  center = true,
})

hl.window_rule({
  name = "ignore-maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "no-screen-share-code",
  match = { initial_class = "^(code)$" },
  no_screen_share = true,
})

for _, pattern in ipairs({
  "Google Gemini",
  "Private Browsing",
  "WhatsApp",
  "Z.ai",
}) do
  hl.window_rule({
    match = {
      initial_class = "^(zen-beta)$",
      title = ".*" .. pattern .. ".*",
    },
    no_screen_share = true,
  })
end

hl.window_rule({
  name = "picture-in-picture-zen",
  match = {
    initial_class = "^(zen-beta)$",
    initial_title = "^(Picture-in-Picture)$",
  },
  float = true,
  size = "384 216",
  pin = true,
  move = "((monitor_w*1)-404) (45)",
})
