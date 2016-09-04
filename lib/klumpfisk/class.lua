Class = setmetatable({}, {
  __call = function(self, parent, listed, named)
    local class = Thing()
    class:newValue("Class", class)
         :newValue("Parent", parent)
    setmetatable(class, {
      __index = parent,
      __call = function(self, ...)
        local thing = setmetatable(Thing(), {
          __index = class,
        })
        class:emitEvent("init", thing, ...)
             :emitEvent("postInit", thing, ...)
        return thing
      end,
    })

    if parent then
      class:newEvent("init", function(...)
        parent:emitEvent("init", ...)
      end)
      class:newEvent("postInit", function(...)
        parent:emitEvent("postInit", ...)
      end)
    end

    if listed then
      class:newTable("List", {})

      class:newEvent("init", function(thing)
        table.insert(class:getList(), thing)
        thing:newEvent("remove", function()
          table.remove(class:getList(), Utility.indexElement(thing, class:getList()))
        end)
      end)
    end

    return class
  end
})
