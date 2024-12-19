--- Build image paths easily.
--- @param category string The category of the image (the part of the mod name after the `mf-` prefix)
--- @param part string The part of the graphics mod that the image is in
--- @param prefix string The prefix of the image path
return function(category, part, prefix)
    return function(path)
        return "__" .. MF.prefix .. "-" .. category .. "-" .. part .. "__/graphics" .. (prefix or "") .. path
    end
end