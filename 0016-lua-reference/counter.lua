#!/usr/bin/env lua

function new_counter()
  local i = 0
  return function()
    i = i + 1
    return i
  end
end

c1 = new_counter()
print(c1())
print(c1())
