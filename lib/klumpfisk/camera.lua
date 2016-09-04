Camera = Thing()
  :newValue("X", 0):newValue("Y", 0)
  :newValue("ScaleX", 1):newValue("ScaleY", 1)
  :newValue("Rotation", 0)

function Camera.set()
  love.graphics.push()
  love.graphics.rotate(-Camera:getRotation())
  love.graphics.scale(1 / Camera:getScaleX(), 1 / Camera:getScaleY())
  love.graphics.translate(-Camera:getX(), -Camera:getY())
end

function Camera.unset()
  love.graphics.pop()
end

function Camera.getWidth() return love.graphics.getWidth() * Camera:getScaleX() end
function Camera.getHeight() return love.graphics.getHeight() * Camera:getScaleY() end
function Camera.getSize() return Camera:getWidth(), Camera:getHeight() end
