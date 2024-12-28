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
    :pipes()
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
    :pipes()
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
    
-- Arc furnace
    
local ArcFurnaceFactory = require(MF.buildings .. "ArcFurnace")
local ArcFurnace = ArcFurnaceFactory()

ArcFurnace.EntityBuilder:new()
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["furnace"]["electric-furnace"].crafting_categories)
    })

ArcFurnace.ItemBuilder:new():apply()

ArcFurnace.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

ArcFurnace.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
    
-- Chemical stager
    
local ChemicalStagerFactory = require(MF.buildings .. "ChemicalStager")
local ChemicalStager = ChemicalStagerFactory()

ChemicalStager.EntityBuilder:new()
    :allowProductivity(true)
    :pipes()
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"].crafting_categories)
    })

ChemicalStager.ItemBuilder:new():apply()

ChemicalStager.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

ChemicalStager.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
    
-- Pathogen lab
    
local PathogenLabFactory = require(MF.buildings .. "PathogenLab")
local PathogenLab = PathogenLabFactory()

PathogenLab.EntityBuilder:new()
    :allowProductivity(true)
    :pipes()
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["biochamber"].crafting_categories)
    })

PathogenLab.ItemBuilder:new():apply()

PathogenLab.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

PathogenLab.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
    
-- Core extractor
    
local CoreExtractorFactory = require(MF.buildings .. "CoreExtractor")
local CoreExtractor = CoreExtractorFactory()

CoreExtractor.EntityBuilder:new():apply()

CoreExtractor.ItemBuilder:new():apply()

CoreExtractor.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

CoreExtractor.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
    
-- Fusion reactor
    
local FusionReactorFactory = require(MF.buildings .. "FusionReactor")
local FusionReactor = FusionReactorFactory("fusion-reactor-2")

FusionReactor.EntityBuilder:new()
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories)
    })

FusionReactor.ItemBuilder:new():apply()

FusionReactor.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

FusionReactor.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
    
-- Quantum stabilizer
        
local QuantumStabilizerFactory = require(MF.buildings .. "QuantumStabilizer")
local QuantumStabilizer = QuantumStabilizerFactory()

QuantumStabilizer.EntityBuilder:new()
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories)
    })

QuantumStabilizer.ItemBuilder:new():apply()

QuantumStabilizer.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

QuantumStabilizer.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()