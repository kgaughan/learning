#!/usr/bin/env lua

function read_only(t)
  local proxy = {}
  local mt = {
    __index = t,
    __newindex = function(t, k, v)
      -- the '2' here refers to the calling stack frame, to signal the correct
      -- line in the stack trace where the issue arose
      error("attempt to update a read-only table", 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end 

days = read_only {
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
}

print(days[1])
days[2] = "Lundi"
