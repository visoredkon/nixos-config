local key = vim.api.nvim_replace_termcodes
local esc = key("<Esc>", true, false, true)

vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa: '," .. esc .. "pA);" .. esc)
