function all_words()
  local line = io.read() -- current line
  local pos = 1          -- current position in the line
  return function()
    while line do        -- repeat while there are lines
      local s, e = string.find(line, "%w+", pos)
      if s then          -- found a word?
        pos = e + 1      -- next position is after this word
        return string.sub(line, s, e)
      else
        line = io.read() -- word not found; try next line
        pos = 1          -- restart from first position
      end
    end
    return nil           -- no more lines: end traversal
  end
end

words = {}
for word in all_words() do
  word = string.lower(word)
  if not words[word] then
    words[word] = 1
  else
    words[word] = words[word] + 1
  end
end

print("Words by count:")
for word, count in pairs(words) do
  print(string.format("%s: %d", word, count))
end
