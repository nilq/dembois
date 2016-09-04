local Food = Class(nil, true)
    :newValue("X", 0):newValue("Y", 0)

Food:newEvent("init", function(food, info)
  info = info or {}
  food:setX(info.x)
      :setY(info.y)
end)

Event:new("update_world", function(dt)
  food_timer = food_timer + dt * 5
  if food_timer > 1 and #Food:getList() < 30 then
    Food({
      x = math.randf(0, love.graphics.getWidth()),
      y = math.randf(0, love.graphics.getHeight()),
    })
    food_timer = 0
  end
end)

Event:new("draw_world", function(dt)
  for _, f in ipairs(Food:getList()) do
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", f:getX(), f:getY(), 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", f:getX(), f:getY(), 10)
  end
end)

return Food
