#!/usr/bin/env lua

function all_words_iterator(state)
  -- repeat while there are lines
  while state.line do
    -- search for the next word
    local s, e = string.find(state.line, "%w+", state.pos)
    if s then -- found a word?
      -- update next position (after this word)
      state.pos = e + 1
      return string.sub(state.line, s, e)
    else -- word not found
      -- try next line...
      state.line = io.read()
      --- ...from the first position
      state.pos = 1
    end
  end
  -- no more lines: end loop
  return nil
end

-- Note: this kind of thing is apparently considered a last resort, as while
-- regular stateless iterators are cheap, creating a table is apparently more
-- expensive than creating a closure, and accessing closed over state is also
-- cheaper than table accesses. So, yeah.
function all_words()
  local state = {
    line = io.read(),
    pos = 1,
  }
  return all_words_iterator, state
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
