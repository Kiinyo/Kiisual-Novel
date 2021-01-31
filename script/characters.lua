-- Everyone you'd like to call on in your story
-- Characters include everyone who speaks in your
-- story as well as everyone who can be seen!
local Characters = {
    -- What we call the character in our script
    Generic = {
        -- What the character's name will appear as
        -- when they are speaking in game
        _name = "Generic Person",
        -- What sfx will play for their 'voice'
        _voice = "Generic",
        -- The color of their name if they're a speaker
        _color = "Black",
        -- The name of the folder in the sprites folder
        -- corresponding to them
        Sprite = "Default"
    },
    Narrator = {
      _name = "Narrator",
      _voice = "Generic_Female",
      _color = "White",
      -- This can be nil if you want to make a character
      -- that only speaks and is never seen, but make sure
      -- to stick to 'sSpk' and never try to 'aCha' them!
      Sprite =  nil
    }
}

return Characters