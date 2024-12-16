local Builder = require("Builder")

local DEFAULT_ELECTRIC_POLLUTION = nil
local DEFAULT_BURNER_POLLUTION = 10
local DEFAULT_FUEL_INVENTORY_SIZE = 3

local function createDefaultEnergySource()
    return {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = DEFAULT_ELECTRIC_POLLUTION and { pollution = DEFAULT_ELECTRIC_POLLUTION } or nil
    }
end

local EntityBuilder = Builder:new({
    _energySource = createDefaultEnergySource(),
    _baseProductivity = nil,
    _allowProductivity = true
})

function EntityBuilder:electricEnergySource(overrides)
    if (overrides) then
        self._energySource = util.merge({ createDefaultEnergySource(), overrides })
    else
        self._energySource = createDefaultEnergySource()
    end
    return self
end

function EntityBuilder:burnerEnergySource(overrides)
    local defaultBurnerEnergySource = {
        type = "burner",
        fuel_categories = { "chemical" },
        effectivity = 1,
        fuel_inventory_size = DEFAULT_FUEL_INVENTORY_SIZE,
        emissions_per_minute = { pollution = DEFAULT_BURNER_POLLUTION }
    }
    if (overrides) then
        self._energySource = util.merge({ defaultBurnerEnergySource, overrides })
    else
        self._energySource = defaultBurnerEnergySource
    end
    return self
end

function EntityBuilder:baseProductivity(productivity)
    self._baseProductivity = productivity
    return self
end

function EntityBuilder:allowProductivity(allowProductivity)
    self._allowProductivity = allowProductivity
    return self
end

return EntityBuilder
