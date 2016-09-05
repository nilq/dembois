local Brain = require "src/brain"
local Food  = require "src/food"

local Agent = Class(nil, true)
    :newValue("X", 0):newValue("Y", 0)
    :newValue("VelX", 0):newValue("VelY", 0)
    :newValue("Radius", 15)
    :newValue("Rotation", 0)
    :newValue("Speed", 4)
    :newValue("Boost", 0)
    :newValue("Health", 1)
    :newValue("Rep", 0)
    -- eyes
    :newValue("EyeSecant", 0.6) -- radians!
    :newValue("EyeLength", 30)
    :newValue("EyeSens", 0.00025)
    :newValue("EyeMult", 0.5)
    -- food
    :newValue("FoodLoss", 0.002)
    :newValue("FoodGain", 0.85)
    :newValue("RepFreq", 3) -- replication threshold
    -- brain
    :newValue("Brain", nil)
    :newValue("BrainSize", 25) -- >10
    :newValue("BrainDensity", 3) -- max synapses per neuron
    -- misc
    :newValue("Color", {})
    :newValue("BoostCost", 0.001)
    :newValue("MutationFreq", 0.1) -- chance of mutation
    :newValue("MutationPower", 0.3) -- how much mutation?
    -- sensors
    :newValue("S1", 0)
    :newValue("S2", 0)

Agent:newEvent("init", function(agent, info)
  info = info or {}
  agent:setX(info.x)
       :setY(info.y)
       :setVelX(info.vx)
       :setVelY(info.vy)
       :setRotation(info.rot)
       :setColor(info.color or {
         r = math.random(0, 255) / 255,
         g = math.random(0, 255) / 255,
         b = math.random(0, 255) / 255,
       })
       :setBrain(
          Brain({
            density = agent:getBrainDensity(),
            mutfreq = agent:getMutationFreq(),
            mutpow  = agent:getMutationPower(),
          })
       )
  -- methods
  agent:newEvent("collide", function(this, other)
    local d = Math.distance(this:getX(), this:getY(),
                            other:getX(), other:getY())
    local overlap = this:getRadius() * 2 - d
    if overlap > 0 and d > 1 then
      -- "pushing of the boostest"
      local aggression = other:getBoost() / (this:getBoost() + other:getBoost())
      if this:getBoost() < 0.01 and other:getBoost() < 0.01 then
        aggression = 0.5
      end
      local ff2 = (overlap * aggression) / d
      local ff1 = (overlap * (1 - aggression)) / d

      other:setX((other:getX() - this:getX()) * ff2)
           :setY((other:getY() - this:getY()) * ff2)

      this:setX((other:getX() - this:getX()) * ff1)
          :setY((other:getY() - this:getY()) * ff1)
    end
  end)
end)

Event:new("update_world", function(dt)
  for i, a in ipairs(Agent:getList()) do
    -- movement
    a:setX(a:getX() + (a:getBoost() + a:getSpeed()) * math.cos(a:getRotation()))
     :setY(a:getY() + (a:getBoost() + a:getSpeed()) * math.sin(a:getRotation()))

    if a:getX() < 0 then
      a:setX(love.graphics.getWidth())
    elseif a:getX() > love.graphics.getWidth() then
      a:setX(0)
    end

    if a:getY() < 0 then
      a:setY(love.graphics.getHeight())
    elseif a:getY() > love.graphics.getHeight() then
      a:setY(0)
    end
    -- hunger
    a:setHealth(a:getHealth() - a:getFoodLoss() * dt * 45)
     :setHealth(a:getHealth() - a:getBoostCost() * dt * 45 * a:getBoost())
    -- kill
    if a:getHealth() < 0 then
      LOG_TEXT[#LOG_TEXT + 1] = string.format("Boi (%s) has starved to death", a)
      table.remove(Agent:getList(), i)
    end
    -- collision
    for j, b in ipairs(Agent:getList()) do
      if i ~= j then
        --a:emitEvent("collide", a, b)
      end
    end
    -- eat and sense things
    for j, f in ipairs(Food:getList()) do
      -- eat
      local d = Math.distance(a:getX(), a:getY(),
                              f:getX(), f:getY())
      if d < a:getRadius() then
        a:setRep(a:getRep() + a:getFoodGain())
        a:setHealth(a:getHealth() + a:getFoodGain())
        if a:getHealth() > 1 then
          a:setHealth(1)
        end
        -- kill food
        table.remove(Food:getList(), j)
      end
      -- sense
      if d < a:getRadius() * 10 then
        -- "for efficiency, don't even bother if it's too far"
        local x1 = a:getX() + a:getEyeLength() * math.cos(a:getRotation() - a:getEyeSecant())
        local y1 = a:getY() + a:getEyeLength() * math.sin(a:getRotation() - a:getEyeSecant())

        local x2 = a:getX() + a:getEyeLength() * math.cos(a:getRotation() + a:getEyeSecant())
        local y2 = a:getY() + a:getEyeLength() * math.sin(a:getRotation() + a:getEyeSecant())

        a:setS1(a:getEyeMult() * math.exp(-a:getEyeSens() * (math.pow(x1 - f:getX(), 2) + math.pow(y1 - f:getY(), 2))))
         :setS2(a:getEyeMult() * math.exp(-a:getEyeSens() * (math.pow(x2 - f:getX(), 2) + math.pow(y2 - f:getY(), 2))))
      end
    end
    -- feed forward brain
    a:getBrain():emitEvent("tick", a:getBrain(), {
      [1]=a:getS1(), [2]=a:getS2(),
      [3]=a:getHealth(),
      [4]=1,
      [5]=1,
      [6]=1,
    })

    local des = a:getBrain():getOutput().out0
    -- apply output0 : turning
    if des > 0.8 then
      des = 0.8
    elseif des < -0.8 then
      des = -0.8
    end
    a:setRotation(a:getRotation() + des)
    -- apply output1 : boosting
    des = a:getBrain():getOutput().out1
    if des > 0 then
      a:setBoost(des)
    else
      a:setBoost(0)
    end
    -- end feed forward
    -- give birth
    if a:getRep() > a:getRepFreq() then
      local newA = Agent({
        x = a:getX() + math.randf(-30,30),
        y = a:getY() + math.randf(-30,30),
        birth = true,
        color = a:getColor(),
      })

      newA:getBrain():emitEvent("mutateFrom", newA:getBrain(), a:getBrain())

      LOG_TEXT[#LOG_TEXT + 1] = string.format("Boi (%s) has given birth to boi (%s)", a, newA)

      a:setRep(0)
    end
  end
end)

Event:new("draw_world", function()

  for _, a in ipairs(Agent:getList()) do

    -- eyes

    local a1 = -a:getEyeSecant()
    local a2 = a:getEyeSecant()

    local x1 = math.cos(a1 + a:getRotation()) * a:getEyeLength()
    local y1 = math.sin(a1 + a:getRotation()) * a:getEyeLength()

    local x2 = math.cos(a2 + a:getRotation()) * a:getEyeLength()
    local y2 = math.sin(a2 + a:getRotation()) * a:getEyeLength()

    love.graphics.line(a:getX(), a:getY(), a:getX() + x1, a:getY() + y1)
    love.graphics.line(a:getX(), a:getY(), a:getX() + x2, a:getY() + y2)

    local r = Math.round(a:getS1() * 255)

    love.graphics.setColor(r, 0, 0)
    love.graphics.circle("fill", a:getX() + x1, a:getY() + y1, 5)

    r = Math.round(a:getS2() * 255)

    love.graphics.setColor(r, 0, 0)
    love.graphics.circle("fill", a:getX() + x2, a:getY() + y2, 5)

    -- body

    local c = Math.round(a:getHealth() * 255)
    love.graphics.setColor(c * a:getColor().r, c * a:getColor().g, c * a:getColor().b)
    love.graphics.circle("fill", a:getX(), a:getY(), a:getRadius())

    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", a:getX(), a:getY(), a:getRadius())
  end
end)

return Agent
