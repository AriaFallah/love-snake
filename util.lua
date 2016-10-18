local function drawRect(x, y, w, h)
  love.graphics.rectangle('fill', x, y, w, h)
end

return { drawRect = drawRect }
