local util = require 'util'
local Food = require 'food'
local Snake = require 'snake'
local bump = require 'lib.bump'

-- World
local world
local window

-- Entities
local food
local snake
local walls

function love.load()
  love.window.setTitle('Snake')

  world = bump.newWorld()
  window = {
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight()
  }

  snake = Snake({ x = 20, y = 20 }, world)
  food = Food(10, window.w - 10, 10, window.h - 10, world)
  walls = {
    { name = 'top',    x = 0,             y = 0,             w = window.w, h = 10            },
    { name = 'bottom', x = 0,             y = window.h - 10, w = window.w, h = 10            },
    { name = 'left',   x = 0,             y = 10,            w = 10,       h = window.h - 10 },
    { name = 'right',  x = window.w - 10, y = 10,            w = 10,       h = window.h - 10 },
  }

  -- Add walls to world
  for i = 1, #walls do
    local wall = walls[i]
    world:add(wall, wall.x, wall.y, wall.w, wall.h)
  end

end

function love.update()
  -- Keep updating the snake while it hasn't collided with anything
  if snake.alive then snake.alive = snake:update() end
end

function love.draw()
  -- Draw food
  food:draw()

  -- Draw snake
  snake:draw()

  -- Draw score
  love.graphics.printf('Score: ' .. snake.score, 15, 15, 150, 'left')
  
  -- Draw walls
  for i = 1, #walls do
    local wall = walls[i]
    util.drawRect(wall.x, wall.y, wall.w, wall.h)
  end
end
