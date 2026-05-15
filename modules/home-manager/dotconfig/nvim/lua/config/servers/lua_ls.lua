return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua" },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
        ignoreDir = { ".vscode" },
        useGitIgnore = true,
        maxPreload = 5000,
        preloadFileSize = 500,
      },
      completion = {
        callSnippet = "Replace",
        autoRequire = true,
        displayContext = 5,
        showParams = true,
        showWord = "Fallback",
      },
      diagnostics = {
        globals = { "vim" },
        enable = true,
        disable = { "codestyle-check" },
      },
      hint = {
        enable = true,
        setType = false,
        paramName = "All",
        paramType = true,
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      codeLens = {
        enable = true,
      },
      doc = {
        privateName = { "^_" },
      },
      format = {
        enable = false,
      },
      hover = {
        enable = true,
        previewFields = 50,
        viewNumber = true,
        viewString = true,
        viewStringMax = 1000,
      },
      signatureHelp = {
        enable = true,
      },
      semantic = {
        enable = true,
        annotation = true,
        variable = true,
      },
      type = {
        weakNilCheck = false,
        weakUnionCheck = false,
        castNumberToInteger = false,
        inferParamType = true,
        inferTableSize = 10,
        checkTableShape = false,
      },
    },
  },
}
