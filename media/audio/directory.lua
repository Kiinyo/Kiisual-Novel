-- Here we include the filenames of everything in the audio folder!
-- I'm sure there's a way to do this in Lua but StackOverflow is
-- telling me to install libraries and I'd rather not!

local directory = {
    -- All the sound effects
    -- .wav files only atm!
    SFX = {
        "Generic",
        "Generic_Male",
        "Generic_Female"
    },
    -- All the background music
    -- .mp3 files only atm!
    BGM = {
        "Generic_Jazz"
    }
}

return directory