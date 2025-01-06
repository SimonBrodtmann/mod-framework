local meld = require("meld")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local simulations = require("__base__.prototypes.factoriopedia-simulations")
local ImageFactory = require(MF.lib .. "ImageFactory")
local Builder = require(MF.lib .. "Builder")
local ItemBuilder = require(MF.lib .. "ItemBuilder")
local RecipeBuilder = require(MF.lib .. "RecipeBuilder")
local TechnologyBuilder = require(MF.lib .. "TechnologyBuilder")

local img = ImageFactory("logistics-graphics", "1", "/belts/")

local function createSlowAnimation(color)
    return meld({
        animation_set = {
            filename = img(color .. "/transport-belt-slow.png"),
            priority = "extra-high",
            size = 128,
            scale = 0.5,
            frame_count = 16,
            direction_count = 20
        }
    }, belt_reader_gfx)
end

local function createMediumAnimation(color)
    return meld({
        animation_set = {
            filename = img(color .. "/transport-belt-medium.png"),
            priority = "extra-high",
            size = 128,
            scale = 0.5,
            frame_count = 32,
            direction_count = 20
        }
    }, belt_reader_gfx)
end

local function createFastAnimation(color)
    return meld({
        alternate = true,
        animation_set = {
            filename = img(color .. "/transport-belt-fast.png"),
            priority = "extra-high",
            size = 128,
            scale = 0.5,
            frame_count = 64,
            direction_count = 20
        }
    }, belt_reader_gfx)
end

--- Belt entity builder class
--- @class BeltEntityBuilder : Builder
local BeltEntityBuilder = Builder:new({
    _nextTier = nil,
    _previousTier = nil,
    _speed = 0.03125,
    _undergroundDistance = 5,
    _animationSpeedCoefficient = 1,

    --- Sets the items per second that this belt can transport.
    --- The items per second are converted to the speed value that the game expects.
    --- @param itemsPerSecond number The amount of items per second.
    --- @return BeltEntityBuilder
    itemsPerSecond = function(self, itemsPerSecond)
        self._speed = itemsPerSecond / 480
        return self
    end,

    --- Sets the next tier of this belt. This is supposed to be the prefix of the technical name (e.g. "fast" for "fast-transport-belt" and "" for "transport-belt").
    --- When the code is generated, `next_upgrade` is set to the next tier for all three entities.
    --- @param nextTier string The prefix of the technical name of the next tier ("" for yellow "transport-belt")
    --- @return BeltEntityBuilder
    nextTier = function(self, nextTier)
        self._nextTier = nextTier
        return self
    end,

    --- Sets the previous tier of this belt. This is supposed to be the prefix of the technical name (e.g. "fast" for "fast-transport-belt" and "" for "transport-belt").
    --- When the code is generated, `next_upgrade` is set to this tier for all three entities defined by `previousTier`.
    --- @param previousTier string The prefix of the technical name of the previous tier ("" for yellow "transport-belt")
    --- @return BeltEntityBuilder
    previousTier = function(self, previousTier)
        self._previousTier = previousTier
        return self
    end,

    --- Sets the distance that the underground belt can span.
    --- @param distance number The distance in tiles that the underground belt can span (vanilla uses 5, 7, 9 and 11)
    --- @return BeltEntityBuilder
    undergroundDistance = function(self, distance)
        self._undergroundDistance = distance
        return self
    end,

    --- Sets `animation_speed_coefficient` for the belt entities. This can be used when it looks like the belt is moving backwards or not at all.
    --- @param multiplier number The multiplier for the default `animation_speed_coefficient` value of 32 (dfault is 1)
    --- @return BeltEntityBuilder
    animationSpeedMultiplier = function(self, multiplier)
        self._animationSpeedCoefficient = 32 * multiplier
        return self
    end,

    --- Builds the belt entities. Different to the default build function, it returns a table with all the generated entities.
    --- Used keys: `transportBelt`, `beltRemnants`, `undergroundBelt`, `undergroundBeltRemnants`, `splitter`, `splitterRemnants`.
    --- @param overrides table Additional or overriding properties for the entities (don't forget to include a top level table with the entities)
    build = function(self, overrides)
        local transportBeltName = self.name .. "-transport-belt"
        local undergroundBeltName = self.name .. "-underground-belt"
        local splitterName = self.name .. "-splitter"
        local result = {
            transportBelt = {
                type = "transport-belt",
                name = transportBeltName,
                icon = img(self.color .. "/transport-belt-icon.png"),
                flags = { "placeable-neutral", "player-creation" },
                minable = { mining_time = 0.1, result = transportBeltName },
                max_health = 150,
                corpse = transportBeltName .. "-remnants",
                dying_explosion = "transport-belt-explosion",
                resistances = {
                    {
                        type = "fire",
                        percent = 90
                    }
                },
                collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
                selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                damaged_trigger_effect = hit_effects.entity(),
                open_sound = sounds.transport_belt_open,
                close_sound = sounds.transport_belt_close,
                working_sound = {
                    sound = { filename = "__base__/sound/transport-belt.ogg", volume = 0.17 },
                    persistent = true
                },
                animation_speed_coefficient = self._animationSpeedCoefficient,
                fast_replaceable_group = "transport-belt",
                related_underground_belt = undergroundBeltName,
                speed = self._speed,
                connector_frame_sprites = transport_belt_connector_frame_sprites,
                circuit_connector = circuit_connector_definitions["belt"],
                circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
            },
            beltRemnants = {
                type = "corpse",
                name = transportBeltName .. "-remnants",
                icon = img(self.color .. "/transport-belt-icon.png"),
                hidden_in_factoriopedia = true,
                flags = { "placeable-neutral", "not-on-map" },
                subgroup = "belt-remnants",
                order = "a-a-a",
                selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                tile_width = 1,
                tile_height = 1,
                selectable_in_game = false,
                time_before_removed = 60 * 60 * 15, -- 15 minutes
                expires = false,
                final_render_layer = "remnants",
                animation = make_rotated_animation_variations_from_sheet(2, {
                    filename = img(self.color .. "/transport-belt-remnants.png"),
                    line_length = 1,
                    width = 106,
                    height = 102,
                    direction_count = 4,
                    shift = util.by_pixel(1, -0.5),
                    scale = 0.5
                })
            },
            undergroundBelt = {
                type = "underground-belt",
                name = undergroundBeltName,
                icon = img(self.color .. "/underground-belt-icon.png"),
                flags = { "placeable-neutral", "player-creation" },
                minable = { mining_time = 0.1, result = undergroundBeltName },
                max_health = 150,
                corpse = undergroundBeltName .. "-remnants",
                dying_explosion = "underground-belt-explosion",
                factoriopedia_simulation = simulations.factoriopedia_underground_belt,
                max_distance = self._undergroundDistance,
                open_sound = sounds.machine_open,
                close_sound = sounds.machine_close,
                working_sound = table.deepcopy(data.raw["underground-belt"]["underground-belt"].working_sound),
                underground_sprite = table.deepcopy(data.raw["underground-belt"]["underground-belt"].underground_sprite),
                resistances = {
                    {
                        type = "fire",
                        percent = 60
                    },
                    {
                        type = "impact",
                        percent = 30
                    }
                },
                collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
                selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                damaged_trigger_effect = hit_effects.entity(),
                animation_speed_coefficient = self._animationSpeedCoefficient,
                fast_replaceable_group = "transport-belt",
                speed = self._speed,
                structure = {
                    direction_in = {
                        sheet = {
                            filename = img(self.color .. "/underground-belt-structure.png"),
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            y = 192,
                            scale = 0.5
                        }
                    },
                    direction_out = {
                        sheet = {
                            filename = img(self.color .. "/underground-belt-structure.png"),
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            scale = 0.5
                        }
                    },
                    direction_in_side_loading = {
                        sheet = {
                            filename = img(self.color .. "/underground-belt-structure.png"),
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            y = 192 * 3,
                            scale = 0.5
                        }
                    },
                    direction_out_side_loading = {
                        sheet = {
                            filename = img(self.color .. "/underground-belt-structure.png"),
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            y = 192 * 2,
                            scale = 0.5
                        }
                    },
                    back_patch = {
                        sheet = {
                            filename =
                            "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            scale = 0.5
                        }
                    },
                    front_patch = {
                        sheet = {
                            filename =
                            "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
                            priority = "extra-high",
                            width = 192,
                            height = 192,
                            scale = 0.5
                        }
                    }
                }
            },
            undergroundBeltRemnants = {
                type = "corpse",
                name = undergroundBeltName .. "-remnants",
                icon = img(self.color .. "/underground-belt-icon.png"),
                hidden_in_factoriopedia = true,
                flags = { "placeable-neutral", "not-on-map", "building-direction-8-way" },
                subgroup = "belt-remnants",
                order = "a-d-a",
                selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                tile_width = 1,
                tile_height = 1,
                selectable_in_game = false,
                time_before_removed = 60 * 60 * 15, -- 15 minutes
                expires = false,
                final_render_layer = "remnants",
                remove_on_tile_placement = false,
                animation = {
                    filename = img(self.color .. "/underground-belt-remnants.png"),
                    line_length = 1,
                    width = 156,
                    height = 144,
                    direction_count = 8,
                    shift = util.by_pixel(10.5, 3),
                    scale = 0.5
                }
            },
            splitter = {
                type = "splitter",
                name = splitterName,
                icon = img(self.color .. "/splitter-icon.png"),
                flags = { "placeable-neutral", "player-creation" },
                minable = { mining_time = 0.1, result = splitterName },
                max_health = 170,
                corpse = splitterName .. "-remnants",
                dying_explosion = "splitter-explosion",
                resistances = {
                    {
                        type = "fire",
                        percent = 60
                    }
                },
                collision_box = { { -0.9, -0.4 }, { 0.9, 0.4 } },
                selection_box = { { -0.9, -0.5 }, { 0.9, 0.5 } },
                damaged_trigger_effect = hit_effects.entity(),
                animation_speed_coefficient = self._animationSpeedCoefficient,
                structure_animation_speed_coefficient = 0.7,
                structure_animation_movement_cooldown = 10,
                icon_draw_specification = { scale = 0.5 },
                fast_replaceable_group = "transport-belt",
                speed = self._speed,
                open_sound = sounds.machine_open,
                close_sound = sounds.machine_close,
                working_sound = sounds.splitter,
                related_transport_belt = transportBeltName,
                structure = {
                    north = {
                        filename = img(self.color .. "/splitter-north.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 160,
                        height = 70,
                        shift = util.by_pixel(7, 0),
                        scale = 0.5
                    },
                    east = {
                        filename = img(self.color .. "/splitter-east.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 90,
                        height = 84,
                        shift = util.by_pixel(4, 13),
                        scale = 0.5
                    },
                    south = {
                        filename = img(self.color .. "/splitter-south.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 164,
                        height = 64,
                        shift = util.by_pixel(4, 0),
                        scale = 0.5
                    },
                    west = {
                        filename = img(self.color .. "/splitter-west.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 90,
                        height = 86,
                        shift = util.by_pixel(6, 12),
                        scale = 0.5
                    }
                },
                structure_patch = {
                    north = util.empty_sprite(),
                    east = {
                        filename = img(self.color .. "/splitter-east-top_patch.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 90,
                        height = 104,
                        shift = util.by_pixel(4, -20),
                        scale = 0.5
                    },
                    south = util.empty_sprite(),
                    west = {
                        filename = img(self.color .. "/splitter-west-top_patch.png"),
                        frame_count = 32,
                        line_length = 8,
                        priority = "extra-high",
                        width = 90,
                        height = 96,
                        shift = util.by_pixel(6, -18),
                        scale = 0.5
                    }
                }
            },
            splitterRemnants = {
                type = "corpse",
                name = splitterName .. "-remnants",
                icon = img(self.color .. "/splitter-icon.png"),
                hidden_in_factoriopedia = true,
                flags = { "placeable-neutral", "not-on-map" },
                subgroup = "belt-remnants",
                order = "a-g-a",
                selection_box = { { -0.9, -0.5 }, { 0.9, 0.5 } },
                tile_width = 2,
                tile_height = 1,
                selectable_in_game = false,
                time_before_removed = 60 * 60 * 15, -- 15 minutes
                expires = false,
                final_render_layer = "remnants",
                remove_on_tile_placement = false,
                animation = {
                    filename = img(self.color .. "/splitter-remnants.png"),
                    line_length = 1,
                    width = 190,
                    height = 190,
                    direction_count = 4,
                    shift = util.by_pixel(3.5, 1.5),
                    scale = 0.5
                }
            }
        }

        if self.speed == "slow" then
            result.transportBelt.belt_animation_set = createSlowAnimation(self.color)
            result.undergroundBelt.belt_animation_set = createSlowAnimation(self.color)
            result.splitter.belt_animation_set = createSlowAnimation(self.color)
        end
        if self.speed == "medium" then
            result.transportBelt.belt_animation_set = createMediumAnimation(self.color)
            result.undergroundBelt.belt_animation_set = createMediumAnimation(self.color)
            result.splitter.belt_animation_set = createMediumAnimation(self.color)
        end
        if self.speed == "fast" then
            result.transportBelt.belt_animation_set = createFastAnimation(self.color)
            result.undergroundBelt.belt_animation_set = createFastAnimation(self.color)
            result.splitter.belt_animation_set = createFastAnimation(self.color)
        end

        if self._nextTier ~= nil then
            if self._nextTier == "" then
                result.transportBelt.next_upgrade = "transport-belt"
                result.undergroundBelt.next_upgrade = "underground-belt"
                result.splitter.next_upgrade = "splitter"
            else
                result.transportBelt.next_upgrade = self._nextTier .. "-transport-belt"
                result.undergroundBelt.next_upgrade = self._nextTier .. "-underground-belt"
                result.splitter.next_upgrade = self._nextTier .. "-splitter"
            end
        end

        if self._previousTier ~= nil then
            if self._previousTier == "" then
                data.raw["transport-belt"]["transport-belt"].next_upgrade = self.name .. "-transport-belt"
                data.raw["underground-belt"]["underground-belt"].next_upgrade = self.name .. "-underground-belt"
                data.raw["splitter"]["splitter"].next_upgrade = self.name .. "-splitter"
            else
                data.raw["transport-belt"][self._previousTier .. "-transport-belt"].next_upgrade = self.name ..
                    "-transport-belt"
                data.raw["underground-belt"][self._previousTier .. "-underground-belt"].next_upgrade = self.name ..
                    "-underground-belt"
                data.raw["splitter"][self._previousTier .. "-splitter"].next_upgrade = self.name .. "-splitter"
            end
        end

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end,

    apply = function(self, overrides)
        local result = self:build(overrides)
        for _, entry in pairs(result) do
            data:extend({ entry })
        end
        return result
    end
})

--- Belt item builder class
--- @class BeltItemBuilder : ItemBuilder
local BeltItemBuilder = ItemBuilder:new({
    _weight = {
        transportBelt = 20 * kg,
        undergroundBelt = 40 * kg,
        splitter = 40 * kg
    },

    --- Sets the weight of the item calculated from given count per rocket.
    --- This is different from the base function as it handles separate values for each entity.
    --- See the `build` function for the used keys.
    --- @param item string The item to set the weight for
    --- @param count number The amount of items that fit into a rocket
    --- @return ItemBuilder
    itemsPerRocket = function(self, item, count)
        self._weight[item] = (1000 / count) * kg
        return self
    end,

    --- Builds the belt items. Different to the default build function, it returns a table with all the generated items.
    --- Used keys: `transportBelt`, `undergroundBelt`, `splitter`.
    --- @param overrides table Additional or overriding properties for the items (don't forget to include a top level table with the items)
    build = function(self, overrides)
        local transportBeltName = self.name .. "-transport-belt"
        local undergroundBeltName = self.name .. "-underground-belt"
        local splitterName = self.name .. "-splitter"
        local result = {
            transportBelt = {
                type = "item",
                name = transportBeltName,
                icon = img(self.color .. "/transport-belt-icon.png"),
                subgroup = "belt",
                color_hint = { text = "1" },
                order = "a[transport-belt]-" .. self._order .. "[" .. transportBeltName .. "]",
                inventory_move_sound = item_sounds.transport_belt_inventory_move,
                pick_sound = item_sounds.transport_belt_inventory_pickup,
                drop_sound = item_sounds.transport_belt_inventory_move,
                place_result = transportBeltName,
                stack_size = 100,
                weight = self._weight["transportBelt"]
            },
            undergroundBelt = {
                type = "item",
                name = undergroundBeltName,
                icon = img(self.color .. "/underground-belt-icon.png"),
                subgroup = "belt",
                color_hint = { text = "1" },
                order = "b[underground-belt]-" .. self._order .. "[" .. undergroundBeltName .. "]",
                inventory_move_sound = item_sounds.mechanical_inventory_move,
                pick_sound = item_sounds.mechanical_inventory_pickup,
                drop_sound = item_sounds.mechanical_inventory_move,
                place_result = undergroundBeltName,
                stack_size = 50,
                weight = self._weight["undergroundBelt"]
            },
            splitter = {
                type = "item",
                name = splitterName,
                icon = img(self.color .. "/splitter-icon.png"),
                subgroup = "belt",
                color_hint = { text = "1" },
                order = "c[splitter]-" .. self._order .. "[" .. splitterName .. "]",
                inventory_move_sound = item_sounds.mechanical_inventory_move,
                pick_sound = item_sounds.mechanical_inventory_pickup,
                drop_sound = item_sounds.mechanical_inventory_move,
                place_result = splitterName,
                stack_size = 50,
                weight = self._weight["splitter"]
            }
        }

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end,

    apply = function(self, overrides)
        local result = self:build(overrides)
        for _, entry in pairs(result) do
            data:extend({ entry })
        end
        return result
    end
})

--- Belt recipe builder class
--- @class BeltRecipeBuilder : RecipeBuilder
local BeltRecipeBuilder = RecipeBuilder:new({
    _ingredients = {
        transportBelt = {},
        undergroundBelt = {},
        splitter = {}
    },
    _enabled = false,
    _beltAmount = 1,

    --- Sets the ingredients of a recipe.
    --- This is different from the base function as it handles separate values for each recipe.
    --- See the `build` function for the used keys.
    --- @param recipe string The recipe to set the weight for
    --- @param ingredients table The ingredients for the recipe
    --- @return RecipeBuilder
    ingredients = function(self, recipe, ingredients)
        self._ingredients[recipe] = ingredients
        return self
    end,

    --- Enables the recipes. Per default they are disabled and to be unlocked by a technology.
    --- If you use this, you probably don't want to use the TechnologyBuilder.
    --- @return RecipeBuilder
    enabled = function(self)
        self._enabled = true
        return self
    end,

    --- Defines the amount of belts that are produced by the belt recipe.
    --- Since the vanilla recipe for the yelllow belt produces 2 belts and other tier recipes produce just 1 belt, this could be useful if you don't want the default of 1.
    --- @param amount number The amount of belts that are produced by the recipe (default: 1)
    --- @return RecipeBuilder
    beltAmount = function(self, amount)
        self._beltAmount = amount
        return self
    end,

    --- Builds the belt recipes. Different to the default build function, it returns a table with all the generated recipes.
    --- Used keys: `transportBelt`, `undergroundBelt`, `splitter`.
    --- @param overrides table Additional or overriding properties for the recipes (don't forget to include a top level table with the recipes)
    build = function(self, overrides)
        local transportBeltName = self.name .. "-transport-belt"
        local undergroundBeltName = self.name .. "-underground-belt"
        local splitterName = self.name .. "-splitter"
        local result = {
            transportBelt = {
                type = "recipe",
                name = transportBeltName,
                enabled = self._enabled,
                energy_required = 0.5,
                results = { { type = "item", name = transportBeltName, amount = self._beltAmount } },
                ingredients = self._ingredients["transportBelt"],
                surface_conditions = self._surfaceConditions
            },
            undergroundBelt = {
                type = "recipe",
                name = undergroundBeltName,
                enabled = self._enabled,
                energy_required = 1,
                ingredients = self._ingredients["undergroundBelt"],
                results = { { type = "item", name = undergroundBeltName, amount = 2 } },
                surface_conditions = self._surfaceConditions
            },
            splitter = {
                type = "recipe",
                name = splitterName,
                enabled = self._enabled,
                energy_required = 1,
                ingredients = self._ingredients["splitter"],
                results = { { type = "item", name = splitterName, amount = 1 } },
                surface_conditions = self._surfaceConditions
            }
        }

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end,

    apply = function(self, overrides)
        local result = self:build(overrides)
        for _, entry in pairs(result) do
            data:extend({ entry })
        end
        return result
    end
})

--- Belt technology builder class
--- @class BeltTechnologyBuilder : TechnologyBuilder
local BeltTechnologyBuilder = TechnologyBuilder:new({
    new = function(self, o)
        o = o or {}
        if o.color and o._effects == nil then
            o._icon = img(o.color .. "/logistics-technology.png")
        end
        if o.name and o._effects == nil then
            o._effects = {
                {
                    type = "unlock-recipe",
                    recipe = o.name .. "-transport-belt"
                },
                {
                    type = "unlock-recipe",
                    recipe = o.name .. "-underground-belt"
                },
                {
                    type = "unlock-recipe",
                    recipe = o.name .. "-splitter"
                }
            }
        end
        setmetatable(o, self)
        self.__index = self
        return o
    end,

    --- Builds one technology that unlocks all the recipes.
    --- @param overrides table Additional or overriding properties for the technology
    build = function(self, overrides)
        local result = {
            type = "technology",
            name = self.name .. "-logistics",
            icon = self._icon,
            icon_size = self._iconSize,
            effects = self._effects,
            prerequisites = self._prerequisites,
            unit = self._unit
        }

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Belt factory function.
--- The color maps to a folder name in the graphics folder.
--- The speed maps to a speed category that vanilla provides.
--- "slow" uses recolored graphics from yellow belts. "medium" uses red/blue belts and "fast" uses green belts.
--- @param name string The technical name prefix of this belt instance (e.g. "fast" results into "fast-transport-belt")
--- @param color string The color of this belt instance (available color graphics: "black", "brown", "purple", "white")
--- @param speed string The speed category of the belt graphics to be used (available speeds: "slow", "medium", "fast")
return function(name, color, speed)
    return {
        EntityBuilder = BeltEntityBuilder:new({ name = name, color = color, speed = speed }),
        ItemBuilder = BeltItemBuilder:new({ name = name, color = color }),
        RecipeBuilder = BeltRecipeBuilder:new({ name = name }),
        TechnologyBuilder = BeltTechnologyBuilder:new({ name = name, color = color })
    }
end
