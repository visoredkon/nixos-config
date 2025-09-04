return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = true,
  keys = {
    { "<leader>ae", "<cmd>FlutterEmulators<cr>", desc = "Flutter emulators" },

    { "<leader>apr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
    { "<leader>apd", "<cmd>FlutterDebug<cr>", desc = "Flutter run debug" },
    { "<leader>apq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },

    { "<leader>ads", "<cmd>FlutterDevTools<cr>", desc = "Flutter DevTools" },
    { "<leader>ada", "<cmd>FlutterDevToolsActivate<cr>", desc = "Flutter DevTools activate" },

    { "<leader>ar", "<cmd>FlutterRestart<cr>", desc = "Flutter reload" },
    { "<leader>aR", "<cmd>FlutterHotRestart<cr>", desc = "Flutter restart" },

    { "<leader>alr", "<cmd>FlutterLspRestart<cr>", desc = "Flutter LSP restart" },
    { "<leader>als", "<cmd>FlutterSuper<cr>", desc = "Flutter goto super class" },
    { "<leader>ala", "<cmd>FlutterReanalyze<cr>", desc = "Flutter LSP reanalyze" },
  },

  -- "thosakwe/vim-flutter",
  -- dependencies = { "dart-lang/dart-vim-plugin" },
  -- keys = {
  --   { "<leader>ae", "<cmd>!flutter emulators --launch flutter-emulator<cr>", desc = "Flutter emulator run" },
  --   { "<leader>ar", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
  --   { "<leader>aq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
  --   { "<leader>ahr", "<cmd>FlutterHotReload<cr>", desc = "Flutter reload" },
  --   { "<leader>ahR", "<cmd>FlutterHotRestart<cr>", desc = "Flutter restart" },
  --   { "<leader>av", "<cmd>FlutterVisualDebug<cr>", desc = "Flutter visual debug" },
  -- },
}
