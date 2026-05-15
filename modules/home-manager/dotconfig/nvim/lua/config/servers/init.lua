local M = {}

local files = vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/config/servers")
table.sort(files)
for _, file in ipairs(files) do
  local name = file:match("^(.-)%.lua$")
  if name and name ~= "init" then
    local ok, mod = pcall(require, "config.servers." .. name)
    if ok then
      M[name] = mod
    end
  end
end

return M
