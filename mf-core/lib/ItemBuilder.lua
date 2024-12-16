local Builder = require("Builder")

local ItemBuilder = Builder:new({
    _weight = 200 * kg
})

function ItemBuilder:itemsPerRocket(count)
    self._weight = (1000 / count) * kg
    return self
end

return ItemBuilder