function list_iter(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then
      return t[i]
    end
  end
end

t = {10, 20, 30}

-- Literal implementation
iter = list_iter(t) -- create the iterator
while true do
  local element = iter() -- call the iterator
  if element == nil then
    break
  end
  print(element)
end

-- Implementation with generic-for
for element in list_iter(t) do
  print(element)
end
