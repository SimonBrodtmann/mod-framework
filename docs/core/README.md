The core defines modules and classes used by the other mods. This is relevant for using Factories and Builders as they
inherit functionality from the core classes.

Read [the Lua book](https://www.lua.org/pil/16.html) if you want to learn how work with classes in Lua.

The the LDoc in the source for a list of functions and their arguments.

## Builder

Abstract builder class that provides `build` and `apply`. Use `build` if you just want to generate prototype data that
you can manipulate and apply manually. Use `apply` if you want the builder to call `data:extend` for you directly.
Both accept an overrides table as the first argument that is applied after prototype generation.

[Source](https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-core/lib/Builder.lua)

## EntityBuilder

Builder used to create entity prototype data. Sometimes, this builder is not used because the convenience functions are
mostly for machines.

[Source](https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-core/lib/EntityBuilder.lua)

## ItemBuilder

Builder used to create item prototype data.

[Source](https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-core/lib/ItemBuilder.lua)

## RecipeBuilder

Builder used to create recipe prototype data.

[Source](https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-core/lib/RecipeBuilder.lua)

## TechnologyBuilder

Builder used to create technology prototype data.

[Source](https://github.com/SimonBrodtmann/mod-framework/blob/main/mf-core/lib/TechnologyBuilder.lua)

## ImageFactory

Convenience factory to generate image paths for the graphics mods.