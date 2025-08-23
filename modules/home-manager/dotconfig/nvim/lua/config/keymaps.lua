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
