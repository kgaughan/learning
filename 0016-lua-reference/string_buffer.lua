#!/usr/bin/env lua

StringBuffer = {}

function StringBuffer:new()
  o = {""}

  -- Boilerplate
  setmetatable(o, self)
  self.__index = self
  return o
end

function StringBuffer:add(s)
  table.insert(self, s) -- push 's' into the buffer
  for i = #self - 1, 1, -1 do
    if string.len(self[i]) > string.len(self[i + 1]) then
      break
    end
    self[i] = self[i] .. table.remove(self)
  end
end

function StringBuffer:to_string()
  return table.concat(self)
end

s = StringBuffer:new()
for line in io.lines() do
  s:add(line .. "\n")
end
catenated = s:to_string()

print("Complete string: [" .. catenated .. "]")
