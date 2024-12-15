local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")
local img = MF.ImageFactory("buildings-graphics", "1", "/lumber-mill/")

local DEFAULT_ELECTRIC_POLLUTION = nil
local DEFAULT_BURNER_POLLUTION = 10
local DEFAULT_FUEL_INVENTORY_SIZE = 3

local entityBuilder = function(name)
    local createDefaultEnergySource = function()
        return {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = DEFAULT_ELECTRIC_POLLUTION and { pollution = DEFAULT_ELECTRIC_POLLUTION } or nil
        }
    end

    local _energySource = createDefaultEnergySource()
    local _baseProductivity = nil
    local _allowProductivity = true

    return {
        electricEnergySource = function(self, overrides)
            if (overrides) then
                _energySource = util.merge({ createDefaultEnergySource(), overrides })
            else
                _energySource = createDefaultEnergySource()
            end
            return self
        end,

        burnerEnergySource = function(self, overrides)
            local defaultBurnerEnergySource = {
                type = "burner",
                fuel_categories = { "chemical" },
                effectivity = 1,
                fuel_inventory_size = DEFAULT_FUEL_INVENTORY_SIZE,
                emissions_per_minute = { pollution = DEFAULT_BURNER_POLLUTION }
            }
            if (overrides) then
                _energySource = util.merge({ defaultBurnerEnergySource, overrides })
            else
                _energySource = defaultBurnerEnergySource
            end
            return self
        end,

        baseProductivity = function(self, productivity)
            _baseProductivity = productivity
            return self
        end,

        allowProductivity = function(self, allowProductivity)
            _allowProductivity = allowProductivity
            return self
        end,

        build = function(self, overrides)
            local result = {
                type = "assembling-machine",
                name = name,
                icon = img("lumber-mill-icon.png"),
                flags = { "placeable-neutral", "player-creation" },
                minable = { mining_time = 0.2, result = name },
                fast_replaceable_group = name,
                max_health = 500,
                corpse = "foundry-remnants",
                dying_explosion = "foundry-explosion",
                collision_box = { { -3.7, -3.7 }, { 3.7, 3.7 } },
                selection_box = { { -4, -4 }, { 4, 4 } },
                damaged_trigger_effect = hit_effects.entity(),
                drawing_box_vertical_extension = 1.3,
                module_slots = 4,
                icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
                icons_positioning = {
                    { inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1.25 } }
                },
                allowed_effects = { "consumption", "speed", "pollution", "quality" },
                crafting_categories = { "assembling" },
                crafting_speed = 2,
                energy_source = _energySource,
                energy_usage = "100kW",
                perceived_performance = { minimum = 0.25, performance_to_activity_rate = 2.0, maximum = 20 },
                graphics_set = {
                    animation = {
                        layers = {
                            {
                                filename = img("lumber-mill-shadow.png"),
                                priority = "high",
                                width = 800,
                                height = 700,
                                frame_count = 1,
                                line_length = 1,
                                repeat_count = 80,
                                animation_speed = 0.15,
                                shift = { 0, 0 },
                                draw_as_shadow = true,
                                scale = 0.5
                            },
                            {
                                priority = "high",
                                width = 525,
                                height = 557,
                                frame_count = 80,
                                lines_per_file = 8,
                                shift = { 0, 0 },
                                scale = 0.5,
                                stripes = {
                                    {
                                        filename = img("lumber-mill-animation-1.png"),
                                        width_in_frames = 8,
                                        height_in_frames = 8
                                    },
                                    {
                                        filename = img("lumber-mill-animation-2.png"),
                                        width_in_frames = 8,
                                        height_in_frames = 2
                                    }
                                }
                            },

                        }
                    }
                },
                open_sound = { filename = "__base__/sound/open-close/train-stop-open.ogg", volume = 0.6 },
                close_sound = { filename = "__base__/sound/open-close/train-stop-close.ogg", volume = 0.5 },
            }

            if (_baseProductivity) then
                result.effect_receiver = { base_effect = { productivity = _baseProductivity } }
            end

            if (_allowProductivity) then
                table.insert(result.allowed_effects, "productivity")
            end

            if (overrides) then
                result = util.merge({ result, overrides })
            end

            return result
        end,

        apply = function(self, overrides)
            local result = self:build(overrides)
            data:extend({ result })
            return result
        end
    }
end

local itemBuilder = function(name)
    local _weight = 200 * kg

    return {
        itemsPerRocket = function(self, count)
            _weight = (1000 / count) * kg
            return self
        end,

        build = function(self, overrides)
            local result = {
                type = "item",
                name = name,
                icon = img("lumber-mill-icon.png"),
                subgroup = "production-machine",
                order = "d[" .. name .. "]",
                inventory_move_sound = item_sounds.mechanical_large_inventory_move,
                pick_sound = item_sounds.mechanical_large_inventory_pickup,
                drop_sound = item_sounds.mechanical_large_inventory_move,
                place_result = name,
                stack_size = 20,
                default_import_location = "Nauvis",
                weight = _weight
            }

            if (overrides) then
                result = util.merge({ result, overrides })
            end

            return result
        end,

        apply = function(self, overrides)
            local result = self:build(overrides)
            data:extend({ result })
            return result
        end
    }
end

local recipeBuilder = function(name)
    local _ingredients = {}

    return {
        ingredients = function(self, ingredients)
            _ingredients = ingredients
            return self
        end,

        build = function(self, overrides)
            local result = {
                type = "recipe",
                name = name,
                category = "assembling",
                enabled = false,
                ingredients = _ingredients,
                energy_required = 60,
                results = { { type = "item", name = name, amount = 1 } }
            }

            if (overrides) then
                result = util.merge({ result, overrides })
            end

            return result
        end,

        apply = function(self, overrides)
            local result = self:build(overrides)
            data:extend({ result })
            return result
        end
    }
end

local technologyBuilder = function(name)
    local _icon = img("lumber-mill-technology.png")
    local _iconSize = 256
    local _effects = {
        {
            type = "unlock-recipe",
            recipe = name
        },
    }
    local _prerequisites = {}
    local _unit = {
        count = 500,
        ingredients = {},
        time = 30
    }

    return {
        icon = function(self, path, size)
            _icon = path
            if (size) then
                _iconSize = size
            end
            return self
        end,

        additionalRecipes = function(self, recipes)
            for _, recipe in pairs(recipes) do
                table.insert(_effects, { type = "unlock-recipe", recipe = recipe })
            end
            return self
        end,

        additionalEffects = function(self, effects)
            util.merge({ _effects, effects })
            return self
        end,

        prerequisites = function(self, prerequisites)
            _prerequisites = prerequisites
            return self
        end,

        count = function(self, count)
            _unit.count = count
            return self
        end,

        ingredients = function(self, ingredients)
            _unit.ingredients = ingredients
            return self
        end,

        time = function(self, time)
            _unit.time = time
            return self
        end,

        build = function(self, overrides)
            local result = {
                type = "technology",
                name = name,
                icon = _icon,
                icon_size = _iconSize,
                effects = _effects,
                prerequisites = _prerequisites,
                unit = _unit
            }

            if (overrides) then
                result = util.merge({ result, overrides })
            end

            return result
        end,

        apply = function(self, overrides)
            local result = self:build(overrides)
            data:extend({ result })
            return result
        end
    }
end

MF.Buildings.LumberMill = function(name)
    local _name = name or "lumber-mill"

    return {
        entityBuilder = entityBuilder(_name),
        itemBuilder = itemBuilder(_name),
        recipeBuilder = recipeBuilder(_name),
        technologyBuilder = technologyBuilder(_name)
    }
end