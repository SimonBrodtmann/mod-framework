MF.imageFactory = function(category, part)
    return function(path)
        return "__" .. MF.prefix .. "-" .. category .. "-" .. part .. "__" .. path
    end
end