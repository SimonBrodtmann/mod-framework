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

local img = ImageFactory("buildings-graphics", "1", "/chemical-stager/")

--- Chemical stager entity builder class
--- @class ChemicalStagerEntityBuilder : EntityBuilder
local ChemicalStagerEntityBuilder = EntityBuilder:new({
    _pipes = false,

    --- Enables pipes
    --- @return ChemicalStagerEntityBuilder
    pipes = function(self)
        self._pipes = true
        return self
    end,

    build = function(self, overrides)
        local result = {
            type = "assembling-machine",
            name = self.name,
            icon = img("chemical-stager-icon.png"),
            flags = { "placeable-neutral", "player-creation", "placeable-player" },
            minable = { mining_time = 0.2, result = self.name },
            fast_replaceable_group = self.name,
            max_health = 500,
            corpse = "big-remnants",
            dying_explosion = "medium-explosion",
            collision_box = mfUtil.collisionBox(6, 6),
            selection_box = mfUtil.selectionBox(6, 6),
            damaged_trigger_effect = hit_effects.entity(),
            drawing_box_vertical_extension = 1.3,
            module_slots = 4,
            icon_draw_specification = { scale = 2, shift = { 0, -0.3 } },
            icons_positioning = {
                { inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1.25 } }
            },
            allowed_effects = { "consumption", "speed", "pollution", "quality" },
            crafting_categories = {},
            crafting_speed = 4,
            energy_source = self._energySource,
            energy_usage = "4MW",
            perceived_performance = { minimum = 0.25, performance_to_activity_rate = 2.0, maximum = 20 },
            graphics_set = {
                animation = {
                    layers = {
                        {
                            filename = img("chemical-stager-shadow.png"),
                            priority = "high",
                            width = 800,
                            height = 600,
                            frame_count = 1,
                            line_length = 1,
                            repeat_count = 60,
                            animation_speed = 0.15,
                            draw_as_shadow = true,
                            scale = 0.5
                        },
                        {
                            priority = "high",
                            width = 400,
                            height = 400,
                            frame_count = 60,
                            lines_per_file = 8,
                            animation_speed = 0.15,
                            scale = 0.5,
                            stripes = {
                                {
                                    filename = img("chemical-stager-animation.png"),
                                    width_in_frames = 8,
                                    height_in_frames = 8
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
                                    width = 400,
                                    height = 400,
                                    frame_count = 60,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("chemical-stager-animation.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        }
                                    }
                                },
                                {
                                    priority = "high",
                                    draw_as_glow = true,
                                    blend_mode = "additive",
                                    width = 400,
                                    height = 400,
                                    frame_count = 60,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("chemical-stager-emission.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            open_sound = sounds.machine_open,
            close_sound = sounds.machine_close
        }

        if (self._baseProductivity) then
            result.effect_receiver = { base_effect = { productivity = self._baseProductivity } }
        end

        if (self._allowProductivity) then
            table.insert(result.allowed_effects, "productivity")
        end

        if self._pipes then
            result.fluid_boxes = {
                --first set
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.north, position = { -1.5, -2.5 } } }
                },
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.north, position = { 1.5, -2.5 } } }
                },
                --second set
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.east, position = { 2.5, 1.5 } } }
                },
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 1000,
                    pipe_connections = { { flow_direction = "input", direction = defines.direction.east, position = { 2.5, -1.5 } } }
                },
                -- third set
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 500,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { -1.5, 2.5 } } }
                },
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 500,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { 1.5, 2.5 } } }
                },
                -- fourth set
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 500,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.west, position = { -2.5, -1.5 } } }
                },
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    secondary_draw_orders = { north = -1 },
                    volume = 500,
                    pipe_connections = { { flow_direction = "output", direction = defines.direction.west, position = { -2.5, 1.5 } } }
                }
            }
        end

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Chemical stager item builder class
--- @class ChemicalStagerItemBuilder : ItemBuilder
local ChemicalStagerItemBuilder = ItemBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "item",
            name = self.name,
            icon = img("chemical-stager-icon.png"),
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

--- Chemical stager recipe builder class
--- @class ChemicalStagerRecipeBuilder : RecipeBuilder
local ChemicalStagerRecipeBuilder = RecipeBuilder:new({
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

--- Chemical stager technology builder class
--- @class ChemicalStagerTechnologyBuilder : TechnologyBuilder
local ChemicalStagerTechnologyBuilder = TechnologyBuilder:new({
    _icon = img("chemical-stager-technology.png"),

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

--- Chemical stager factory function
--- @param name string The technical name of this atom forge instance (default: "chemical-stager")
--- @return table A table containing the builders for entity, item, recipe, and technology
return function(name)
    name = name or "chemical-stager"

    return {
        EntityBuilder = ChemicalStagerEntityBuilder:new({ name = name }),
        ItemBuilder = ChemicalStagerItemBuilder:new({ name = name }),
        RecipeBuilder = ChemicalStagerRecipeBuilder:new({ name = name }),
        TechnologyBuilder = ChemicalStagerTechnologyBuilder:new({ name = name })
    }
end
