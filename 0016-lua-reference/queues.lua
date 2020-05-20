--
-- This version makes it a proper class
--

List = {}

function List:new()
  o = {
    first = 0,
    last = -1,
  }

  -- Boilerplate to turn 'o' into a List object.
  setmetatable(o, self)
  self.__index = self
  return o
end

function List:push_left(value)
  local first = self.first - 1
  self.first = first
  self[first] = value
end

function List:push_right(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function List:pop_left()
  local first = self.first
  if first > self.last then
    error("list is empty")
  end
  local value = self[first]
  self[first] = nil -- to allow garbage collection
  self.first = first + 1
  return value
end

function List:pop_right()
  local last = self.last
  if self.first > last then
    error("list is empty")
  end
  local value = self[last]
  self[last] = nil -- to allow garbage collection
  self.last = last - 1
  return value
end

l = List:new()
l:push_left(5)
l:push_left(3)
l:push_left(7)
l:push_left(9)
assert(l:pop_right() == 5)
assert(l:pop_right() == 3)
assert(l:pop_left() == 9)
assert(l:pop_left() == 7)
