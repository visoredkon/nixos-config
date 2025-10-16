return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        -- json = { "jq" },
        lua = { "stylua" },
        php = { "pint" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
        -- nix = { "nixfmt" },
      },
    },
  },
}
