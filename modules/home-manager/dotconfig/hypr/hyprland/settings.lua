local c = require("hyprland.colors")

hl.config({
  general = {
    border_size = 1,
    gaps_in = 3,
    gaps_out = 6,
    col = {
      active_border = c.gradient,
      inactive_border = c.surface2,
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  group = {
    col = {
      border_active = c.gradient,
      border_inactive = c.gradient,
      border_locked_active = c.gradient,
      border_locked_inactive = c.gradient,
    },
  },
  cursor = {
    no_hardware_cursors = 1,
  },
  decoration = {
    rounding = 2,
    rounding_power = 2,
    active_opacity = 0.9,
    inactive_opacity = 0.8,
    dim_special = 0.3,
    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      xray = false,
      ignore_opacity = true,
      vibrancy = 0.1696,
      special = true,
    },
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = c.crust,
    },
  },
  master = {
    new_status = "master",
  },
  dwindle = {
    preserve_split = true,
  },
  input = {
    kb_layout = "us",
    kb_variant = ",qwerty",
    kb_model = "pc104",
    kb_options = "caps:swapescape",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  xwayland = {
    force_zero_scaling = true,
  },
  misc = {
    disable_autoreload = true,
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    col = {
      splash = c.base,
    },
    background_color = c.base,
  },
})
