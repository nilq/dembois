require "lib/klumpfisk"

-- uniform distribution integer
function math.randi(s, e)
  return math.floor(math.random() * (e - s) + s)
end

-- uniform distribution
function math.randf(s, e)
  return math.random() * (e - s) + s
end

-- uniform distribution random number
function math.randn(mean, variance)
  local V1, V2, S
  repeat
    local U1 = math.random()
    local U2 = math.random()
    V1 = 2 * U1 - 1
    V2 = 2 * U2 - 1
    S  = V1^2 + V2^2
  until not (S > 1)
  X = math.sqrt(-2 * math.log(S) / S) * V1
  X = mean + math.sqrt(variance) * X
  return X
end

function math.sigmoid(z)
  return 1 / (1 + math.exp(-z))
end
-- end of math

love.graphics.setBackgroundColor(255, 255, 255)

local Agent = require "src/agent"
local Brain = require "src/brain"
local Food  = require "src/food"

LOG_TEXT = {}

State = "world"

math.randomseed(os.time())

for n = 0, 20 do
  Food({
    x = math.randf(0, love.graphics.getWidth()),
    y = math.randf(0, love.graphics.getHeight()),
  })
end

function spawn_agents(a)
  for n = 0, a do
    Agent({
      x = math.randf(0, love.graphics.getWidth()),
      y = math.randf(0, love.graphics.getHeight()),
    })
  end
end

food_timer = 0

spawn_agents(10)

Event:new("update", function(...)
  love.window.setTitle("The bois - " .. love.timer.getFPS() .. "fps")
  Event:emit("update_" .. State, ...)
end)

Event:new("draw", function(...)
  Event:emit("draw_" .. State, ...)
end)

Event:new("keychanged", function(key, state)
  if key == "space" and state then
    spawn_agents(1)
  end
end)

-- world update

Event:new("update_world", function(dt)
  if #Agent:getList() < 10 and false then
    Agent({
      x = math.randf(0, love.graphics.getWidth()),
      y = math.randf(0, love.graphics.getHeight()),
    })
  end
end)
