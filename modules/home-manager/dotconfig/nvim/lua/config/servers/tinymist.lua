return {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "enable",
    lint = {
      enabled = true,
    },
  },
  handlers = {
    ["tinymist/devEvent"] = function(_, result, ctx)
      vim.g.tinymist_subscribers = vim.g.tinymist_subscribers or {}
      for i = #vim.g.tinymist_subscribers, 1, -1 do
        local callback = vim.g.tinymist_subscribers[i]
        if callback(result) then
          table.remove(vim.g.tinymist_subscribers, i)
        end
      end
    end,
  },
  init_options = {
    hasWidgets = true,
  },
}
