local util = {}

--- Generates a selection box definition using width and height of the entity in tiles.
--- @param width number The width of the entity in tiles
--- @param height number The height of the entity in tiles
--- @return table A table containing the selection box definition
util.selectionBox = function(width, height)
    return {
        { -width / 2, -height / 2 },
        { width / 2, height / 2 }
    }
end

--- Generates a collision box definition using width and height of the entity in tiles.
--- @param width number The width of the entity in tiles
--- @param height number The height of the entity in tiles
--- @param margin number The margin to apply to the collision box compared to the selection box (default: 0.3)
--- @return table A table containing the collision box definition
util.collisionBox = function(width, height, margin)
    margin = margin or 0.1
    return {
        { -width / 2 + margin, -height / 2 + margin },
        { width / 2 - margin, height / 2 - margin }
    }
end

--- Checks if a table contains a certain value
--- @param table table The table to check
--- @param value any The value to check for
--- @return boolean
util.contains = function(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

--- Filter the values of table1 that are in table2.
--- @param target table The table to filter
--- @param filter table The filter to apply
--- @return table A table containing the filtered values
util.filter = function(target, filter)
    local result = {}
    for _, value in pairs(target) do
        if not util.contains(filter, value) then
            table.insert(result, value)
        end
    end
    return result
end

return util