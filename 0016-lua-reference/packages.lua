local P = {}
complex = P -- package name

function P.new(r, i)
  return {
    r = r,
    i = i,
  }
end

-- defines a constant 'I'
P.I = P.new(0, 1)

local function check_type(c)
  if not (type(c) == "table" and tonumber(c.r) and tonumber(c.i)) then
    error("bad complex number", 3)
  end

function P.add(c1, c2)
  check_type(c1)
  check_type(c2)
  return P.new(c1.r + c2.r, c1.i + c2.i)
end

function P.sub(c1, c2)
  check_type(c1)
  check_type(c2)
  return P.new(c1.r - c2.r, c1.i - c2.i)
end

function P.mul(c1, c2)
  check_type(c1)
  check_type(c2)
  return P.new(
    c1.r * c2.r - c1.i * c2.i,
    c1.r * c2.i + c1.i * c2.r,
  )
end

function P.inv(c)
  check_type(c)
  local n = c.r ^ 2 + c.i ^ 2
  return P.new(c.r / n, -c.i / n)
end

return complex
