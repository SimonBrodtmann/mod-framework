local Builder = {}

function Builder:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Builder:build(overrides)
    return table.deepcopy(overrides)
end

function Builder:apply(overrides)
    local result = self:build(overrides)
    data:extend({ result })
    return result
end

return Builder