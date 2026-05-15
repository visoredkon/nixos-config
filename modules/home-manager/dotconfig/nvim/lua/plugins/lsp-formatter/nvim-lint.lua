return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      fish = { "fish" },
      lua = { "selene" },
      markdown = { "markdownlint-cli2" },
      nix = { "deadnix", "statix" },
      python = { "ruff" },
      sh = { "shellcheck" },
      terraform = { "tflint" },
      yaml = { "yamllint" },
    }

    local yamllint = lint.linters.yamllint
    vim.list_extend(yamllint.args, { "-d", "{extends: default, rules: {document-start: disable}}" })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        local selene = lint.linters.selene
        local found = vim.fs.find({ "selene.toml" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
        selene.cwd = found and vim.fs.dirname(found) or nil

        lint.try_lint()
      end,
    })
  end,
}
