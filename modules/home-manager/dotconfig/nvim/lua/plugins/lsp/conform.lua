return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        -- json = { "jq" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        php = { "pint" },
        python = { "ruff" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
}
