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
    _pipes = false,

    --- Enables pipes
    --- @return AdvancedFoundryEntityBuilder
    pipes = function(self)
        self._pipes = true
        return self
    end,

    build = function(self, overrides)
        local result = {
            type = "assembling-machine",
            name = self.name,
            icon = img("advanced-foundry-icon.png"),
            flags = { "placeable-neutral", "player-creation" },
            minable = { mining_time = 0.2, result = self.name },
            fast_replaceable_group = self.name,
            max_health = 500,
            corpse = "big-remnants",
            dying_explosion = "medium-explosion",
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
            working_sound = {
                fade_in_ticks = 4,
                fade_out_ticks = 20,
                audible_distance_modifier = 0.6,
                max_sounds_per_type = 2,
                sound = {
                    filename = "__space-age__/sound/entity/foundry/foundry.ogg", volume = 0.5
                },
                sound_accents = {
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-rocks.ogg", volume = 0.65 },       frame = 1,   audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-rocks.ogg", volume = 0.65 },       frame = 61,  audible_distance_modifier = 0.3 },
                    { sound = { variations = sound_variations("__space-age__/sound/entity/foundry/foundry-pour", 2) },    frame = 18,  audible_distance_modifier = 0.4 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.65 }, frame = 8,   audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45 },       frame = 18,  audible_distance_modifier = 0.5 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.65 },  frame = 30,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.65 }, frame = 38,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45 },       frame = 48,  audible_distance_modifier = 0.5 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.65 },  frame = 60,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.65 }, frame = 68,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45 },       frame = 78,  audible_distance_modifier = 0.5 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.65 },  frame = 90,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-close.ogg", volume = 0.65 }, frame = 98,  audible_distance_modifier = 0.3 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-clamp.ogg", volume = 0.45 },       frame = 108, audible_distance_modifier = 0.5 },
                    { sound = { filename = "__space-age__/sound/entity/foundry/foundry-slide-open.ogg", volume = 0.65 },  frame = 120, audible_distance_modifier = 0.3 },
                }
            }
        }

        if (self._baseProductivity) then
            result.effect_receiver = { base_effect = { productivity = self._baseProductivity } }
        end

        if (self._allowProductivity) then
            table.insert(result.allowed_effects, "productivity")
        end

        if self._pipes then
            result.fluid_boxes = {
                {
                    production_type = "input",
                    pipe_picture = assembler2pipepictures(),
                    pipe_covers = pipecoverspictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { -1.5, 3.5 } } }
                },
                {
                    production_type = "input",
                    pipe_picture = assembler2pipepictures(),
                    pipe_covers = pipecoverspictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 1.5, 3.5 } } }
                },
                {
                    production_type = "output",
                    pipe_picture = assembler2pipepictures(),
                    pipe_covers = pipecoverspictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 100,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { -1.5, -3.5 } } }
                },
                {
                    production_type = "output",
                    pipe_picture = assembler2pipepictures(),
                    pipe_covers = pipecoverspictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 100,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.north, position = { 1.5, -3.5 } } }
                }
            }
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
            order = self._order .. "[" .. self.name .. "]",
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
