local Brain = Class(nil, true)
    :newValue("Size", 25)
    :newTable("Activations", {})
    :newTable("Weights", {})
    :newTable("Indexes", {})
    :newValue("Tick", nil)
    :newValue("Density", 3)
    :newValue("MutationFreq", 0.1) -- chance of mutation
    :newValue("MutationPower", 0.3)
    -- temporary output
    :newValue("Output", {})

Brain:newEvent("init", function(brain, info)
  info = info or {}

  brain:setSize(info.w or 25)
  brain:setWeights({})
  brain:setIndexes({})

  for n = 0, brain:getSize() do
    brain:getActivations()[n] = 0
  end

  for n = 1, brain:getSize() do
    brain:getWeights()[n] = {}
    brain:getIndexes()[n] = {}
    for m = 1, info.density do
      brain:getWeights()[n][m] = math.randf(-1.2, 1.2)
      brain:getIndexes()[n][m] = math.randi(0, brain:getSize())
    end
  end

  -- brain methods
  brain:newEvent("tick", function(this, s1, s2)
    this:getActivations()[1] = s1
    this:getActivations()[2] = s2
    -- bias neurons
    this:getActivations()[3] = 1
    this:getActivations()[4] = 1
    this:getActivations()[5] = 1
    this:getActivations()[6] = 1

    for n = 7, this:getSize() do
      local a = 0
      for m = 1, info.density do
        a = a + this:getWeights()[n][m] * this:getActivations()[this:getIndexes()[n][m]]
      end
      this:getActivations()[n] = math.sigmoid(a)
    end

    this:setOutput({
      out0 = this:getActivations()[this:getSize() - 1] - 0.5,
      out1 = this:getActivations()[this:getSize() - 2],
    })
  end)

  brain:newEvent("mutateFrom", function(this, other)
    for n = 1, this:getSize() do
      for m = 1, info.density do

        local i = other:getWeights()[n][m]
        if math.randf(0, 1) < info.mutfreq then
          i = i + math.randn(0, info.mutpow)
        end
        this:getWeights()[n][m] = i
        i = other:getIndexes()[n][m]
        if math.randf(0, 1) < info.mutfreq then
          i = math.randi(0, this:getSize())
        end
        this:getIndexes()[n][m] = i
      end
    end
  end)
  -- end of brain methods
end)

return Brain
