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

vim.keymap.set("n", "<leader>pp", function()
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

local function export_keymaps()
  local modes = { "n", "v", "i" }
  local lines = {}

  for _, mode in ipairs(modes) do
    table.insert(lines, "MODE: " .. mode:upper())
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      if map.desc or map.lhs:find("<Leader>") then
        local lhs = map.lhs:gsub(" ", "<Space>")
        local desc = map.desc or "No Description"
        table.insert(lines, string.format("[%s] %-15s | %s", mode:upper(), lhs, desc))
      end
    end
    table.insert(lines, "")
  end

  vim.api.nvim_command("enew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end

vim.api.nvim_create_user_command("ExportKeymaps", export_keymaps, {})
