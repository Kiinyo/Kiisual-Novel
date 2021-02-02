-- Unforuntately writing new Animations needs a bit of
-- knowledge of how to program in Lua but I'll do my best
-- to explain what everything does so you can know what the
-- existing animations do!
local Animations = {
    -- Animations take in an x, y, width, and height of
    -- the Element along with its frame and modifier, and
    -- uses that information to do something with them!

    -- Usually the frame refers to how far along the
    -- animation is and modifier usually refers to magnitude
    -- or length of the animation but you can use these values
    -- for whatever you want!

    -- It's important to note that the x, y, width, and height
    -- of the Element are not actually changed, only how they
    -- are drawn on your monitor for that specific frame changes!
    -- That means you don't have to worry about resetting the x
    -- and y every frame and keeping track of the changes. The
    -- only changes you make that carry over are ones done to
    -- the frame and modifier!

    -- You can also set the modifier to "None" to remove any animations

    -- Jitters the position of the Element on screen by modifier
    Jitter_Position = function (x, y, width, height, frame, modifier)

        -- All I'm doing here is moving the x and y coordinates of the
        -- Element by a random number in a range between +/- the modifier
        -- So if an element has a modifier of 20, and an x of 200, the
        -- Element will be in a random position between 180 and 220 x
        -- every frame!

        x = x + ((math.random() - 0.5) * (modifier * 2))
        y = y + ((math.random() * 2 - 1) * modifier)
        
        return x, y, width, height, frame, modifier
    end,
    -- Similar to Jitter_Position, but also jitters the width and height
    -- of the Element!
    Jitter_Everything = function (x, y, width, height, frame, modifier)
        -- Position Jitter
        x = ((math.random() - 0.5) * (modifier * 2)) + x
        y = ((math.random() - 0.5) * (modifier * 2)) + y
        -- Dimension Jitter
        width = ((math.random() - 0.5) * (modifier * 2)) + width
        height = ((math.random() - 0.5) * (modifier * 2)) + height

        return x, y, width, height, frame, modifier
    end,
    
    -- Simulate an Element being pressed by the player by shrinking by 1/modifier
    Press_Down = function (x, y, width, height, frame, modifier)

        -- Here we've moving the Element down by 1/modifier of its height
        -- and shrinking it by the same amount! So if the modifier is 16,
        -- we're shrinking the button by 1/16th its height!
        y = y + height / modifier
        height = height * (modifier - 1) / modifier

        return x, y, width, height, frame, modifier
    end,
    -- Slide the element down 1 pixel per frame until it it's moved modifier
    -- pixels and stay there.
    Slide_Down = function (x, y, width, height, frame, modifier)
        
        y = y + frame

        if frame < modifier then 
            frame = frame + 1 
        end

        return x, y, width, height, frame, modifier
    end,
    -- An aesthetic function that allows Slide_Down's displacement to
    -- return to 0 without immediately snapping back!
    Return_Down = function (x, y, width, height, frame, modifier)

        y = y + frame

        if frame > 0 then
            frame = frame - 1
        else
            frame = 0
            -- This tells kii.lua to remove animations!
            modifier = "None"
        end

        return x, y, width, height, frame, modifier
    end,
    
    -- Same as Down but for the right
    Press_Right = function (x, y, width, height, frame, modifier)
        x = x + width / modifier
        width = width * (modifier - 1) / modifier
        return x, y, width, height, frame, modifier
    end,
    Slide_Right = function (x, y, width, height, frame, modifier)        
        x = x + frame
        if frame < modifier then 
            frame = frame + 1 
        end
        return x, y, width, height, frame, modifier
    end,
    Return_Right = function (x, y, width, height, frame, modifier)
        x = x + frame
        if frame > 0 then
            frame = frame - 1
        else
            frame = 0
            modifier = "None"
        end
        return x, y, width, height, frame, modifier
    end,

}

return Animations