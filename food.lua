local util = require 'util'

local function randCoord(food)
  local x = util.roundToNearestX(love.math.random(food.xmin, food.xmax), 10)
  local y = util.roundToNearestX(love.math.random(food.ymin, food.ymax), 10)
  return x, y
end

local function update(self)
  self.x, self.y = randCoord(self)
  self.world:update(self, self.x, self.y)
end

local function draw(self)
  util.drawRect(self.x, self.y, 10)
end

local methods = {
  draw = draw,
  update = update,
}

local function new(xmin, xmax, ymin, ymax, world)
  local food = {
    xmin = xmin,
    xmax = xmax,
    ymin = ymin,
    ymax = ymax,
    name = 'food',
    world = world,
  }
  food.x, food.y = randCoord(food)
  
  world:add(food, food.x, food.y, 10, 10)
  return setmetatable(food, { __index = methods })
end

return new
