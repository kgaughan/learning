#!/usr/bin/env lua

co = coroutine.create(function()
  for i = 1, 10 do
    print("co", i)
    coroutine.yield()
  end
end)

while true do
  coroutine.resume(co)
  if coroutine.status(co) == "dead" then
    break
  end
  print("loop!")
end
print()

co = coroutine.create(function(a, b, c)
  coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10))
print()

co = coroutine.create(function(...)
  print("args", ...)
  print("co", coroutine.yield())
end)
coroutine.resume(co, 5, 1)
coroutine.resume(co, 7, 9)
print()
