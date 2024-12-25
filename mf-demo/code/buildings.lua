local mfUtil = require(MF.lib .. "util")

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
    :allowProductivity(true)
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

data.raw.recipe["wooden-chest"].category = "wood-processing-or-assembling"
data.raw.recipe["small-electric-pole"].category = "wood-processing-or-assembling"
table.insert(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories, "wood-processing-or-assembling")
table.insert(data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories, "wood-processing-or-assembling")
table.insert(data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories, "wood-processing-or-assembling")

-- Atom forge

local AtomForgeFactory = require(MF.buildings .. "AtomForge")
local AtomForge = AtomForgeFactory()

AtomForge.EntityBuilder:new()
    :burnerEnergySource({
        fuel_categories = nil, -- Remove default before adding new
        emissions_per_minute = { pollution = nil }
    })
    :allowProductivity(true)
    :apply({
        crafting_categories = mfUtil.filter(
            data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories,
            { "crafting-with-fluid", "electronics-with-fluid", "crafting-with-fluid-or-metallurgy" }
        ),
        crafting_speed = 8,
        energy_usage = "4MW",
        energy_source = {
            fuel_categories = { "nuclear", "fusion" }
        }
    })

AtomForge.ItemBuilder:new():apply()

AtomForge.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

AtomForge.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()

-- Advanced foundry

local AdvancedFoundryFactory = require(MF.buildings .. "AdvancedFoundry")
local AdvancedFoundry = AdvancedFoundryFactory()

AdvancedFoundry.EntityBuilder:new()
    :baseProductivity(0.5)
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["foundry"].crafting_categories),
        crafting_speed = 8,
        energy_usage = "4MW"
    })

AdvancedFoundry.ItemBuilder:new():apply()

AdvancedFoundry.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply({
        category = "metallurgy-or-assembling"
    })

AdvancedFoundry.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()

-- Gravity assembler

local GravityAssemblerFactory = require(MF.buildings .. "GravityAssembler")
local GravityAssembler = GravityAssemblerFactory()

GravityAssembler.EntityBuilder:new()
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories)
    })

GravityAssembler.ItemBuilder:new():apply()

GravityAssembler.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

GravityAssembler.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()