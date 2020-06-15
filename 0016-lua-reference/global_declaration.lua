#!/usr/bin/env lua

-- allow 'lua -i global_declaration.lua' to work
_PROMPT = "> "

local declaredNames = {}

function declare(name, initial)
  rawset(_G, name, initial)
  declaredNames[name] = true
end

setmetatable(_G, {
  __newindex = function(tbl, name, val)
    if not declaredNames[name] then
      error("attempt to write to undeclared variable " .. name, 2)
    else
      rawset(tbl, name, val) -- do the actual set
    end
  end,

  __index = function(_, name)
    if not declaredNames[name] then
      error("attempt to read undeclared variable " .. name, 2)
    else
      return nil
    end
  end,
})
