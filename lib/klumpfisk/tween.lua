Tween = Class(nil, true)
Tween:newTable("Object", Thing())
Tween:newValue("CurrentTime", 0)
Tween:newValue("Duration", 0)
Tween:newTable("StartVars", {})
Tween:newTable("TargetVars", {})
Tween:newValue("Ease", "quadinout")
Tween:newValue("Bounce", 1.70158)

Tween:newTable("Tweens", {
   linear = function(t, b, c, d) return c * t / d + b end,

   quadin = function(t, b, c, d) local t = t / d return c * math.pow(t, 2) + b end,
   quadout = function(t, b, c, d) local t = t / d return -c * t * (t - 2) + b end,
   quadinout = function(t, b, c, d)
      local t = t / d * 2
      if (t < 1) then return c / 2 * math.pow(t, 2) + b
      else return -c / 2 * ((t - 1) * (t - 3) - 1) + b end
   end,

   backin = function(t, b, c, d, s)
      s = s or 1.70158
      t = t / d
      return c * t * t * ((s + 1) * t - s) + b
   end,
   backout = function(t, b, c, d, s)
      s = s or 1.70158
      t = t / d - 1
      return c * (t * t * ((s + 1) * t + s) + 1) + b
   end,
   backinout = function(t, b, c, d, s)
      s = (s or 1.70158) * 1.525
      t = t / d * 2
      if t < 1 then return c / 2 * (t * t * ((s + 1) * t - s)) + b end
      t = t - 2
   return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
   end,

   bouncein = function(t, b, c, d) return c - Tween:getTweens()["bounceout"](d - t, 0, c, d) + b end,
   bounceout = function(t, b, c, d)
      t = t / d
      if t < 1 / 2.75 then return c * (7.5625 * t * t) + b end
      if t < 2 / 2.75 then
         t = t - (1.5 / 2.75)
         return c * (7.5625 * t * t + 0.75) + b
      elseif t < 2.5 / 2.75 then
         t = t - (2.25 / 2.75)
         return c * (7.5625 * t * t + 0.9375) + b
      end
      t = t - (2.625 / 2.75)
      return c * (7.5625 * t * t + 0.984375) + b
   end,
   bounceinout = function(t, b, c, d)
      if t < d / 2 then return Tween:getTweens()["bouncein"](t * 2, 0, c, d) * 0.5 + b end
      return Tween:getTweens()["bounceout"](t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
   end,
})

Tween:newEvent("init", function(tween, obj, duration, vars, info)
   local info = info or {}

   tween:setObject(obj)
   tween:setDuration(duration)
   tween:setStartVars({})
   tween:setTargetVars({})
   tween:setEase(info.ease)
   tween:setBounce(info.bounce)

   for var, target in pairs(vars) do
      local sv

      if obj["get"..var] then sv = obj["get"..var](obj)
      else sv = obj[var] end

      tween:setSubStartVars(var, sv)
      tween:setSubTargetVars(var, target)
   end

   if info.complete then tween:newEvent("complete", info.complete) end
   if info.update then tween:newEvent("update", info.update) end
end)

Event:new("update", function(dt)
   for _, tween in ipairs(Tween:getList()) do
      tween:setCurrentTime(math.min(tween:getCurrentTime() + dt, tween:getDuration()))

      for var, value in pairs(tween:getStartVars()) do
         local tv = tween:getSubTargetVars(var)
         if type(tv) == "function" then tv = tv() end

         newVal = Tween:getTweens()[tween:getEase()](tween:getCurrentTime(), value, tv - value, tween:getDuration(), tween:getBounce())
         if tween:getObject()[var] then tween:getObject()[var] = newVal
         elseif tween:getObject()["set"..var] then tween:getObject()["set"..var](tween:getObject(), newVal) end
      end

      tween:emitEvent("update", tween, dt)
      if tween:getCurrentTime() == tween:getDuration() then
         tween:emitEvent("complete", obj)
         tween:emitEvent("remove")
      end
   end
end, {name = "TWEEN"})
