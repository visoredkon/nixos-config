return {
  "dstein64/nvim-scrollview",
  lazy = false,
  init = function()
    local group = vim.api.nvim_create_augroup("scrollview_legend_startup", { clear = true })

    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      once = true,
      callback = function()
        vim.schedule(function()
          pcall(vim.cmd, "silent! ScrollViewLegend!")
        end)
      end,
    })
  end,
  keys = {
    { "<leader>sl", "<cmd>ScrollViewLegend!<cr>", desc = "ScrollView Legend", silent = true },
    { "<leader>st", "<cmd>ScrollViewToggle<cr>", desc = "ScrollView Toggle", silent = true },
    { "[v", "<cmd>ScrollViewPrev<cr>", desc = "ScrollView Prev Sign", silent = true },
    { "]v", "<cmd>ScrollViewNext<cr>", desc = "ScrollView Next Sign", silent = true },
    { "g[v", "<cmd>ScrollViewFirst<cr>", desc = "ScrollView First Sign", silent = true },
    { "g]v", "<cmd>ScrollViewLast<cr>", desc = "ScrollView Last Sign", silent = true },
  },
  opts = {
    base = "right",
    byte_limit = 1000000,
    column = 1,
    current_only = false,
    excluded_filetypes = {
      "DressingInput",
      "TelescopePrompt",
      "blink_cmp_doc",
      "blink_cmp_menu",
      "dropbar_menu",
      "dropbar_menu_fzf",
      "lazy",
      "mason",
      "neo-tree",
      "noice",
      "notify",
      "prompt",
      "snacks_dashboard",
      "snacks_input",
      "snacks_notif",
      "snacks_picker_input",
      "snacks_terminal",
      "snacks_win",
      "trouble",
    },
    line_limit = 20000,
    mode = "auto",
    mouse_primary = "left",
    mouse_secondary = "right",
    signs_max_per_row = -1,
    signs_on_startup = { "all" },
    signs_overflow = "left",
    signs_scrollbar_overlap = "off",
    winblend = 50,
  },
}
