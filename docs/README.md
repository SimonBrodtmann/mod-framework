# Mod Framework

This framework provides barebone pieces for Factorio with an easy to use API. Builders, customizing options and the
ability to apply your own adjustments easily, enable you to rapidly develop cool mods without spending too much time
finding the right graphics and the code for them for your ideas.

## Usage

As a modder, you don't need to use code from `mf-core` or one of the graphics mods directly. You will mainly be
interested
in the mods that actually provide entities.

All files are well-documented with LDoc comments. In doubt, look at them before you start reading the code.

All mods use the Builder classes defined in `mf-core` and provide a factory function to create all the builder instances
needed to add everything related to one specific entity. The builders generate regular prototype data that can directly
be applied using the builder function `apply` or you only generate the code using `build` and do more things with it
before manually calling `data:extend`.

Many functions accept a table containing overrides. That table will be applied to the generated result using
`util.merge` or `meld` from the Factorio core lualib utils. Both do a deep merge. This saves you from needing to apply
additional changes in the end.

The builders have some convenience function to make things easier, but they cannot cover all use cases. In the end you
will often apply some of the properties using the overrides.

The following three examples all generate the same code for the lumber mill. They show you the different ways how this
framework can be used:

```lua
LumberMill.TechnologyBuilder:new()
    :prerequisites({ "wood-science-pack" })
    :ingredients({{ "wood-science-pack", 1 }})
    :count(500)
    :time(60)
    :apply()
```

```lua
LumberMill.TechnologyBuilder:new()
    :prerequisites({ "wood-science-pack" })
    :apply({
        unit = {
            count = 500,
            ingredients = {{ "wood-science-pack", 1 }},
            time = 60
        }
    })
```

```lua
local lumberMillTech = LumberMill.TechnologyBuilder:new():build()
lumberMillTech.prerequisites = { "wood-science-pack" }
lumberMillTech.unit = {
    count = 500,
    ingredients = {{ "wood-science-pack", 1 }},
    time = 60
}
data:extend({ lumberMillTech  })
```

The following example generates a very fast purple belt with 90 items/s, It generates the belts, the undergrounds and
the splitter including remnants for each all in one step.

```lua
local BeltFactory = require(MF.logistics .. "Belts")
local Belt = BeltFactory("ludicrous-speed", "purple", "fast")

Belt.EntityBuilder:new()
    :itemsPerSecond(90)
    :previousTier("turbo")
    :undergroundDistance(15)
    :animationSpeedMultiplier(0.9)
    :apply()

Belt.ItemBuilder:new():apply()

Belt.RecipeBuilder:new()
    :ingredients("transportBelt", {
        { type = "item", name = "lumber", amount = 1 }
    })
    :ingredients("undergroundBelt", {
        { type = "item", name = "lumber", amount = 2 }
    })
    :ingredients("splitter", {
        { type = "item", name = "lumber", amount = 3 }
    })
    :apply()

Belt.TechnologyBuilder:new()
    :prerequisites({ "wood-science-pack" })
    :ingredients({{ "wood-science-pack", 1 }})
    :apply()
```

`:previousTier("turbo")` also sets the `next_upgrade` on the turbo belt for all three entities. As there are three
entities, the builders have been changed a bit to hold tables for all the entities. Some of the functions then need to
be called for each entity (e.g. `:ingredients` in the `RecipeBuilder`).