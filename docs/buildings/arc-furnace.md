<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/arc-furnace-icon.png">Arc furnace</mf-entity-summary>

![Preview](arc-furnace-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"arc-furnace"</td>
    </tr>
    <tr>
        <th>Default type</th>
        <td>"furnace"</td>
    </tr>
    <tr>
        <th>Size</th>
        <td>5x5</td>
    </tr>
    <tr>
        <th>Frozen graphics</th>
        <td>no</td>
    </tr>
    <tr>
        <th>Sounds</th>
        <td>no</td>
    </tr>
    <tr>
        <th>Credits</th>
        <td><a href="https://www.figma.com/proto/y1IQG08ZG2jIeJ5sTyF4MP/Factorio-Buildings" target="_blank">Hurricane</a></td>
    </tr>
    <tr>
        <th>License</th>
        <td><a href="https://creativecommons.org/licenses/by/4.0/" target="_blank">CC BY</a></td>
    </tr>
</table>

### Minimal example

```lua
local ArcFurnaceFactory = require(MF.buildings .. "ArcFurnace")
local ArcFurnace = ArcFurnaceFactory()

ArcFurnace.EntityBuilder:new()
    :allowProductivity(true)
    :apply()

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
```

### Usage example

```lua
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
```

</details>