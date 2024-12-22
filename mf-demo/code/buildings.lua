-- Lumber mill

local LumberMillFactory = require(MF.buildings .. "LumberMill")
local LumberMill = LumberMillFactory()

data:extend({
    {
        type = "recipe-category",
        name = "wood-processing-or-assembling"
    }
})

LumberMill.EntityBuilder:new()
    :burnerEnergySource({ emissions_per_minute = { pollution = 4 } })
    :baseProductivity(0.5)
    :apply({
        crafting_categories = { "wood-processing-or-assembling" },
        crafting_speed = 4,
        energy_usage = "1MW",
    })

LumberMill.ItemBuilder:new():apply()

LumberMill.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "stone-brick",        amount = 40 },
        { type = "item", name = "wood",               amount = 100 },
        { type = "item", name = "iron-gear-wheel",    amount = 100 },
        { type = "item", name = "copper-plate",       amount = 60 },
        { type = "item", name = "assembling-machine-1", amount = 5 }
    })
    :apply({
        category = "wood-processing-or-assembling"
    })

LumberMill.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()


-- Atom forge

local AtomForgeFactory = require(MF.buildings .. "AtomForge")
local AtomForge = AtomForgeFactory()

AtomForge.EntityBuilder:new()
    :burnerEnergySource({
        fuel_categories = nil, -- Remove default before adding new
        emissions_per_minute = { pollution = nil }
    })
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories),
        crafting_speed = 8,
        energy_usage = "4MW",
        energy_source = {
            fuel_categories = { "nuclear", "fusion" }
        }
    })

AtomForge.ItemBuilder:new():apply()

AtomForge.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "stone-brick", amount = 40 }
    })
    :apply()

AtomForge.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
