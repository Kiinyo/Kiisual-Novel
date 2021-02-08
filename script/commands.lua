K = {
    -- a (add)
    -- r (remove)
    
    -- g (get)
    -- s (set)
    -- c (check)
  
    -- m (move)
    -- t (transform)
  
    -- e (execute)
  
    -- Executes the indicated page
    -- If no arguments are given, executes the scene's current page
    ePge = function (scene, chapter, page)
      chapter = chapter or scene.Script._current
      chapter = require("script/story/"..chapter)
  
      page = page or scene.Script._index
  
      chapter[page](scene)
      Kii.Scene.update(scene)
    end,
    -- Sets the scene's current page and executes
    -- If no arguments are given, goes to the next page
    sPge = function (scene, chapter, page, dontExecute)
      scene.Script._current = chapter or scene.Script._current
      scene.Script._index = page or scene.Script._index + 1
  
      if dontExecute == nil then
        K.ePge(scene)
      end
    end,
  
    -- Sets the Scene's current text
    -- Returns the Scene's previous text
    sTxt = function (scene, text, style)
      local previousText = scene.Text._text
      Kii.Scene.changeText(scene, text, style)
      return previousText
    end,
  
    -- Gets the Scene's current Speaker
    -- Returns the Scene's Speaker's {name, color, voice}
    gSpk = function (scene)
      local index = K.gTbx(scene)
  
      return {
        scene.Containers[index]._name,
        scene.Containers[index].Colors._speaker,
        scene.Audio._voice
      }
  
    end,
    -- Sets the Scene's current speaker
    -- Returns the Scene's previous speaker's {name, color, voice}
    sSpk = function (scene, speaker, text, style)
      -- Prepping the previous speaker
      local previousSpeaker = K.gTbx(scene)
      if previousSpeaker then
        previousSpeaker = K.gSpk(scene)
      end
      -- Changing the speaker
      Kii.Scene.changeSpeaker(
        scene,
        Kii.Characters[speaker]._name,
        Kii.Characters[speaker]._voice,
        Kii.Characters[speaker]._color      
      )
      -- Writing the new line if one exists!
      if text then
        K.sTxt(scene, text, style)
      end
  
      return previousSpeaker
    end,
  
    -- Gets the index of the current Text Box
    -- returns index of Text Box in scene.Containers
    gTbx = function (scene)
      return Kii.Scene.findIndex(scene, scene.Text._textBox)
    end,
   -- Moves
    mTbx = function (scene, x, y, duration)
      duration = duration or 20
      Kii.Container.move(scene.Containers[K.gTbx(scene)], x, y, duration)
    end,
  
    tTbx = function (scene, width, height, duration)
      duration = duration or 20
      Kii.Container.scale(scene.Containers[K.gTbx(scene)], width, height, duration)
    end,
  
    -- Executes a specified sound effect
    eSfx = function (scene, soundEffect)
      soundEffect = love.audio.newSource("media/audio/sfx/"..soundEffect, "stream")
      soundEffect:setLooping(false)
      soundEffect:play()
    end,
  
    -- Sets the current BGM
    sBgm = function (scene, track, looping, dontPlay)
      looping = looping or false
      local oldSource = K.gFlg(scene, "BGM")
      K.sFlg(scene, "BGM", track)
  
      if oldSource ~= track then
  
        if scene.Audio._bgm then love.audio.stop(scene.Audio._bgm) end
  
        scene.Audio._bgm = love.audio.newSource("media/audio/bgm/"..track, "stream")
        scene.Audio._bgm:setLooping(looping)
  
        if dontPlay then else scene.Audio._bgm:play() end
  
      else
        -- Do nothing!
      end
    end,
  
    -- Checks if the Scene currently has a background
    gBga = function (scene)
      return scene.Visual._bg
    end,
    -- Sets the current Background while removing the old one
    sBga = function (scene, Background, animation, duration)
      duration = duration or 0
      Background = Kii.Container.create({
        _name = Background.." Background",
        _type = "Background",
        _text = "@None",
        Dimensions = {
          _height = love.graphics.getHeight(),
          _width = love.graphics.getWidth()
        },
        Position = {
          _x = 0,
          _y = 0
        },
        Elements = {
          {
            _name = Background.."Background Image",
            _type = "Image",
            Dimensions = {
              _color = "Clear",
              _shape = love.graphics.newImage("media/visual/bgs/"..Background..".png")
            },
            Text = {
              _text = "@None"
            }
          }
        }
      })
      
      if K.gBga(scene) then
        Kii.Container.selfDestruct(
          scene.Containers[Kii.Scene.findIndex(scene, scene.Visual._bg)],
          duration
        )
      end
  
      Kii.Container.enterAnimation(Background, animation, duration)
  
      Kii.Scene.addContainer(scene, Background)
    end,
  
    -- Adds a Character to the scene
    -- Returns the ID of the Character's sprite
    aSpr = function (scene, Character, Emotion, position, animation, duration, variant)
      local character = Kii.Characters[Character].Sprite
      variant = variant or "Default"
      local sprite = Kii.Sprite.create(character, variant, Emotion, position)
  
      return Kii.Scene.addSprite(scene, sprite, animation, duration)
    end,
    -- Removes a Character from the scene
    rSpr = function (scene, character, animation, length)
      character = Kii.Characters[character].Sprite
      Kii.Container.selfDestruct(
        scene.Containers[Kii.Scene.findIndex(scene, scene.Visual.Sprites[character])],
        length,
        animation
      )
    end,
    -- Set a Character's Animation and Shaders and Emotions
    -- If type is omitted, animation becomes emotion
    sCha = function (scene, character, animation, scale, type)
      character = Kii.Characters[character].Sprite
  
      if type == "Shader" then
        Kii.Container.setShader(
          Kii.Scene.getSprite(scene, character),
          animation,
          scale
        )
      elseif type == "Animation" then
        Kii.Container.animate(
          Kii.Scene.getSprite(scene, character),
          animation,
          scale
        )
      else
        Kii.Sprite.changeExpression(Kii.Scene.getSprite(scene, character), animation)
      end
    end,
    -- Moves a Character in the scene to the designated coordinates
    -- Can nil x and y coordinates to maintain them
    -- Returns {oldX, oldY}
    mCha = function (scene, character, x, y, duration, raw)
      character = Kii.Characters[character].Sprite
      local oldX = Kii.Scene.getSprite(scene, character).Position._x
      local oldY = Kii.Scene.getSprite(scene, character).Position._y
  
      if x ~= nil then
        if raw then
        else
          x = x - Kii.Scene.getSprite(scene, character).Resize._targetWidth / 2
        end
        else
        x = oldX
      end
  
      if y ~= nil then
        if raw then
        else
          y = y - Kii.Scene.getSprite(scene, character).Resize._targetHeight / 2
        end
        else
        y = oldY
      end
  
      duration = duration or 30
  
      Kii.Container.move(
        Kii.Scene.getSprite(scene, character),
        x, y, duration
      )
  
      return {oldX, oldY}
    end,
    -- Transforms a Character in the scene
    tSpr = function (scene, character, type, magnitude, duration)
      character = Kii.Characters[character].Sprite
  
      if type == "Zoom" then
        Kii.Container.zoom(Kii.Scene.getSprite(scene, character), magnitude, duration)
      elseif type == "Flip" then
        Kii.Container.flip(Kii.Scene.getSprite(scene, character), duration)
      end
    end,
  
    aCon = function (scene, container, x, y, animation, duration)
      container = Kii.Container.create(Kii.Containers[container])
      x = x or container.Position._x
      y = y or container.Position._y
  
      Kii.Container.setPosition(container, x, y, true)
  
      K.sFlg(scene, container, Kii.Scene.addContainer(scene, container))
  
    end,

    rCon = function (scene, container, animation, duration)
      Kii.Scene.removeContainer(scene, K.sFlg(scene, container, nil))
    end,

    tCon = function (scene, container, type, magnitude, duration)
      container = K.gFlg(scene, container)
  
      if type == "Zoom" then
        Kii.Container.zoom(scene.Containers[Kii.Scene.findIndex(scene, container)], magnitude, duration)
      elseif type == "Flip" then
        Kii.Container.flip(scene.Containers[Kii.Scene.findIndex(scene, container)], duration)
      end
    end,

    mCon = function (scene, container, x, y, duration, raw)
      container = K.gFlg(scene, container)
      local oldX = scene.Containers[Kii.Scene.findIndex(scene, container)].Position._x
      local oldY = scene.Containers[Kii.Scene.findIndex(scene, container)].Position._y
  
      if x ~= nil then
        if raw then
        else
          x = x - scene.Containers[Kii.Scene.findIndex(scene, container)].Resize._targetWidth / 2
        end
        else
        x = oldX
      end
  
      if y ~= nil then
        if raw then
        else
          y = y - scene.Containers[Kii.Scene.findIndex(scene, container)].Resize._targetHeight / 2
        end
        else
        y = oldY
      end
  
      duration = duration or 30
  
      Kii.Container.move(
        scene.Containers[Kii.Scene.findIndex(scene, container)],
        x, y, duration
      )
  
      return {oldX, oldY}
    end,
    -- Adds a bookmark to be returned to by a later call
    aBmk = function (scene, bookmarkName)
      K.sFlg(scene, bookmarkName, {scene.Script._current, scene.Script._index})
    end,
    -- Goes to and executes the bookmark
    eBmk = function (scene, bookmarkName)
      local bookmark = K.gFlg(scene, bookmarkName)
      if bookmark then
        K.sPge(scene, bookmark[1], bookmark[2])
      end
    end,
  
    -- Sets a Flag for the Scene
    -- If no contents given, clears flag
    -- Returns any previous contents of the flag
    sFlg = function (scene, flag, contents)
      local previousContents = scene.Flags[flag]
      scene.Flags[flag] = contents
      return previousContents
    end,
    -- Checks if a Flag exists
    -- Returns the contents of the flag
    gFlg = function (scene, flag)
      return scene.Flags[flag]
    end,
  
  }