return {
  settings = {
    gopls = {
      staticcheck = true,
      gofumpt = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      ui = {
        semanticTokens = true,
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        completion = {
          usePlaceholders = true,
          matcher = "Fuzzy",
          completeFunctionCalls = true,
          experimentalPostfixCompletions = true,
        },
        navigation = {
          importShortcut = "Both",
          symbolMatcher = "FastFuzzy",
          symbolStyle = "Dynamic",
        },
        documentation = {
          hoverKind = "FullDocumentation",
          linksInHover = true,
        },
      },
      vulncheck = "Imports",
      diagnosticsTrigger = "Edit",
      analysesProgressReporting = true,
    },
  },
}
