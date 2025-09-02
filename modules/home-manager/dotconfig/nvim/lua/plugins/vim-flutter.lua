return {
  "thosakwe/vim-flutter",
  dependencies = { "dart-lang/dart-vim-plugin" },
  keys = {
    { "<leader>ae", "<cmd>!flutter emulators --launch flutter-emulator<cr>", desc = "Flutter emulator run" },
    { "<leader>ar", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
    { "<leader>aq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
    { "<leader>ahr", "<cmd>FlutterHotReload<cr>", desc = "Flutter hot reload" },
    { "<leader>ahR", "<cmd>FlutterHotRestart<cr>", desc = "Flutter hot restart" },
    { "<leader>av", "<cmd>FlutterVisualDebug<cr>", desc = "Flutter visual debug" },
  },
}
