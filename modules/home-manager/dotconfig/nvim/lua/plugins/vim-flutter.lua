return {
  "thosakwe/vim-flutter",
  -- lazy = false,
  -- dependencies = {
  --   "nvim-lua/plenary.nvim",
  --   "stevearc/dressing.nvim",
  -- },
  -- config = true,
  keys = {
    { "<leader>ae", "<cmd>FlutterEmulators<cr>", desc = "Flutter emulators" },

    { "<leader>apr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
    { "<leader>apl", "<cmd>FlutterRun -d linux<cr>", desc = "Flutter run Linux" },
    { "<leader>apq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },

    { "<leader>ar", "<cmd>FlutterHotReload<cr>", desc = "Flutter reload" },
    { "<leader>aR", "<cmd>FlutterHotRestart<cr>", desc = "Flutter restart" },

    { "<leader>apd", "<cmd>FlutterVisualDebug<cr>", desc = "Flutter visual debug" },

    -- { "<leader>ae", "<cmd>FlutterEmulators<cr>", desc = "Flutter emulators" },
    --
    -- { "<leader>apr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
    -- { "<leader>apd", "<cmd>FlutterDebug<cr>", desc = "Flutter run debug" },
    -- { "<leader>apq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
    --
    -- { "<leader>ads", "<cmd>FlutterDevTools<cr>", desc = "Flutter DevTools" },
    -- { "<leader>ada", "<cmd>FlutterDevToolsActivate<cr>", desc = "Flutter DevTools activate" },
    --
    -- { "<leader>ar", "<cmd>FlutterRestart<cr>", desc = "Flutter reload" },
    -- { "<leader>aR", "<cmd>FlutterHotRestart<cr>", desc = "Flutter restart" },
    --
    -- { "<leader>alr", "<cmd>FlutterLspRestart<cr>", desc = "Flutter LSP restart" },
    -- { "<leader>als", "<cmd>FlutterSuper<cr>", desc = "Flutter goto super class" },
    -- { "<leader>ala", "<cmd>FlutterReanalyze<cr>", desc = "Flutter LSP reanalyze" },
  },
}
