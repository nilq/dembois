Utility = {}

function Utility.indexElement(a, n)
  for i, v in ipairs(n) do
    if v == n then
      return i
    end
  end
end

function Utility.mergeTable(a, b)
  for i, v in ipairs(b) do
    a[i] = v
    if type(v) == "table" then
      if type(a[i]) == "table" then
        Utility.mergeTable(a[i] or {}, b[i] or {})
      end
    end
  end
  return a
end

function Utility.copy(n)
  local n_type, copy = type(n), n
  if n_type == "table" then
    copy = {}
    for n_i, n_v in ipairs(n) do
      copy[n_i] = n_v
    end
  end
  return copy
end

function Utility.deepCopy(n)
  local n_type, copy = type(n), n
  if n_type == "table" then
    copy = {}
    for n_i, n_v in next, n, nil do
      copy[Utility.deepCopy(n_i)] = Utility.deepCopy(n_v)
    end
    setmetatable(copy, Utility.deepCopy(getmetatable(n)))
  end
  return copy
end
