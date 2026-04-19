return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = function(bufnr)
          local formatter_name = "biome"
          if require("conform").get_formatter_info(formatter_name, bufnr).available then
            return { formatter_name }
          end
          return { "jq" }
        end,
        lua = { "stylua" },
        markdown = function(bufnr)
          local fname = vim.api.nvim_buf_get_name(bufnr)

          if fname:match("slides%.md") or fname:match("pages/.*%.md") then
            return { "prettier" }
          end

          return {}
        end,
        nix = { "nixfmt" },
        php = { "pint" },
        python = { "ruff" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
}
