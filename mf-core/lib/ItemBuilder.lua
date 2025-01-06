--- Generic entity builder class.
--- @class ItemBuilder : Builder

local Builder = require("Builder")

local ItemBuilder = Builder:new({
    _weight = 200 * kg,
    _order = "a"
})

--- Sets the weight of the item calculated from given count per rocket.
--- @param count number The amount of items that fit into a rocket
--- @return ItemBuilder
function ItemBuilder:itemsPerRocket(count)
    self._weight = (1000 / count) * kg
    return self
end

--- Sets the order string (letter) of the item. The first letter will be a, b or c for the transport belt, underground belt and splitter. The second will be the letter defined here.
--- @param order string The order string (default: "a")
--- @return ItemBuilder
function ItemBuilder:order(order)
    self._order = order
    return self
end

return ItemBuilder
