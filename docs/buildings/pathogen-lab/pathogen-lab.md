<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/pathogen-lab/pathogen-lab-icon.png">Pathogen lab</mf-entity-summary>

![Preview](pathogen-lab/pathogen-lab-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"pathogen-lab"</td>
    </tr>
    <tr>
        <th>Default type</th>
        <td>"assembling-machine"</td>
    </tr>
    <tr>
        <th>Size</th>
        <td>7x7</td>
    </tr>
    <tr>
        <th>Frozen graphics</th>
        <td>yes</td>
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
        <td><a href="https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-buildings/code/PathogenLab.lua" target="_blank">/mf-buildings/code/PathogenLab.lua</a></td>
    </tr>
</table>

### Minimal example

```lua
local PathogenLabFactory = require(MF.buildings .. "PathogenLab")
local PathogenLab = PathogenLabFactory()

PathogenLab.EntityBuilder:new():apply()

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
```

### Usage example

```lua
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
```

</details>