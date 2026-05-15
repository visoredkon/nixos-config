return {
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
        associations = { "*.php", "*.phtml" },
        exclude = {
          "**/.git/**",
          "**/.svn/**",
          "**/.hg/**",
          "**/CVS/**",
          "**/.DS_Store/**",
          "**/node_modules/**",
          "**/bower_components/**",
          "**/vendor/**/{Tests,tests}/**",
          "**/.history/**",
          "**/vendor/**/vendor/**",
        },
      },
      environment = {
        phpVersion = "8.2.0",
      },
      completion = {
        insertUseDeclaration = true,
        fullyQualifyGlobalConstantsAndFunctions = false,
        triggerParameterHints = true,
        maxItems = 100,
      },
      format = {
        enable = true,
        braces = "psr12",
      },
      diagnostics = {
        enable = true,
        run = "onType",
        embeddedLanguages = true,
        undefinedVariables = true,
        undefinedTypes = true,
        undefinedFunctions = true,
        undefinedConstants = true,
        undefinedMethods = true,
        undefinedProperties = true,
        unusedSymbols = true,
        typeErrors = true,
        deprecated = true,
        implementationErrors = true,
        argumentCount = true,
        languageConstraints = true,
        duplicateSymbols = true,
      },
      telemetry = {
        enabled = false,
      },
    },
  },
}
