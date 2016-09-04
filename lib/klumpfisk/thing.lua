Thing = setmetatable({}, {
  __call = function(parent)
    local thing = setmetatable({
      events          = {},
      newValue        = Property.newValue,
      newBoolean      = Property.newBoolean,
      newTable        = Property.newTable,
      newEvent        = Event.new,
      emitEvent       = Event.emit,
      removeEvent     = Event.remove,
      removeSubEvent  = Event.removeSub,
      setSubEvent     = Event.setSub,
      enableSubEvent  = Event.enableSub,
      disableSubEvent = Event.disableSub,
      toggleSubEvent  = Event.toggleSub,
    }, {
      __index = parent,
    })
    return thing
  end
})
