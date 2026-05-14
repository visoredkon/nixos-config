local function register(list)
  for _, b in ipairs(list) do
    hl.bind(b[1], b[2])
  end
end

return { register = register }
