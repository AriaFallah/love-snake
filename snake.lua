local util = require 'util'
local Queue = require 'queue'

local function handleCollision(_, other)
  return other.name == 'food' and 'cross' or 'touch'
end

local function grow(snake, x, y)
  local newSegment = { x = x, y = y }

  -- Add the new segment to the head and update snake accordingly
  snake.head = newSegment
  snake.score = snake.score + 1
  snake.length = snake.length + 1
  snake.body[snake.length] = newSegment

  -- Add the new segment to the world
  snake.world:add(newSegment, x, y, snake.size, snake.size)
end

local function update(self)
  local q, size = self.q, self.size

  self.buffer = self.buffer + self.speed
  while self.buffer > size do
    local head = self.head
    local goalX, goalY = head.x, head.y
    local prev = { x = head.x, y = head.y }
    self.direction = q:pop() or self.direction

    -- Move the snake's head to the next location
    if self.direction == 'up' then goalY = goalY - size
    elseif self.direction == 'down' then goalY = goalY + size
    elseif self.direction == 'left' then goalX = goalX - size
    elseif self.direction == 'right' then goalX = goalX + size end

    -- Move snake in world and check for collisions
    local _, _, cols, len = self.world:move(head, goalX, goalY, handleCollision)
    if len > 0 then
      local other = cols[1].other
      if other.name == 'food' then
        other:update()
        grow(self, goalX, goalY)
      else return false end
    else
      -- Actually move if there's no collision
      head.x = goalX
      head.y = goalY
    end

    -- Make the body follow the head
    for i = #self.body - 1, 1, -1 do
      local segment = self.body[i]
      local temp = { x = segment.x, y = segment.y }

      -- Adjust position of body segment
      segment.x = prev.x
      segment.y = prev.y
      prev = temp

      -- Reposition each segment in the world
      -- We use "update" because it's not possible for the body to collide
      -- with anything because it's following the head
      self.world:update(segment, segment.x, segment.y)
    end

    self.buffer = self.buffer - size
  end

  return true
end

local function draw(self)
  for i = 1, #self.body do
    local segment = self.body[i]
    util.drawRect(segment.x, segment.y, self.size)
  end
end

local methods = {
  draw = draw,
  update = update,
}

local function new(startPos, world)
  local q = Queue()

  local snake = {
    q = q,
    body = {},
    size = 10,
    speed = 5,
    score = 0,
    buffer = 0,
    length = 5,
    alive = true,
    world = world,
    direction = 'right',
  }

  function love.keypressed(key)
    -- Queue up to two changes of direction for the snake
    if q.len < 2 then
      local direction = q.tail and q.tail.val or snake.direction
      if key == 'up'    and direction ~= 'down'  and direction ~= key then q:push(key) end
      if key == 'down'  and direction ~= 'up'    and direction ~= key then q:push(key) end
      if key == 'left'  and direction ~= 'right' and direction ~= key then q:push(key) end
      if key == 'right' and direction ~= 'left'  and direction ~= key then q:push(key) end
    end
  end

  -- Initialize the body segments
  for i = 1, snake.length do
    local segment = {
      y = startPos.y,
      x = startPos.x + snake.size * (i - 1),
    }

    snake.body[i] = segment
    world:add(segment, segment.x, segment.y, snake.size, snake.size)
  end

  -- Create the head reference
  snake.head = snake.body[snake.length]

  -- Return the new snake with its prototype
  return setmetatable(snake, { __index = methods })
end

return new
