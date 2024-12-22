--- Belts

local BeltFactory = require(MF.logistics .. "Belts")
local Belt = BeltFactory("turtle-speed", "white", "slow")

Belt.EntityBuilder:new()
    :itemsPerSecond(2.5)
    :nextTier("")
    :undergroundDistance(2)
    :animationSpeedMultiplier(1.01)
    :apply()

Belt.ItemBuilder:new():apply()

Belt.RecipeBuilder:new()
    :ingredients("transportBelt", {
        { type = "item", name = "iron-plate", amount = 1 }
    })
    :ingredients("undergroundBelt", {
        { type = "item", name = "iron-plate", amount = 2 }
    })
    :ingredients("splitter", {
        { type = "item", name = "iron-plate", amount = 3 }
    })
    :apply()

Belt.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :ingredients({{ "automation-science-pack", 1 }})
    :apply()