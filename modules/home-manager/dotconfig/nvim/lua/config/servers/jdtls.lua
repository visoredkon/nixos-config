local java_home = os.getenv("JAVA_HOME") or vim.fn.system("readlink -f $(command -v java)"):match("(.+)/bin/java")

return {
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-21", path = java_home, default = true },
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
