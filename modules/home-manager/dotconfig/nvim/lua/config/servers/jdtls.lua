return {
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk", default = true },
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      gradle = {
        enabled = true,
        downloadSources = true,
      },
      completion = {
        favoriteMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.assertj.core.api.Assertions.*",
        },
        filteredTypes = {
          "com.sun.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      imports = {
        group = {
          "java",
          "javax",
          "com",
          "org",
        },
        matchQuality = 100,
      },
      saveActions = {
        organizeImports = true,
        cleanUps = true,
      },
      format = {
        enabled = true,
      },
      signatureHelp = {
        enabled = true,
        descriptionEnabled = true,
      },
      contentProvider = {
        preferred = "fernflower",
      },
      references = {
        includeDecompiledSources = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
}
