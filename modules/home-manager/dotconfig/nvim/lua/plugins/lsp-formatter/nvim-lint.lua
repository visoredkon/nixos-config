return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      fish = { "fish" },
      lua = { "selene" },
      nix = { "deadnix", "statix" },
      python = { "ruff" },
      sh = { "shellcheck" },
      terraform = { "tflint" },
      yaml = { "yamllint" },
      ["yaml.jinja"] = {},
    }

    local yamllint = lint.linters.yamllint
    vim.list_extend(yamllint.args, {
      "-d",
      "{extends: default, rules: {document-start: disable, line-length: disable}}",
    })

    local selene = lint.linters.selene
    selene.cwd = function()
      local found = vim.fs.find({ "selene.toml" }, {
        upward = true,
        path = vim.api.nvim_buf_get_name(0),
      })[1]
      return found and vim.fs.dirname(found) or nil
    end

    vim.api.nvim_create_user_command("LintToggle", function()
      vim.g.lint_disabled = not vim.g.lint_disabled
      if vim.g.lint_disabled then
        vim.diagnostic.reset(lint.ns)
      else
        lint.try_lint()
      end
      vim.notify("Lint " .. (vim.g.lint_disabled and "disabled" or "enabled"))
    end, {})

    local function try_lint()
      if vim.g.lint_disabled then
        return
      end
      lint.try_lint()
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = try_lint,
    })

    vim.schedule(try_lint)
  end,
}
