<details class="mf-entity-entry">
<mf-entity-summary icon="buildings/core-extractor/core-extractor-icon.png">Core extractor</mf-entity-summary>

![Preview](core-extractor/core-extractor-preview.png)

<table>
    <tr>
        <th>Default name</th>
        <td>"core-extractor"</td>
    </tr>
    <tr>
        <th>Default type</th>
        <td>"mining-drill"</td>
    </tr>
    <tr>
        <th>Size</th>
        <td>11x11</td>
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
local CoreExtractorFactory = require(MF.buildings .. "CoreExtractor")
local CoreExtractor = CoreExtractorFactory()

CoreExtractor.EntityBuilder:new():apply()

CoreExtractor.ItemBuilder:new():apply()

CoreExtractor.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

CoreExtractor.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
```

### Usage example

```lua
local CoreExtractorFactory = require(MF.buildings .. "CoreExtractor")
local CoreExtractor = CoreExtractorFactory()

CoreExtractor.EntityBuilder:new():apply()

CoreExtractor.ItemBuilder:new():apply()

CoreExtractor.RecipeBuilder:new()
    :ingredients({
        { type = "item", name = "iron-plate", amount = 100 }
    })
    :apply()

CoreExtractor.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :count(500)
    :ingredients({ { "automation-science-pack", 1 } })
    :time(60)
    :apply()
```

</details>