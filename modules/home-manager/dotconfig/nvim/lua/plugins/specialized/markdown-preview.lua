return {
  "selimacerbas/markdown-preview.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown: Start preview" },
    { "<leader>mP", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown: Stop preview" },
  },
  opts = {
    instance_mode = "takeover",
    port = 0,
    open_browser = true,
    debounce_ms = 300,
    mermaid_renderer = "js",
    scroll_sync = true,
  },
}
