local imageBundles = {
    MF.imageFactory("buildings-graphics", "1")
}

MF.Buildings.getImage = function(path, bundle)
    return imageBundles[bundle](path)
end