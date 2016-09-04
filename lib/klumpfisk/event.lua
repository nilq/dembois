Event = {events = {}}

function Event:new(name, f, info)
  local info = info or {}
  if not self.events[name] then
    self.events[name] = {}
  end
  local event = {
    newValue   = Property.newValue,
    newBoolean = Property.newBoolean,
  }
  event:newValue("Function", f)
       :newValue("Name", info.subName)
       :newValue("Active", info.active or info.active == nil)
  table.insert(self.events[name], info.index or #self.events[name] + 1, event)

  return event
end

function Event:emit(name, ...)
  for _, e in ipairs(self.events[name] or {}) do
    if e:getActive() then
      if e:getFunction()(...) then
        break
      end
    end
  end
  return self
end

function Event:remove(name)
  table.remove(self.events[Utility.indexElement(name, self.events)])
  return self
end

function Event:removeSub(name, sub)
  for i, e in ipairs(self.events[name]) do
    if e:getName() == sub then
      table.remove(self.events[name], i)
    end
  end
  return self
end

function Event:setSub(name, sub, state)
  for _, e in ipairs(self.events[name]) do
    if e:getName() == sub then
      e:setActive(state)
    end
  end
  return self
end

function Event:enableSub(name, sub)
  for _, e in ipairs(self.events[name]) do
    if e:getName() == sub then
      e:setActive(true)
    end
  end
  return self
end

function Event:disableSub(name, sub)
  for _, e in ipairs(self.events[name]) do
    if e:getName() == sub then
      e:setActive(false)
    end
  end
  return self
end

function Event:toggleSub(name, sub)
  for _, e in ipairs(self.events[name]) do
    if e:getName() == sub then
      e:toggleActive()
    end
  end
  return self
end
