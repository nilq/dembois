Property = {}

function Property:newValue(name, initial, get, set)

  self[name] = initial

  self["get" .. name] = get or function(self)
    return self[name]
  end

  self["set" .. name] = set or function(self, v)
    self[name] = v
    return self
  end

  return self
end

function Property:newBoolean(name, initial, get, set,
    enable, disable, toggle)
  Property.newValue(self, name, initial, get, set)

  self["enable" .. name] = enable or function(self)
    self["set" .. name](self, true)
  end

  self["disable" .. name] = disable or function(self)
    self["set" .. name](self, false)
  end

  self["toggle" .. name] = toggle or function(self)
    self["set" .. name](self, not self[name])
  end

  return self
end

function Property:newTable(name, initial, get, set,
    getCopy, getSub, setSub)
  self:newValue(name, initial, get, set)

  self["copy" .. name] = getCopy or function(self)
    return Utility.copy(self[name])
  end

  self["getSub" .. name] = getSub or function(self, a)
    return self[name][a]
  end

  self["setSub" .. name] = setSub or function(self, a, v)
    self[name][a] = v
    return self[name][a]
  end
  return self
end
