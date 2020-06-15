--
-- Base class
--

Account = {
  balance = 0,
}

function Account:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Account:withdraw(v)
  if v > self.balance then
    error("insufficient funds")
  end
  if v < 0 then
    error("you cannot withdraw negative amounts")
  end
  self.balance = self.balance - v
end

function Account:deposit(v)
  if v < 0 then
    error("you cannot deposit negative amounts")
  end
  self.balance = self.balance + v
end

--
-- Inheritance
--

SpecialAccount = Account:new {
  limit = 1000.0,
}

function SpecialAccount:withdraw(v)
  if v - self.balance >= self:get_limit() then
    error "insufficient funds"
  end
  self.balance = self.balance - v
end

function SpecialAccount:get_limit()
  return self.limit or 0
end
