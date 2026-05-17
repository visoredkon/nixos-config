Name = "nerdfont"
NamePretty = "Nerd Font Icons"
Icon = "preferences-desktop-font"
Cache = true

local cache_dir = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
local cache_file = cache_dir .. "/nerdfont-icons.txt"

local function fetch_glyphs()
  os.execute("mkdir -p " .. cache_dir)
  os.execute(
    "curl -sL 'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json'"
      .. [[ | jq -r 'del(.METADATA) | to_entries[] | "\(.value.char)\t\(.key)"' | sort > ]]
      .. cache_file
  )
end

function GetEntries()
  local file = io.open(cache_file, "r")
  if not file then
    fetch_glyphs()
    file = io.open(cache_file, "r")
    if not file then
      return {}
    end
  end

  local entries = {}
  for line in file:lines() do
    local glyph, name = line:match("^(.-)\t(.+)$")
    if glyph and name then
      table.insert(entries, {
        Text = glyph .. "  " .. name,
        Subtext = name,
        Actions = { activate = "printf '%s' '" .. glyph .. "' | wl-copy" },
      })
    end
  end

  file:close()
  return entries
end
