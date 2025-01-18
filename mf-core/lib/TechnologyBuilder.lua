--- Generic technology builder class.
--- @class TechnologyBuilder : Builder

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

--- Constructor.
--- If a name is provided, the technology will unlock the recipe with the same name.
function TechnologyBuilder:new(o)
    self = table.deepcopy(self)
    o = o or {}
    o = table.deepcopy(o)
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

--- Sets the technology icon.
--- @param path string The path to the icon
--- @param size ?number The size of the icon
--- @return TechnologyBuilder
function TechnologyBuilder:icon(path, size)
    self._icon = path
    if (size) then
        self._iconSize = size
    end
    return self
end

--- Sets additional recipes that should be unlocked by the technology.
--- @param recipes table The recipes that should be unlocked
--- @return TechnologyBuilder
function TechnologyBuilder:additionalRecipes(recipes)
    for _, recipe in pairs(recipes) do
        table.insert(self._effects, { type = "unlock-recipe", recipe = recipe })
    end
    return self
end

--- Sets additional effects that should be applied by the technology.
--- @param effects table The effects that should be applied
--- @return TechnologyBuilder
function TechnologyBuilder:additionalEffects(effects)
    util.merge({ self._effects, effects })
    return self
end

--- Sets the prerequisites of the technology.
--- @param prerequisites table The prerequisites of the technology
--- @return TechnologyBuilder
function TechnologyBuilder:prerequisites(prerequisites)
    self._prerequisites = prerequisites
    return self
end

--- Sets the unit count of the technology.
--- @param count number The unit count of the technology
--- @return TechnologyBuilder
function TechnologyBuilder:count(count)
    self._unit.count = count
    return self
end

--- Sets the unit ingredients of the technology.
--- @param ingredients table The unit ingredients of the technology
--- @return TechnologyBuilder
function TechnologyBuilder:ingredients(ingredients)
    self._unit.ingredients = ingredients
    return self
end

--- Sets the unit time of the technology.
--- @param time number The unit time of the technology
--- @return TechnologyBuilder
function TechnologyBuilder:time(time)
    self._unit.time = time
    return self
end

return TechnologyBuilder