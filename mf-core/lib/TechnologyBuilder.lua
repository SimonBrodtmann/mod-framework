local Builder = require("Builder")

local TechnologyBuilder = Builder:new({
    _icon = nil,
    _iconSize = 256,
    _effects = nil,
    _prerequisites = {},
    _unit = {
        count = 500,
        ingredients = {},
        time = 30
    }
})

function TechnologyBuilder:new(o)
    o = o or {}
    if o.name and o._effects == nil then
        o._effects = {
            {
                type = "unlock-recipe",
                recipe = o.name
            }
        }
    end
    setmetatable(o, self)
    self.__index = self
    return o
end

function TechnologyBuilder:icon(path, size)
    self._icon = path
    if (size) then
        self._iconSize = size
    end
    return self
end

function TechnologyBuilder:additionalRecipes(recipes)
    for _, recipe in pairs(recipes) do
        table.insert(self._effects, { type = "unlock-recipe", recipe = recipe })
    end
    return self
end

function TechnologyBuilder:additionalEffects(effects)
    util.merge({ self._effects, effects })
    return self
end

function TechnologyBuilder:prerequisites(prerequisites)
    self._prerequisites = prerequisites
    return self
end

function TechnologyBuilder:count(count)
    self._unit.count = count
    return self
end

function TechnologyBuilder:ingredients(ingredients)
    self._unit.ingredients = ingredients
    return self
end

function TechnologyBuilder:time(time)
    self._unit.time = time
    return self
end

return TechnologyBuilder