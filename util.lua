local function drawRect(x, y, w, h)
  assert(x ~= nil and y ~= nil and w ~= nil)
  love.graphics.rectangle('fill', x, y, w, h or w)
end

local function roundToNearestX(num, x)
  num = num / x
  if math.fmod(num, 1) >= 0.5 then return math.ceil(num) * x
  else return math.floor(num) * x end
end

return {
  drawRect = drawRect,
  roundToNearestX = roundToNearestX,
}
