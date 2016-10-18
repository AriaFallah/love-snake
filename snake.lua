local util = require 'util'

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
  local head = self.head
  local size = self.size
  local direction = self.direction
  local goalX, goalY = head.x, head.y
  local prev = { x = head.x, y = head.y }

  -- Figure out which way the snake should go
  if love.keyboard.isDown('up') and direction ~= 'down' then self.direction = 'up' end
  if love.keyboard.isDown('down') and direction ~= 'up' then self.direction = 'down' end
  if love.keyboard.isDown('left') and direction ~= 'right' then self.direction = 'left' end
  if love.keyboard.isDown('right') and direction ~= 'left' then self.direction = 'right' end
  
  -- Move the snake's head to the next location
  if direction == 'up' then goalY = goalY - self.speed * size
  elseif direction == 'down' then goalY = goalY + self.speed * size
  elseif direction == 'left' then goalX = goalX - self.speed * size
  elseif direction == 'right' then goalX = goalX + self.speed * size end

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
  assert(startPos ~= nil and world ~= nil)
  
  local snake = {
    body = {},
    size = 10,
    speed = 1,
    score = 0,
    length = 5,
    alive = true,
    world = world,
    direction = 'right',
  }

  -- Initialize the body segments
  for i = 1, snake.length do
    local segment = {
      y = startPos.y,
      name = 's' .. i,
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
