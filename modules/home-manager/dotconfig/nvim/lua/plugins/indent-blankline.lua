return {
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
  opts = function()
    local highlight_groups_config = {
      { name = "IblIndentColor1", color = "#EED49F" },
      { name = "IblIndentColor2", color = "#A6DA95" },
      { name = "IblIndentColor3", color = "#C6A0F6" },
      { name = "IblIndentColor4", color = "#7dc4e4" },
      { name = "IblIndentColor5", color = "#8AADF4" },
      { name = "IblIndentColor6", color = "#ED8796" },
    }

    for _, group in ipairs(highlight_groups_config) do
      vim.api.nvim_set_hl(0, group.name, { fg = group.color })
    end

    local indent_highlight_names = {}
    for _, group in ipairs(highlight_groups_config) do
      table.insert(indent_highlight_names, group.name)
    end

    Snacks.toggle({
      name = "Indention Guides",
      get = function()
        return require("ibl.config").get_config(0).enabled
      end,
      set = function(state)
        require("ibl").setup_buffer(0, { enabled = state })
      end,
    }):map("<leader>ug")

    return {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = indent_highlight_names,
      },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "snacks_dashboard",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "toggleterm",
          "trouble",
        },
      },
    }
  end,
  main = "ibl",
}
