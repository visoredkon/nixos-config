return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  opts = {
    enabled = false,
    max_count = 3,
    max_time = 1000,

    allow_different_key = false,
    disable_mouse = false,
    max_insert_idle_ms = 5000,
    restriction_mode = "block",

    hint = true,
    notification = true,
  },
}
