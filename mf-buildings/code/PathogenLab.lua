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

local img = ImageFactory("buildings-graphics", "1", "/pathogen-lab/")

--- Pathogen lab entity builder class
--- @class PathogenLabEntityBuilder : EntityBuilder
local PathogenLabEntityBuilder = EntityBuilder:new({
    _pipes = false,

    --- Enables pipes
    --- @return PathogenLabEntityBuilder
    pipes = function(self)
        self._pipes = true
        return self
    end,

    build = function(self, overrides)
        local result = {
            type = "assembling-machine",
            name = self.name,
            icon = img("pathogen-lab-icon.png"),
            flags = { "placeable-neutral", "player-creation", "placeable-player" },
            minable = { mining_time = 0.2, result = self.name },
            fast_replaceable_group = self.name,
            max_health = 500,
            corpse = "big-remnants",
            dying_explosion = "medium-explosion",
            collision_box = mfUtil.collisionBox(7, 7),
            selection_box = mfUtil.selectionBox(7, 7),
            heating_energy = "300kW",
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
                            filename = img("pathogen-lab-shadow.png"),
                            priority = "high",
                            width = 800,
                            height = 700,
                            frame_count = 1,
                            line_length = 1,
                            repeat_count = 60,
                            animation_speed = 0.15,
                            shift = util.by_pixel(0, -16),
                            draw_as_shadow = true,
                            scale = 0.5
                        },
                        {
                            priority = "high",
                            width = 500,
                            height = 500,
                            frame_count = 60,
                            lines_per_file = 8,
                            animation_speed = 0.15,
                            shift = util.by_pixel(0, -16),
                            scale = 0.5,
                            stripes = {
                                {
                                    filename = img("pathogen-lab-animation.png"),
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
                                    width = 500,
                                    height = 500,
                                    frame_count = 60,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -16),
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("pathogen-lab-animation.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        }
                                    }
                                },
                                {
                                    priority = "high",
                                    draw_as_glow = true,
                                    blend_mode = "additive",
                                    width = 500,
                                    height = 500,
                                    frame_count = 60,
                                    lines_per_file = 8,
                                    animation_speed = 0.15,
                                    shift = util.by_pixel(0, -16),
                                    scale = 0.5,
                                    stripes = {
                                        {
                                            filename = img("pathogen-lab-emission.png"),
                                            width_in_frames = 8,
                                            height_in_frames = 8
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                frozen_patch = {
                    priority = "low",
                    width = 500,
                    height = 500,
                    frame_count = 60,
                    lines_per_file = 8,
                    animation_speed = 0.15,
                    shift = util.by_pixel(0, -16),
                    scale = 0.5,
                    filename = img("pathogen-lab-frozen.png"),
                },
                reset_animation_when_frozen = true
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
                    render_layer = "lower-object-above-shadow",
                    volume = 1000,
                    pipe_connections = {
                        {
                            flow_direction = "input",
                            direction = defines.direction.north,
                            position = { -1, -3 }
                        }
                    }
                },
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    render_layer = "lower-object-above-shadow",
                    volume = 1000,
                    pipe_connections = {
                        {
                            flow_direction = "input",
                            direction = defines.direction.north,
                            position = { 1, -3 }
                        }
                    }
                },
                --second set
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 1000,
                    pipe_connections = {
                        {
                            flow_direction = "input",
                            direction = defines.direction.east,
                            position = { 3, 1 }
                        }
                    }
                },
                {
                    production_type = "input",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 1000,
                    pipe_connections = {
                        {
                            flow_direction = "input",
                            direction = defines.direction.east,
                            position = { 3, -1 }
                        }
                    }
                },
                -- third set
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 500,
                    pipe_connections = {
                        {
                            flow_direction = "output",
                            direction = defines.direction.south,
                            position = { -1, 3 }
                        }
                    }
                },
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 500,
                    pipe_connections = {
                        {
                            flow_direction = "output",
                            direction = defines.direction.south,
                            position = { 1, 3 }
                        }
                    }
                },
                -- fourth set
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 500,
                    pipe_connections = {
                        {
                            flow_direction = "output",
                            direction = defines.direction.west,
                            position = { -3, -1 }
                        }
                    }
                },
                {
                    production_type = "output",
                    pipe_covers = pipecoverspictures(),
                    pipe_picture = assembler2pipepictures(),
                    volume = 500,
                    pipe_connections = {
                        {
                            flow_direction = "output",
                            direction = defines.direction.west,
                            position = { -3, 1 }
                        }
                    }
                }
            }
        end

        if (overrides) then
            result = meld(result, overrides)
        end

        return result
    end
})

--- Pathogen lab item builder class
--- @class PathogenLabItemBuilder : ItemBuilder
local PathogenLabItemBuilder = ItemBuilder:new({
    build = function(self, overrides)
        local result = {
            type = "item",
            name = self.name,
            icon = img("pathogen-lab-icon.png"),
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

--- Pathogen lab recipe builder class
--- @class PathogenLabRecipeBuilder : RecipeBuilder
local PathogenLabRecipeBuilder = RecipeBuilder:new({
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

--- Pathogen lab technology builder class
--- @class PathogenLabTechnologyBuilder : TechnologyBuilder
local PathogenLabTechnologyBuilder = TechnologyBuilder:new({
    _icon = img("pathogen-lab-technology.png"),

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

--- Pathogen lab factory function
--- @param name string The technical name of this atom forge instance (default: "pathogen-lab")
--- @return table A table containing the builders for entity, item, recipe, and technology
return function(name)
    name = name or "pathogen-lab"

    return {
        EntityBuilder = PathogenLabEntityBuilder:new({ name = name }),
        ItemBuilder = PathogenLabItemBuilder:new({ name = name }),
        RecipeBuilder = PathogenLabRecipeBuilder:new({ name = name }),
        TechnologyBuilder = PathogenLabTechnologyBuilder:new({ name = name })
    }
end
