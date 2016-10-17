-- first love game

function love.load(arg)
  tile = {
    x = 10,
    y = 10,
  }
  
  snake = {
    x = 0,
    y = 0,
    size = 15,
    body = {},
    speed = 0.5,
    direction = 'right',
  }

  -- Snake body is 10 tiles wide per segment
  for i = 0, snake.size do
    snake.body[i] = { x = tile.x * (i - 1), y = 0 }
  end
end

function love.update(dt)
  local last = snake.body[#snake.body]
  local prev = { x = last.x, y = last.y }
  
  if love.keyboard.isDown('up') and snake.direction ~= 'down' then snake.direction = 'up' end
  if love.keyboard.isDown('down') and snake.direction ~= 'up' then snake.direction = 'down' end
  if love.keyboard.isDown('left') and snake.direction ~= 'right' then snake.direction = 'left' end
  if love.keyboard.isDown('right') and snake.direction ~= 'left' then snake.direction = 'right' end

  if snake.direction == 'up' then last.y = last.y - snake.speed * tile.y end
  if snake.direction == 'down' then last.y = last.y + snake.speed * tile.y end
  if snake.direction == 'left' then last.x = last.x - snake.speed * tile.x end
  if snake.direction == 'right' then last.x = last.x + snake.speed * tile.x end

  for i = #snake.body - 1, 1, -1 do
    local temp = { x = snake.body[i].x, y = snake.body[i].y }
    snake.body[i].x = prev.x
    snake.body[i].y = prev.y
    prev = temp
  end
end

function love.draw(dt)
  for i = 0, #snake.body do
    love.graphics.rectangle("fill", snake.body[i].x, snake.body[i].y, tile.x, tile.y)
  end
end

