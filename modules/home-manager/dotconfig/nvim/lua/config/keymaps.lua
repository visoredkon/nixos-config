-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
vim.keymap.set("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", { noremap = true })
vim.keymap.set("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { noremap = true })
vim.keymap.set("n", "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { noremap = true })
vim.keymap.set("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
vim.keymap.set("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap = true })

vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", {
  noremap = true,
  desc = "Find keymaps",
})

vim.keymap.set("n", "d", '"_d', {
  noremap = true,
  silent = true,
})

vim.keymap.set("v", "d", '"_d', {
  noremap = true,
  silent = true,
})

vim.keymap.set("i", "<C-k>", "<Up>", {
  noremap = true,
  silent = true,
})

vim.keymap.set("i", "<C-l>", "<Right>", {
  noremap = true,
  silent = true,
})

vim.keymap.set("i", "<C-j>", "<Down>", {
  noremap = true,
  silent = true,
})

vim.keymap.set("i", "<C-h>", "<Left>", {
  noremap = true,
  silent = true,
})

vim.keymap.set("n", "<C-S-p>", function()
  local input_opts = {
    prompt = "Save image as (path/filename): ",
    default = vim.fn.expand("%:p:h") .. "/",
  }

  vim.ui.input(input_opts, function(filepath)
    if not filepath or filepath == "" then
      vim.notify("Paste cancelled.", vim.log.levels.INFO)
      return
    end

    local expanded_path = vim.fn.expand(filepath)
    local command = string.format("wl-paste > %s", vim.fn.shellescape(expanded_path))

    vim.fn.jobstart(command, {
      detach = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Paste successful! Saved to: " .. expanded_path, vim.log.levels.INFO)
        else
          vim.notify("Paste failed! Exit code: " .. tostring(code), vim.log.levels.ERROR)
        end
      end,
    })
  end)
end, {
  noremap = true,
  desc = "Paste clipboard to a prompted file path",
})
