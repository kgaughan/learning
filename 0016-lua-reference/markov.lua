#!/usr/bin/env lua

function prefix(w1, w2)
  return w1 .. " " .. w2
end

local statetab = {}

function insert(index, value)
  if not statetab[index] then
    statetab[index] = {value}
  else
    table.insert(statetab[index], value)
  end
end

function all_words()
  local line = io.read()
  local pos = 1
  return function()
    while line do
      local s, e = string.find(line, "%w+", pos)
      if s then
        pos = e + 1
        return string.sub(line, s, e)
      else
        line = io.read()
        pos = 1
      end
    end
    return nil
  end
end

local NOWORD = "\n"
local MAXGEN = 10000
local N = 2

-- build table
local w1, w2 = NOWORD, NOWORD
for w in all_words() do
  w = string.lower(w)
  insert(prefix(w1, w2), w)
  w1, w2 = w2, w
end
insert(prefix(w1, w2), NOWORD)

-- generate text
w1, w2 = NOWORD, NOWORD
for i = 1, MAXGEN do
  local list = statetab[prefix(w1, w2)]
  -- chose a random item from the list
  local r = math.random(#list)
  local next_word = list[r]
  if next_word == NOWORD then
    break
  end
  io.write(next_word, " ")
  w1, w2 = w2, next_word
end
