return {
  settings = {
    yaml = {
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
        proseWrap = "preserve",
        printWidth = 120,
      },
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        ["https://json.schemastore.org/github-workflow"] = { ".github/workflows/*" },
        ["https://json.schemastore.org/github-action"] = { ".github/actions/*/action.yml" },
        ["https://json.schemastore.org/dependabot-2.0"] = { ".github/dependabot.yml" },
        ["https://json.schemastore.org/prettierrc"] = { ".prettierrc", ".prettierrc.yaml" },
        ["https://json.schemastore.org/docker-compose"] = { "docker-compose*.yml", "compose*.yml" },
      },
      validate = true,
      completion = true,
      hover = true,
      customTags = {
        "!reference sequence",
        "!env",
        "!vault",
        "!encrypted",
      },
      keyOrdering = false,
    },
  },
}
