-- A list of palettes you can use for UI elements!
-- Because of LOVE colors are a float between 0 and
-- 1 instead of 0 to 255, you'll have to convert the
-- RGB values into a percentage of 255! You can write 
-- out the numbers if you want but I found xxx/255 is
-- much more human readable!

local Palettes = {
    -- Feel free to edit this but do not delete or
    -- rename or any default values will break!

    Default = { -- Currently using https://lospec.com/palette-list/tauriel-16

      -- As a rule of thumb, black and white are always useful
      Black  = { 023/255, 023/255, 028/255 },
      White  = { 220/255, 214/255, 207/255 },
      -- As well as the Primary Colors
      Red    = { 155/255, 053/255, 053/255 },
      Blue   = { 059/255, 083/255, 106/255 },
      Yellow = { 217/255, 189/255, 102/255 },
      -- The Secondaries
      Purple = { 073/255, 054/255, 058/255 },
      Green  = { 113/255, 161/255, 078/255 },
      Orange = { 161/255, 106/255, 065/255 },
      -- And some Tertiaries
      Pine   = { 064/255, 071/255, 053/255 },
      Cyan   = { 033/255, 146/255, 126/255 },
      Peach  = { 232/255, 198/255, 161/255 },
      -- Finally make sure to add this and keep the
      -- values the same unless you want to tint all
      -- of your images!
      Clear  = {255,255,255}
    }
}

return Palettes