#!/usr/bin/env lua

producer = coroutine.create(function()
  while true do
    local x = io.read() -- produce new value
    coroutine.yield(x)
  end
end)

function filter(prod)
  return coroutine.create(function()
    local line = 1
    while true do
      local status, value = coroutine.resume(prod) -- get new value
      x = string.format("%5d %s", line, value)
      coroutine.yield(x)                           -- end it to consumer
      line = line + 1
    end
  end)
end

f = filter(producer)
while true do
  local _, x = coroutine.resume(f) -- get new value
  io.write(x, "\n")                -- consume it
end
