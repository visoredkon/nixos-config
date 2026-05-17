return {
  "saghen/blink.cmp",
  version = "1.*",

  dependencies = {
    "rafamadriz/friendly-snippets",
  },

  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<A-1>"] = {
        function(cmp)
          cmp.accept({ index = 1 })
        end,
      },
      ["<A-2>"] = {
        function(cmp)
          cmp.accept({ index = 2 })
        end,
      },
      ["<A-3>"] = {
        function(cmp)
          cmp.accept({ index = 3 })
        end,
      },
      ["<A-4>"] = {
        function(cmp)
          cmp.accept({ index = 4 })
        end,
      },
      ["<A-5>"] = {
        function(cmp)
          cmp.accept({ index = 5 })
        end,
      },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      keyword = { range = "full" },
      trigger = {
        show_on_backspace = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert = false,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      accept = {
        auto_brackets = {
          enabled = true,
          kind_resolution = { enabled = true },
          semantic_token_resolution = { enabled = true },
        },
      },
      menu = {
        auto_show = true,
        auto_show_delay_ms = 0,
        max_height = 12,
        min_width = 20,
        border = "rounded",
        scrollbar = true,
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          max_width = 80,
          max_height = 20,
          scrollbar = true,
        },
      },
      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = true,
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      frecency = { enabled = true },
      use_proximity = true,
      sorts = { "score", "sort_text", "label" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          fallbacks = { "buffer" },
        },
        path = {
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(_)
              return vim.fn.expand("%:p:h")
            end,
            show_hidden_files_by_default = false,
          },
        },
        snippets = {
          opts = {
            friendly_snippets = true,
            use_label_description = true,
          },
        },
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win)
                  return vim.api.nvim_win_get_buf(win)
                end)
                :filter(function(buf)
                  return vim.bo[buf].buftype ~= "nofile"
                end)
                :totable()
            end,
          },
        },
      },
    },

    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = { "buffer", "cmdline" },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
  },
  opts_extend = { "sources.default" },
}
