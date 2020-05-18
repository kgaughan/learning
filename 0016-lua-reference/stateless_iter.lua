a = {"one", "two", "three"}
for i, v in ipairs(a) do
  print(i, v)
end

-- This iterator is stateless, and takes the thing being iterated over (a)
-- and an iteration state (i). It returns the next iteration state and the
-- matching value.
function iter(a, i)
  i = i + 1
  local v = a[i]
  if v then 
    return i, v
  end
end

-- This creates a stateless iterator, with the second and third arguments
-- being the first and second argument used when the stateless iterator (the
-- first argument) is initially called. The second argument is meant to be
-- invariant, so it can be a mutable object, such as a table, and can have
-- its internal state change, but the object itself is always the same.
-- These three arguments are the <exp-list> after the 'in' of a generic
-- for-loop.
function local_ipairs(a)
  return iter, a, 0
end

for i, v in local_ipairs(a) do
  print(i, v)
end
