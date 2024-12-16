local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")
local ImageFactory = require(MF.lib .. "ImageFactory")
local EntityBuilder = require(MF.lib .. "EntityBuilder")
local ItemBuilder = require(MF.lib .. "ItemBuilder")
local RecipeBuilder = require(MF.lib .. "RecipeBuilder")
local TechnologyBuilder = require(MF.lib .. "TechnologyBuilder")

local img = ImageFactory("buildings-graphics", "1", "/lumber-mill/")

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

        if (self._baseProductivity) then
            result.effect_receiver = { base_effect = { productivity = self._baseProductivity } }
        end

        if (self._allowProductivity) then
            table.insert(result.allowed_effects, "productivity")
        end

        if (overrides) then
            result = util.merge({ result, overrides })
        end

        return result
    end
})

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
            default_import_location = "Nauvis",
            weight = self._weight
        }

        if (overrides) then
            result = util.merge({ result, overrides })
        end

        return result
    end
})

local LumberMillRecipeBuilder = RecipeBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "recipe",
            name = self.name,
            category = "assembling",
            enabled = false,
            ingredients = self._ingredients,
            energy_required = 60,
            results = { { type = "item", name = self.name, amount = 1 } }
        }

        if (overrides) then
            result = util.merge({ result, overrides })
        end

        return result
    end
})

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
            result = util.merge({ result, overrides })
        end

        return result
    end
})

return function(name)
    name = name or "lumber-mill"

    return {
        EntityBuilder = LumberMillEntityBuilder:new({ name = name }),
        ItemBuilder = LumberMillItemBuilder:new({ name = name }),
        RecipeBuilder = LumberMillRecipeBuilder:new({ name = name }),
        TechnologyBuilder = LumberMillTechnologyBuilder:new({ name = name })
    }
end