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
          return { "dprint" }
        end,
        fish = { "fish_indent" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        php = { "pint" },
        python = { "ruff" },
        sh = { "shfmt" },
        toml = { "taplo" },
        yaml = { "yamlfmt" },
        zsh = { "shfmt" },
      },
    },
  },
}
