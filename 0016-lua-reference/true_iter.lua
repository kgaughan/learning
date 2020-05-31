#!/usr/bin/env lua

function allwords(f)
  -- repeat for each line in the file
  for l in io.lines() do
    -- repeat for each word in the line
    for w in string.gmatch(l, "%w+") do
      -- call the function
      f(w)
    end
  end
end

-- This style of using an iterator function with a callback apparently has
-- about the same cost as an iterator function with a generic for-loop, but
-- lacks flexibility, as it can't be used with 'break' and 'return'.
words = {}
allwords(function(word)
  word = string.lower(word)
  if not words[word] then
    words[word] = 1
  else
    words[word] = words[word] + 1
  end
end)

print("Words by count:")
for word, count in pairs(words) do
  print(string.format("%s: %d", word, count))
end
