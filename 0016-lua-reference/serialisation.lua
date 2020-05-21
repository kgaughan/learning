function serialise(o, indent)
  indent = indent or ""
  if type(o) == "number" then
    io.write(o)
  elseif type(o) == "string" then
    io.write(string.format("%q", o))
  elseif type(o) == "table" then
    io.write("{\n")
    for k, v in pairs(o) do
      io.write(indent, "  ")
      serialise(k)
      io.write(" = ")
      serialise(v, indent .. "  ")
      io.write(",\n")
    end
    io.write(indent, "}")
    if indent == "" then
      io.write("\n")
    end
  else
    error("cannot serialise a " .. type(o))
  end
end

serialise {
  a = 12,
  b = 'Lua',
  key = 'another"one"',
  characters = {
    Rick = 'nihilist',
    Morty = 'idiot',
  }
}
