local meld = require("meld")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local ImageFactory = require(MF.lib .. "ImageFactory")
local EntityBuilder = require(MF.lib .. "EntityBuilder")
local ItemBuilder = require(MF.lib .. "ItemBuilder")
local RecipeBuilder = require(MF.lib .. "RecipeBuilder")
local TechnologyBuilder = require(MF.lib .. "TechnologyBuilder")
local mfUtil = require(MF.lib .. "util")

local img = ImageFactory("buildings-graphics", "1", "/advanced-foundry/")

local function animationLayer()
    return {
        priority = "high",
        width = 530,
        height = 530,
        frame_count = 120,
        lines_per_file = 8,
        animation_speed = 0.15,
        shift = util.by_pixel(0, -8),
        scale = 0.5,
        stripes = {
            {
                filename = img("advanced-foundry-animation-1.png"),
                width_in_frames = 8,
                height_in_frames = 8
            },
            {
                filename = img("advanced-foundry-animation-2.png"),
                width_in_frames = 8,
                height_in_frames = 7
            }
        }
    }
end

--- Advanced foundry entity builder class
--- @class AdvancedFoundryEntityBuilder : EntityBuilder
local AdvancedFoundryEntityBuilder = EntityBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "assembling-machine",
            name = self.name,
            icon = img("advanced-foundry-icon.png"),
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
            module_slots = 6,
            icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
            icons_positioning = {
                { inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1.25 } }
            },
            allowed_effects = { "consumption", "speed", "pollution", "quality" },
            crafting_categories = {},
            crafting_speed = 6,
            energy_source = self._energySource,
            energy_usage = "4MW",
            perceived_performance = { minimum = 0.25, performance_to_activity_rate = 2.0, maximum = 20 },
            graphics_set = {
                animation = {
                    layers = {
                        {
                            filename = img("advanced-foundry-shadow.png"),
                            priority = "high",
                            width = 900,
                            height = 800,
                            frame_count = 1,
                            line_length = 1,
                            repeat_count = 120,
                            animation_speed = 0.15,
                            shift = util.by_pixel(0, -8),
                            draw_as_shadow = true,
                            scale = 0.5
                        },
                        animationLayer()
                    }
                },
                working_visualisations = {
                    {
                        fadeout = true,
                        animation = {
                            layers = {
                                animationLayer(),
                                {
                                    priority = "high",
                                    draw_as_glow = true,
                                    blend_mode = "additive",
                                    width = 530,
                                    height = 530,
                                    frame_count = 120,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -8),
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("advanced-foundry-emission-1.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        },
                                        {
                                            filename = img("advanced-foundry-emission-2.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 7
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            open_sound = sounds.metal_large_open,
            close_sound = sounds.metal_large_close,
            --fluid_boxes = table.deepcopy(data.raw["assembling-machine"]["foundry"].fluid_boxes),
            --fluid_boxes_off_when_no_fluid_recipe = true,
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

--- Advanced foundry item builder class
--- @class AdvancedFoundryItemBuilder : ItemBuilder
local AdvancedFoundryItemBuilder = ItemBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "item",
            name = self.name,
            icon = img("advanced-foundry-icon.png"),
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

--- Advanced foundry recipe builder class
--- @class AdvancedFoundryRecipeBuilder : RecipeBuilder
local AdvancedFoundryRecipeBuilder = RecipeBuilder:new({
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

--- Advanced foundry technology builder class
--- @class AdvancedFoundryTechnologyBuilder : TechnologyBuilder
local AdvancedFoundryTechnologyBuilder = TechnologyBuilder:new({
    _icon = img("advanced-foundry-technology.png"),

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

--- Advanced foundry factory function
--- @param name string The technical name of this Advanced foundry instance (default: "advanced-foundry")
--- @return table A table containing the builders for entity, item, recipe, and technology
return function(name)
    name = name or "advanced-foundry"

    return {
        EntityBuilder = AdvancedFoundryEntityBuilder:new({ name = name }),
        ItemBuilder = AdvancedFoundryItemBuilder:new({ name = name }),
        RecipeBuilder = AdvancedFoundryRecipeBuilder:new({ name = name }),
        TechnologyBuilder = AdvancedFoundryTechnologyBuilder:new({ name = name })
    }
end