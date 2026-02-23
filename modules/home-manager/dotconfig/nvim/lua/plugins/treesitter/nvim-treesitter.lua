return {
  "nvim-treesitter/nvim-treesitter",
  init = function()
    require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
      local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
      local filename = vim.fn.fnamemodify(filepath, ":t")
      return string.match(filename, ".*mise.*%.toml$") ~= nil
    end, { force = true, all = false })
  end,
  opts = {
    ensure_installed = {
      "bash",
      "go",
      "hcl",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "query",
      "regex",
      "toml",
      "typst",
      "vim",
      "vimdoc",
      "yaml",
    },
  },
}
