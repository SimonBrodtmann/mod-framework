<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/quantum-stabilizer/quantum-stabilizer-icon.png">Quantum stabilizer</mf-entity-summary>

![Preview](quantum-stabilizer/quantum-stabilizer-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"quantum-stabilizer"</td>
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
        <td><a href="https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-buildings/code/QuantumStabilizer.lua" target="_blank">/mf-buildings/code/QuantumStabilizer.lua</a></td>
    </tr>
</table>

### Minimal example

```lua
local QuantumStabilizerFactory = require(MF.buildings .. "QuantumStabilizer")
local QuantumStabilizer = QuantumStabilizerFactory()

QuantumStabilizer.EntityBuilder:new():apply()

QuantumStabilizer.ItemBuilder:new():apply()

QuantumStabilizer.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

QuantumStabilizer.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
```

### Usage example

```lua
local QuantumStabilizerFactory = require(MF.buildings .. "QuantumStabilizer")
local QuantumStabilizer = QuantumStabilizerFactory()

QuantumStabilizer.EntityBuilder:new()
    :allowProductivity(true)
    :apply({
        crafting_categories = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories)
    })

QuantumStabilizer.ItemBuilder:new():apply()

QuantumStabilizer.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

QuantumStabilizer.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
```

</details>