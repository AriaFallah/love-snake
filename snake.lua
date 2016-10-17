-- snake entity

local function update(self)
  local head = self.head
  local size = self.segmentSize
  local direction = self.direction

  -- Figure out which way the snake should go
  if love.keyboard.isDown('up') and direction ~= 'down' then self.direction = 'up' end
  if love.keyboard.isDown('down') and direction ~= 'up' then self.direction = 'down' end
  if love.keyboard.isDown('left') and direction ~= 'right' then self.direction = 'left' end
  if love.keyboard.isDown('right') and direction ~= 'left' then self.direction = 'right' end

  -- Move the snake's head to the next location
  if direction == 'up' then head.y = head.y - self.speed * size end
  if direction == 'down' then head.y = head.y + self.speed * size end
  if direction == 'left' then head.x = head.x - self.speed * size end
  if direction == 'right' then head.x = head.x + self.speed * size end

  -- Make the body follow the head
  for i = #self.body - 1, 1, -1 do
    local temp = { x = self.body[i].x, y = self.body[i].y }
    self.body[i].x = head.x
    self.body[i].y = head.y
    head = temp
  end
end

local function draw(self, x, y)
  assert(x ~= nil and y ~= nil)
  
  for i = 1, #self.body do
    local xPos = x + self.body[i].x
    local yPos = y + self.body[i].y
    love.graphics.rectangle("fill", xPos, yPos, self.segmentSize, self.segmentSize)
  end
end

local methods = {
  draw = draw,
  update = update,
}

local function new(tileSize, snakeLength, snakeSpeed)
  assert(tileSize ~= nil and snakeLength ~= nil and snakeSpeed ~= nil)
  
  local snake = {
    body = {},
    speed = snakeSpeed,
    direction = 'right',
    length = snakeLength,
    segmentSize = tileSize,
  }

  -- Initialize the body segments
  for i = 1, snake.length do
    snake.body[i] = { x = snake.segmentSize * (i - 1), y = 0 }
  end

  -- Create the head
  snake.head = snake.body[snake.length]

  -- Return the new snake with its prototype
  return setmetatable(snake, { __index = methods })
end

return new
