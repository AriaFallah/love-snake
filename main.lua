-- first love game

local Snake = require 'snake'

local tileSize = 10
local snake = Snake(tileSize, 10, 1)

local window = {
  startX = tileSize,
  startY = tileSize,
}
window.width = love.graphics.getWidth() - window.startX * 2
window.height = love.graphics.getHeight() - window.startY * 2

function love.update()
  snake:update()
end

function love.draw()
  -- Draw snake
  snake:draw(window.startX, window.startY)
  
  -- Draw boundaries
  love.graphics.rectangle('line', window.startX, window.startY, window.width, window.height)
end

