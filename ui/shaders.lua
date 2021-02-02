local Shaders = {
    -- Fades a color to alpha over "modifier" time
    Fade_In = function (r, g, b, a, frame, modifier, target, palette)

        a = a * Kii.Math.clamp(frame / modifier , 0, 1)

        if frame < modifier then
          frame = frame + 1
        else
            modifier = "None"
        end

        return r, g, b, a, frame, modifier, target
    end,
    -- Fades to a "target" color in "modifier" frames
    -- Sets "Transfer" flag when animation is over
    Fade_To = function (r, g, b, a, frame, modifier, target, palette)
        local newR, newG, newB = Kii.Render.colorFind(target, palette)
    
        r = Kii.Math.clamp(r + ((newR - r) * (frame / modifier)), r, newR)
        g = Kii.Math.clamp(g + ((newG - g) * (frame / modifier)), g, newG)
        b = Kii.Math.clamp(b + ((newB - b) * (frame / modifier)), b, newB)
    
        if frame < modifier then
          frame = frame + 1
        else
          frame = 0
          modifier = "Transfer"
        end

        return r, g, b, a, frame, modifier, target
    end,
    -- Fades a color to alpha over "modifier" time
    Fade_Out = function (r, g, b, a, frame, modifier, target, palette)

        a = a * Kii.Math.clamp(1 - frame / modifier , 0, 1)

        if frame < modifier then
          frame = frame + 1
        else
            modifier = "Delete"
        end

        return r, g, b, a, frame, modifier, target
    end,

    -- Fades a color to "target" percentage of Black over "modifier" time
    Darken = function (r, g, b, a, frame, modifier, target, palette)
        local newR, newG, newB = Kii.Render.colorFind("Black", palette)
    
        r = Kii.Math.clamp(r + ((newR - r) * (frame / modifier)) * target, newR, r)
        g = Kii.Math.clamp(g + ((newG - g) * (frame / modifier)) * target, newG, g)
        b = Kii.Math.clamp(b + ((newB - b) * (frame / modifier)) * target, newB, b)
        if frame < modifier then
          frame = frame + 1
        end

        return r, g, b, a, frame, modifier, target
    end,
    -- Fades a color to "target" percentage of White over "modifier" time
    Lighten = function (r, g, b, a, frame, modifier, target, palette)
        local newR, newG, newB = Kii.Render.colorFind("White", palette)
    
        r = Kii.Math.clamp(r + ((newR - r) * (frame / modifier)) * target, r, newR)
        g = Kii.Math.clamp(g + ((newG - g) * (frame / modifier)) * target, g, newG)
        b = Kii.Math.clamp(b + ((newB - b) * (frame / modifier)) * target, b, newB)
        if frame < modifier then
            print(frame)
            print(r)
          frame = frame + 1
        end

        return r, g, b, a, frame, modifier, target
    end,

    -- Nothing!
    None = function (r, g, b, a, frame, modifier, target, palette)

        return r, g, b, a, frame, modifier, target
    end


}

return Shaders