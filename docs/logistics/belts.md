<details class="mf-entity-entry">
<mf-entity-summary icon="logistics/belts-icon.png">Belts</mf-entity-summary>

![Preview](belts-icon.png)

<table>
    <tr>
        <th>Default names</th>
        <td>"transport-belt", "underground-belt", "splitter", "logistics"</td>
    </tr>
    <tr>
        <th>Frozen graphics</th>
        <td>no</td>
    </tr>
    <tr>
        <th>Sounds</th>
        <td>yes (vanilla)</td>
    </tr>
    <tr>
        <th>Credits</th>
        <td>Wube (original) / cackling fiend (recolors)</td>
    </tr>
    <tr>
        <th>License</th>
        <td><a href="https://factorio.com/terms-of-service" target="_blank">Factorio Terms of Service</a> / <a href="https://www.gnu.org/licenses/gpl-3.0.html" target="_blank">GPL 3.0</a></td>
    </tr>
    <tr>
        <th>API</th>
        <td><a href="https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-logistics/code/Belts.lua" target="_blank">/mf-logistics/code/Belts.lua</a></td>
    </tr>
</table>

### Minimal example

```lua
local BeltFactory = require(MF.logistics .. "Belts")
local Belt = BeltFactory("slow", "white", "slow")

Belt.EntityBuilder:new()
    :itemsPerSecond(7.5)
    :nextTier("")
    :undergroundDistance(4)
    :apply()

Belt.ItemBuilder:new():apply()

Belt.RecipeBuilder:new()
    :ingredients("transportBelt", {})
    :ingredients("undergroundBelt", {})
    :ingredients("splitter", {})
    :apply()

Belt.TechnologyBuilder:new()
    :prerequisites({ "automation-science-pack" })
    :ingredients({ { "automation-science-pack", 1 } })
    :count(500)
    :time(60)
    :apply()
```

### Usage example

```lua
local BeltFactory = require(MF.logistics .. "Belts")
local Belt = BeltFactory("turtle-speed", "white", "slow")

Belt.EntityBuilder:new()
    :itemsPerSecond(2.5)
    :nextTier("wood")
    :undergroundDistance(2)
    :animationSpeedMultiplier(1.01)
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

</details>