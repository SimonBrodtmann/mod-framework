MF.ImageFactory = function(category, part, prefix)
    return function(path)
        return "__" .. MF.prefix .. "-" .. category .. "-" .. part .. "__/graphics" .. (prefix or "") .. path
    end
end