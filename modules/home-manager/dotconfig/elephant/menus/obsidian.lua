Name = "obsidian"
NamePretty = "Obsidian"
Icon = "accessories-text-editor"
Placeholder = "Search Notes..."
Match = "Fuzzy"
Cache = true

Action = "xdg-open '%VALUE%'"

local function url_encode(str)
  if not str then
    return ""
  end
  str = str:gsub("\n", "\r\n")
  str = str:gsub("([^%w %-_.~])", function(char)
    return string.format("%%%02X", string.byte(char))
  end)
  return str:gsub(" ", "%%20")
end

function GetEntries()
  local config_path = os.getenv("HOME") .. "/.config/obsidian/obsidian.json"
  local config_file = io.open(config_path, "r")
  if not config_file then
    return {}
  end
  config_file:close()

  local vault_handle = io.popen("jq -r '.vaults | to_entries | .[0].value.path' " .. config_path)
  local vault_path = vault_handle:read("*a"):match("^%s*(.-)%s*$")
  vault_handle:close()

  if vault_path == "" then
    return {}
  end

  local vault_name = vault_path:match("([^/]+)$")
  local fd_handle =
    io.popen("fd --extension md --type file --strip-cwd-prefix --base-directory='" .. vault_path .. "' | sort")
  if not fd_handle then
    return {}
  end

  local entries = {}
  for relative_path in fd_handle:lines() do
    table.insert(entries, {
      Text = relative_path:gsub("%.md$", ""),
      Subtext = vault_name .. " / " .. relative_path,
      Value = "obsidian://open?vault=" .. url_encode(vault_name) .. "&file=" .. url_encode(relative_path),
    })
  end

  fd_handle:close()
  return entries
end
