return {
  settings = {
    json = {
      format = {
        enable = false,
      },
      schemaStore = {
        enable = true,
      },
      schemas = {
        ["https://json.schemastore.org/package"] = { "package.json" },
        ["https://json.schemastore.org/tsconfig"] = { "tsconfig.json", "tsconfig.*.json" },
        ["https://json.schemastore.org/prettierrc"] = { ".prettierrc", ".prettierrc.json" },
        ["https://json.schemastore.org/eslintrc"] = { ".eslintrc.json" },
        ["https://json.schemastore.org/github-workflow"] = { ".github/workflows/*" },
        ["https://json.schemastore.org/github-action"] = { ".github/actions/*/action.yml" },
        ["https://json.schemastore.org/dependabot-2.0"] = { ".github/dependabot.yml" },
        ["https://json.schemastore.org/nicegui"] = { "**/*.schema.json" },
      },
      validate = {
        enable = true,
      },
      completions = true,
      hover = true,
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
