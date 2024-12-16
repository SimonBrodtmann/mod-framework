local Builder = require("Builder")

local RecipeBuilder = Builder:new({
    _ingredients = {}
})

function RecipeBuilder:ingredients(ingredients)
    self._ingredients = ingredients
    return self
end

return RecipeBuilder