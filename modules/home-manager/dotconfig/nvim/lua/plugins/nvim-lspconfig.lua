return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {},

        gopls = {
          settings = {
            gopls = {
              ui = {
                codelenses = {
                  generate = true,
                  gc_details = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
                semanticTokens = true,
              },

              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },

              staticcheck = true,

              gofumpt = true,

              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        intelephense = {},

        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },

        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/home/pahril/.config/nixos-config").nixosConfigurations."nixu".config',
                },
              },
            },
          },
        },

        hyprls = {},

        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onType",
            semanticTokens = "enable",
            lint = {
              enabled = true,
            },
          },
        },
      },

      ---@type vim.diagnostic.Opts
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
        enabled = false,
      },

      codelens = {
        enabled = false,
      },

      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    },
  },
}
