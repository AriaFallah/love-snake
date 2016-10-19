-- Linked List Queue

local function Node(val)
  assert(val ~= nil)
  return { val = val, next = nil }
end

local function push(self, val)
  assert(val ~= nil)
  local n = Node(val)
  
  if self.len == 0 then self.head = n
  else self.tail.next = n end
  
  self.tail = n
  self.len = self.len + 1
end

local function pop(self)
  local val = nil
  if self.len ~= 0 then
    val = self.head.val
    self.len = self.len - 1
    self.head = self.head.next
  end
  return val
end

local methods = {
  pop = pop,
  push = push,
}

local function new()
  local list = {
    len = 0,
    head = nil,
    tail = nil,
  }
  return setmetatable(list, { __index = methods })
end

return new
