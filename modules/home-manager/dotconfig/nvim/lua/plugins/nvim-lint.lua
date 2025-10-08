return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      dockerfile = { "hadolint" },
      fish = { "fish" },
      -- nix = { "nixpkgs-lint" },
    },
  },
}
