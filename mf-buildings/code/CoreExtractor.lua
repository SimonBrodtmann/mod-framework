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

local img = ImageFactory("buildings-graphics", "1", "/core-extractor/")

local function animationLayer()
    return {
        priority = "high",
        width = 704,
        height = 704,
        frame_count = 120,
        lines_per_file = 8,
        animation_speed = 0.15,
        shift = util.by_pixel(0, -8),
        scale = 0.5,
        stripes = {
            {
                filename = img("core-extractor-animation-1.png"),
                width_in_frames = 8,
                height_in_frames = 8
            },
            {
                filename = img("core-extractor-animation-2.png"),
                width_in_frames = 8,
                height_in_frames = 7
            }
        }
    }
end

--- Core extractor entity builder class
--- @class CoreExtractorEntityBuilder : EntityBuilder
local CoreExtractorEntityBuilder = EntityBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "mining-drill",
            name = self.name,
            icon = img("core-extractor-icon.png"),
            flags = { "placeable-neutral", "player-creation" },
            minable = { mining_time = 0.2, result = self.name },
            fast_replaceable_group = self.name,
            max_health = 500,
            corpse = "big-remnants",
            dying_explosion = "medium-explosion",
            collision_box = mfUtil.collisionBox(11, 11),
            selection_box = mfUtil.selectionBox(11, 11),
            damaged_trigger_effect = hit_effects.entity(),
            drawing_box_vertical_extension = 1.3,
            module_slots = 4,
            icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
            icons_positioning = {
                { inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1.25 } }
            },
            allowed_effects = { "consumption", "speed", "pollution", "quality" },
            mining_speed = 5,
            resource_categories = { "basic-solid", "hard-solid" },
            drops_full_belt_stacks = true,
            resource_searching_radius = 4.99,
            vector_to_place_result = { 0, -5.5 },
            energy_source = self._energySource,
            energy_usage = "1MW",
            perceived_performance = { minimum = 0.25, performance_to_activity_rate = 2.0, maximum = 20 },
            graphics_set = {
                animation = {
                    layers = {
                        {
                            filename = img("core-extractor-shadow.png"),
                            priority = "high",
                            width = 1400,
                            height = 1400,
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
                                    width = 704,
                                    height = 704,
                                    frame_count = 120,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -8),
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("core-extractor-emission-1.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        },
                                        {
                                            filename = img("core-extractor-emission-2.png"),
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
            open_sound = sounds.drill_open,
            close_sound = sounds.drill_close
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

--- Core extractor item builder class
--- @class CoreExtractorItemBuilder : ItemBuilder
local CoreExtractorItemBuilder = ItemBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "item",
            name = self.name,
            icon = img("core-extractor-icon.png"),
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

--- Core extractor recipe builder class
--- @class CoreExtractorRecipeBuilder : RecipeBuilder
local CoreExtractorRecipeBuilder = RecipeBuilder:new({
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

--- Core extractor technology builder class
--- @class CoreExtractorTechnologyBuilder : TechnologyBuilder
local CoreExtractorTechnologyBuilder = TechnologyBuilder:new({
    _icon = img("core-extractor-technology.png"),

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

--- Core extractor factory function
--- @param name string The technical name of this Core extractor instance (default: "core-extractor")
--- @return table A table containing the builders for entity, item, recipe, and technology
return function(name)
    name = name or "core-extractor"

    return {
        EntityBuilder = CoreExtractorEntityBuilder:new({ name = name }),
        ItemBuilder = CoreExtractorItemBuilder:new({ name = name }),
        RecipeBuilder = CoreExtractorRecipeBuilder:new({ name = name }),
        TechnologyBuilder = CoreExtractorTechnologyBuilder:new({ name = name })
    }
end
