<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/gravity-assembler/gravity-assembler-icon.png">Gravity assembler</mf-entity-summary>

![Preview](gravity-assembler/gravity-assembler-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"gravity-assembler"</td>
    </tr>
    <tr>
        <th>Default type</th>
        <td>"assembling-machine"</td>
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
local GravityAssemblerFactory = require(MF.buildings .. "GravityAssembler")
local GravityAssembler = GravityAssemblerFactory()

GravityAssembler.EntityBuilder:new():apply()

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
```

### Usage example

```lua
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
```

</details>