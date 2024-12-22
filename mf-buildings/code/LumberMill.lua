local meld = require("meld")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")
local ImageFactory = require(MF.lib .. "ImageFactory")
local EntityBuilder = require(MF.lib .. "EntityBuilder")
local ItemBuilder = require(MF.lib .. "ItemBuilder")
local RecipeBuilder = require(MF.lib .. "RecipeBuilder")
local TechnologyBuilder = require(MF.lib .. "TechnologyBuilder")
local mfUtil = require(MF.lib .. "util")

local img = ImageFactory("buildings-graphics", "1", "/lumber-mill/")

--- Lumber mill entity builder class
--- @class LumberMillEntityBuilder : EntityBuilder
local LumberMillEntityBuilder = EntityBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "assembling-machine",
            name = self.name,
            icon = img("lumber-mill-icon.png"),
            flags = { "placeable-neutral", "player-creation" },
            minable = { mining_time = 0.2, result = self.name },
            fast_replaceable_group = self.name,
            max_health = 500,
            corpse = "foundry-remnants",
            dying_explosion = "foundry-explosion",
            collision_box = mfUtil.collisionBox(8, 8),
            selection_box = mfUtil.selectionBox(8, 8),
            damaged_trigger_effect = hit_effects.entity(),
            drawing_box_vertical_extension = 1.3,
            module_slots = 4,
            icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
            icons_positioning = {
                { inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1.25 } }
            },
            allowed_effects = { "consumption", "speed", "pollution", "quality" },
            crafting_categories = {},
            crafting_speed = 2,
            energy_source = self._energySource,
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
                            shift = util.by_pixel(0, -8),
                            draw_as_shadow = true,
                            scale = 0.5
                        },
                        {
                            priority = "high",
                            width = 525,
                            height = 557,
                            frame_count = 80,
                            lines_per_file = 8,
                            animation_speed = 0.15,
                            shift = util.by_pixel(0, -8),
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
                },
                working_visualisations = {
                    {
                        fadeout = true,
                        animation = {
                            layers = {
                                {
                                    priority = "high",
                                    width = 525,
                                    height = 557,
                                    frame_count = 80,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -8),
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
                                {
                                    priority = "high",
                                    draw_as_glow = true,
                                    blend_mode = "additive",
                                    width = 525,
                                    height = 557,
                                    frame_count = 80,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -8),
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("lumber-mill-emission-1.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        },
                                        {
                                            filename = img("lumber-mill-emission-2.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 2
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            open_sound = { filename = "__base__/sound/open-close/train-stop-open.ogg", volume = 0.6 },
            close_sound = { filename = "__base__/sound/open-close/train-stop-close.ogg", volume = 0.5 },
            working_sound = {
                fade_in_ticks = 4,
                fade_out_ticks = 20,
                audible_distance_modifier = 0.6,
                max_sounds_per_type = 2,
                sound = { filename = "__space-age__/sound/entity/foundry/foundry.ogg", volume = 0.6 },
                sound_accents = {
                    { sound = { filename = img("lumber-mill-saw-1.ogg"), volume = 0.8 },           frame = 26, audible_distance_modifier = 0.5 },
                    { sound = { filename = img("lumber-mill-fall.ogg"), volume = 1.2 },            frame = 42, audible_distance_modifier = 0.5 },
                    { sound = { filename = img("lumber-mill-saw-2.ogg"), volume = 0.8 },           frame = 53, audible_distance_modifier = 0.4 },
                    { sound = { filename = img("lumber-mill-split.ogg"), volume = 0.4 },           frame = 62, audible_distance_modifier = 0.3 },
                    { sound = { variations = sound_variations(img("lumber-mill-plank"), 3, 0.5) }, frame = 14, audible_distance_modifier = 0.3 },
                    { sound = { variations = sound_variations(img("lumber-mill-plank"), 3, 0.5) }, frame = 34, audible_distance_modifier = 0.3 },
                    { sound = { variations = sound_variations(img("lumber-mill-plank"), 3, 0.5) }, frame = 54, audible_distance_modifier = 0.3 },
                    { sound = { variations = sound_variations(img("lumber-mill-plank"), 3, 0.5) }, frame = 74, audible_distance_modifier = 0.3 },
                }
            }
        }

        if (self._baseProductivity) then
            result.effect_receiver = { base_effect = { productivity = self._baseProductivity } }
        end

        if (self._allowProductivity) then
            table.insert(result.allowed_effects, "productivity")
        end

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Lumber mill item builder class
--- @class LumberMillItemBuilder : ItemBuilder
local LumberMillItemBuilder = ItemBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "item",
            name = self.name,
            icon = img("lumber-mill-icon.png"),
            subgroup = "production-machine",
            order = "d[" .. self.name .. "]",
            inventory_move_sound = item_sounds.mechanical_large_inventory_move,
            pick_sound = item_sounds.mechanical_large_inventory_pickup,
            drop_sound = item_sounds.mechanical_large_inventory_move,
            place_result = self.name,
            stack_size = 20,
            default_import_location = "nauvis",
            weight = self._weight
        }

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Lumber mill recipe builder class
--- @class LumberMillRecipeBuilder : RecipeBuilder
local LumberMillRecipeBuilder = RecipeBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "recipe",
            name = self.name,
            category = "crafting",
            enabled = false,
            ingredients = self._ingredients,
            energy_required = 60,
            results = { { type = "item", name = self.name, amount = 1 } },
            surface_conditions = self._surfaceConditions
        }

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Lumber mill technology builder class
--- @class LumberMillTechnologyBuilder : TechnologyBuilder
local LumberMillTechnologyBuilder = TechnologyBuilder:new({
    _icon = img("lumber-mill-technology.png"),

    build = function(self, overrides)
        local result = {
            type = "technology",
            name = self.name,
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

--- Lumber mill factory function
--- @param name string The technical name of this lumber mill instance (default: "lumber-mill")
--- @return table A table containing the builders for entity, item, recipe, and technology
return function(name)
    name = name or "lumber-mill"

    return {
        EntityBuilder = LumberMillEntityBuilder:new({ name = name }),
        ItemBuilder = LumberMillItemBuilder:new({ name = name }),
        RecipeBuilder = LumberMillRecipeBuilder:new({ name = name }),
        TechnologyBuilder = LumberMillTechnologyBuilder:new({ name = name })
    }
end
