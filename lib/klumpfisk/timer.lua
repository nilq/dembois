Timer = Class(nil, true)

Timer:newEvent("init", function(timer, f, a, using)
  timer:newValue("Time", a or 0)
       :newValue("Function", f or function() end)
       :newValue("Using", using or {})
  timer:newEvent("call", function()
    local newTime = timer:getFunction()(timer:getUsing(), timer)
    if newTime then
      timer:setTime(newTime)
    else
      timer:emitEvent("remove")
    end
  end)
  return timer
end)

Event:new("update", function(dt)
  for _, timer in ipairs(Timer:getList()) do
    timer:setTime(timer:getTime() - dt)
    if timer:getTime() <= 0 then
      timer:emitEvent("call")
    end
  end
end, {name = "_TIMER"})
