#!/usr/bin/env lua

-- generate all the permutation of `a` of the first `n` elements
function gen_perm(a, n)
  n = n or #a -- default `n` to the length of `a` if unspecified

  if n == 0 then
    print_result(a)
  else
    for i = 1, n do
      a[n], a[i] = a[i], a[n] -- put i-th element in the last one
      gen_perm(a, n - 1)      -- generate all permutations of prefix
      a[n], a[i] = a[i], a[n] -- restore i-th element
    end
  end
end

function gen_perm_coro_iter(a)
  -- Note: `a` is closed over, so it doesn't need to be explicitly passed. This
  -- might have some implications for memory usage, clarity, speed, &c., but
  -- I'm not sure. I just thought it'd be cool to do so.
  local function perm(n)
    if n == 0 then
      coroutine.yield(a)
    else
      for i = 1, n do
        a[n], a[i] = a[i], a[n] -- put i-th element in the last one
        perm(n - 1)             -- generate all permutations of prefix
        a[n], a[i] = a[i], a[n] -- restore i-th element
      end
    end
  end

  -- All this could also be written:
  --
  -- local co = coroutine.create(perm)
  -- return function() -- iterator
  --   local code, res = coroutine.resume(co, #a)
  --   return res
  -- end
  return coroutine.wrap(function()
    perm(#a)
  end)
end

function print_result(a)
  for i, v in ipairs(a) do
    io.write(v, " ")
  end
  io.write("\n")
end

print("Recursion:")
gen_perm({1, 2, 3, 4})

print("Coroutine-based iterator:")
for p in gen_perm_coro_iter{"a", "b", "c", "d"} do
  print_result(p)
end
