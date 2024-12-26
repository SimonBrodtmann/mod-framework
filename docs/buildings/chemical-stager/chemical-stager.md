<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/chemical-stager/chemical-stager-icon.png">Chemical stager</mf-entity-summary>

![Preview](chemical-stager/chemical-stager-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"chemical-stager"</td>
    </tr>
    <tr>
        <th>Default type</th>
        <td>"assembling-machine"</td>
    </tr>
    <tr>
        <th>Size</th>
        <td>6x6</td>
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
    <tr>
        <th>API</th>
        <td><a href="https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-buildings/code/ChemicalStager.lua" target="_blank">/mf-buildings/code/ChemicalStager.lua</a></td>
    </tr>
</table>

### Minimal example

```lua
local ChemicalStagerFactory = require(MF.buildings .. "ChemicalStager")
local ChemicalStager = ChemicalStagerFactory()

ChemicalStager.EntityBuilder:new():apply()

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
```

### Usage example

```lua
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
```

</details>