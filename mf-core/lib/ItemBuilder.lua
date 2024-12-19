--- Generic entity builder class.
--- @class ItemBuilder : Builder

local Builder = require("Builder")

local ItemBuilder = Builder:new({
    _weight = 200 * kg
})

--- Sets the weight of the item calculated from given count per rocket.
--- @param count number The amount of items that fit into a rocket
--- @return ItemBuilder
function ItemBuilder:itemsPerRocket(count)
    self._weight = (1000 / count) * kg
    return self
end

return ItemBuilder