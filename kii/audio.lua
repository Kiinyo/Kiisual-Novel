Kii.Audio = {
  loadAudio = function ()
    print("Starting SFX loading...")
    local audioDir = require "media/audio/directory"
    local index = 1
    -- Load all the SFX into memory so we can call it when needed
    while index <= #audioDir.SFX do
      Kii.Audio.SFX[audioDir.SFX[index]] = love.audio.newSource("media/audio/sfx/"..audioDir.SFX[index]..".wav", "static")
      index = index + 1
    end
    print("SFX loaded!")
    print("Starting BGM loading...")
    index = 1
    while index <= #audioDir.BGM do
      Kii.Audio.BGM[audioDir.BGM[index]] = love.audio.newSource("media/audio/bgm/"..audioDir.BGM[index]..".mp3", "stream")
      index = index + 1
    end
    print("BGM loaded!")
  end,
  SFX = {},
  BGM = {}
}
Kii.Audio.loadAudio()
