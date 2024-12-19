--- Generic recipe builder class.
--- @class RecipeBuilder : Builder

local Builder = require("Builder")

local RecipeBuilder = Builder:new({
    _ingredients = {},
    _surfaceConditions = nil
})

--- Sets the ingredients of the recipe.
--- @param ingredients table The ingredients of the recipe
--- @return RecipeBuilder
function RecipeBuilder:ingredients(ingredients)
    self._ingredients = ingredients
    return self
end

--- Sets the surface conditions of the recipe.
--- @param surfaceConditions table The surface conditions of the recipe
--- @return RecipeBuilder
function RecipeBuilder:surfaceConditions(surfaceConditions)
    self._surfaceConditions = surfaceConditions
    return self
end

return RecipeBuilder