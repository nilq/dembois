Input = Thing():newTable("Key", {})
    :newTable("Button", {})
    :newTable("Touch", {})
    :newTable("Gamepad", {})
    :newTable("Joystick", {})

Event:new("keychanged", function(key, state)
  Input:setSubKey(key, state)
end)

function Input.isKeyDown(key)
  return Input:getSubKey(key) or false
end

function Input.isKeyDownAny(keys)
  for _, key in ipairs(keys) do
    if Input.isKeyDown(key) then
      return true
    end
  end
  return false
end

function Input.isKeyDownAll(keys)
  for _, key in ipairs(keys) do
    if not Input.isDown(key) then
      return false
    end
  end
  return true
end

function Input.isButtonDown(button)
  return Input:getSubButton(button) or false
end

function Input.isButtonDownAny(buttons)
  for _, b in ipairs(buttons) do
    if Input.isButtonDown(b) then
      return true
    end
  end
  return false
end

function Input.isButtonDownAll(buttons)
  for _, b in ipairs(buttons) do
    if not Input.isButtonDown(b) then
      return false
    end
  end
  return true
end

function Input.isTouchDown(touch)
  return Input:getSubTouch(touch) or false
end

function Input.isTouchDownAny(touches)
  for _, t in ipairs(touches) do
    if Input.isTouchDown(t) then
      return true
    end
  end
  return false
end

function Input.isTouchDownAll(touches)
  for _, t in ipairs(touches) do
    if not Input.isTouchDown(t) then
      return false
    end
  end
  return true
end

function Input.isGamepadDown(pad)
  return Input:getSubGamepad(pad) or false
end

function Input.isGamepadDownAny(pads)
  for _, p in ipairs(pads) do
    if Input.isGamepadDown(p) then
      return true
    end
  end
  return false
end

function Input.isGamepadDownAll(pads)
  for _, p in ipairs(pads) do
    if not Input.isGamepadDown(p) then
      return false
    end
  end
  return true
end

function Input.isJoystickDown(stick)
  return Input:getSubJoystick(stick) or false
end

function Input.isJoystickDownAny(sticks)
  for _, s in ipairs(sticks) do
    if Input.isJoystickDown(s) then
      return true
    end
  end
  return false
end

function Input.isJoystickDownAll(sticks)
  for _, s in ipairs(sticks) do
    if not Input.isJoystickDown(s) then
      return false
    end
  end
  return true
end
