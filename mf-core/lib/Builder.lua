--- Generic builder class.
--- @class Builder

local Builder = {}

function Builder:new(o)
    o = o or {}
    o = table.deepcopy(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

--- Builds the prototype table.
--- @param overrides ?table Overrides that should be applied after the prototype is built (using merge/meld)
--- @return table The prototype table that can be applied with `data:extend`
function Builder:build(overrides)
    return table.deepcopy(overrides)
end

--- Builds and applies (`data:extend`) the prototype table.
--- @param overrides table Overrides that should be applied after the prototype is built (using merge/meld)
--- @return table The prototype table that was applied with `data:extend`
function Builder:apply(overrides)
    local result = self:build(overrides)
    data:extend({ result })
    return result
end

return Builder