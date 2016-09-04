Math = {}

function Math.distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1))
end

function Math.angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

function Math.magnitude(x, y)
  return math.sqrt(x^2 + y^2)
end

function Math.sign(n)
  if n < 0 then
    return -1
  end
  return 1
end

function Math.normalize(x, y)
  local m = Math.magnitude(x, y)
  if m > 0 then
    return x / m, y / m
  end
  return 0, 0
end

function Math.clamp(a, b, n)
  if n < a then
    return a
  elseif n > b then
    return b
  end
  return n
end

function Math.lerp(a, b, t)
  return (1 - t) * a + t * b
end

function Math.round(n)
  return math.floor(n + 0.5)
end

function Math.clampMagnitude(n, m)
  return Math.round(n / m) * m
end

function Math.randomBool()
  return math.random(0, 1) == 0
end

function Math.circlefy(x, y, a, r)
  return x + r * math.cos(a), y + r * math.sin(a)
end

function Math.rectIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2
     and x1 + w1 > x2
     and y1 < y2 + h2
     and y1 + h1 > y2
end

function Math.pointIntersect(x1, y1, w, h, x2, y2)
  return Math.rectIntersect(x1, y1, w, h, x2, y2, 0, 0)
end

function Math.getOverlap(x1, y1, w1, h1, x2, y2, w2, h2)
   local x3, y3 = math.max(x1, x2), math.max(y1, y2)
   local x4, y4 = math.min(x1 + w1, x2 + w2), math.min(y1 + h1, y2 + h2)

   return x3, y3, x4 - x3, y4 - y3
end
