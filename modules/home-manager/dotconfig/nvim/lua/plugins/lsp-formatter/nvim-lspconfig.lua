return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            "LazyVim",
            "snacks",
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
          integrations = { lspconfig = true },
        },
      },
    },
    opts = {
      tinymist_subscribeDevEvent = function(callback)
        if type(callback) ~= "function" then
          error("callback must be a function")
        end
        vim.g.tinymist_subscribers = vim.g.tinymist_subscribers or {}
        table.insert(vim.g.tinymist_subscribers, callback)
      end,

      setup = {
        ["*"] = function(_, config)
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        end,
      },

      servers = vim.tbl_extend("keep", {
        ["*"] = {
          capabilities = {
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },
        },
      }, require("config.servers")),

      codelens = {
        enabled = true,
      },

      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },

      inlay_hints = {
        enabled = true,
      },
    },
  },
}
