return {
  "brenoprata10/nvim-highlight-colors",
  opts = {
    render = "background",

    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_hsl_without_function = true,
    enable_var_usage = true,
    enable_named_colors = true,
    enable_tailwind = true,

    enable_ansi = true,
    enable_xterm256 = true,
    enable_xtermTrueColor = true,

    virtual_symbol = "■",
    virtual_symbol_prefix = "",
    virtual_symbol_suffix = " ",
    virtual_symbol_position = "inline",

    custom_colors = nil,

    exclude_filetypes = {},
    exclude_buftypes = {},
    exclude_buffer = function(_) end,
  },
}
