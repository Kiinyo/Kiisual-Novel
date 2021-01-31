
Kii.Scene = {
    -- Creates a new scene and sets a bunch of defaults, returns a Scene
    create = function (template)
      template = template or {}
      template.Containers = template.Containers or {"Debug"}
      template.Script = template.Script or {}
      template.Text = template.Text or {}
      template.Audio = template.Audio or {}
      template.History = template.History or {}
      template.Visual = template.Visual or {}
    
      local scene = {
        _mouseOver = template._mouseOver or nil,
        _mouseDown = template._mouseDown or nil,
        _mouseUp = template._mouseUp or nil,
        _pause = template._pause or nil,
        _id = template._id or 1, -- Gives every container an ID
        History = {
          _length = template.History._length or 15, -- How many lines back the history can remember
          Log = template.History.Log or {}
        },
        Script = {
          _current = template.Script._current or "Debug",
          _index = template.Script._index or 1
        },
        Text = {
          _speaker = template.Text._speaker or "Default Speaker",
          _text = template.Text._text or "Default Text",
          _frame = template.Text._frame or 0,
          _textBox = nil
        },
        Audio = {
          _voice = template.Audio._voice or nil, -- " voice " in airquotes, it's the SFX made during dialogue
          _bgm = template.Audio._bgm or nil -- " self explanitory"
        },
        Visual = {
          _bg = template.Visual._bg or nil,
          Sprites = template.Visual.Sprites or {},
        },
        Containers = {},
        Flags = {},
  
      }
        local index = 1
      local container = nil
    
      while index <= #template.Containers do
        container = Kii.Container.create(Kii.Containers[template.Containers[index]])
        Kii.Scene.addContainer(scene, container)
        index = index + 1
      end
    
      K.ePge(scene, scene.Script._current, scene.Script._index)
    
      return scene
    
    end,
    getSprite = function (s, spriteName)
      return s.Containers[Kii.Scene.findIndex(s, s.Visual.Sprites[spriteName])]
    end,
    addSprite = function (scene, sprite, animation, length)
      length = length or 25
  
      Kii.Container.enterAnimation(sprite, animation, length)
  
      scene.Visual.Sprites[sprite._name] = Kii.Scene.addContainer(scene, sprite)
      return scene.Visual.Sprites[sprite._name]
    end,
    removeSprite = function (scene, spriteName)
      Kii.Scene.removeContainer(scene, scene.Visual.Sprites[spriteName])
    end,
    -- Updates everything in a scene
    update = function (scene)
      if scene._pause == nil then
        -- Text handling
        if scene.Text._textBox ~= nil then
          local index = Kii.Scene.findIndex(scene, scene.Text._textBox)
          if scene.Text._frame < string.len(scene.Text._text) then
            Kii.Scene.playVoice(scene)
            scene.Text._frame = scene.Text._frame + 1
            scene.Containers[index]._text = string.sub(scene.Text._text, 0, scene.Text._frame)
          end
        end
        -- Container Animations
        local index = 1
        while index <= #scene.Containers do
  
          Kii.Container.update(scene.Containers[index])
  
          if scene.Containers[index]._deleteMe then
              Kii.Scene.removeContainer(scene, scene.Containers[index]._id)
          end
  
          index = index + 1
        end
  
      end
    end,
    -- Playes a character's voice
    playVoice = function (scene)
      if scene.Audio._voice ~= nil then scene.Audio._voice:play() end
    end,
    -- Given an x and y coordinate, returns the element if interactive
    findElement = function (scene, x, y)
      local cIndex = 1
      local eIndex = 1
      local returnValue = nil
    
      while (cIndex <= #scene.Containers and returnValue == nil) do
        while (eIndex <= #scene.Containers[cIndex].Elements and returnValue == nil) do
          if scene.Containers[cIndex].Elements[eIndex]._interactive ~= false then
            if Kii.Math.checkCollision(x, y,
              scene.Containers[cIndex].Elements[eIndex].Position._x,
              scene.Containers[cIndex].Elements[eIndex].Position._y,
              scene.Containers[cIndex].Elements[eIndex].Dimensions._width,
              scene.Containers[cIndex].Elements[eIndex].Dimensions._height)
            then
              returnValue = {cIndex + 0, eIndex + 0}
            end
    
          end
          eIndex = eIndex + 1
        end
        eIndex = 1
        cIndex = cIndex + 1
      end
    
      return returnValue
    end,
    -- Adds a container to the scene and returns its _id
    addContainer = function (scene, container, position)
      scene._id = scene._id + 1
      container._id = scene._id + 0
      if container._type == "Text Box" then 
        scene.Text._textBox = container._id
        position = position or #scene.Containers + 1
      elseif container._type == "Background" then
        if scene.Visual._bg ~= nil then
          position = position or 2
        else
          position = position or 1
        end
        scene.Visual._bg = container._id
      else
        if scene.Text._textBox then
          position = position or #scene.Containers
        else
          position = position or #scene.Containers + 1
        end
      end
  
      table.insert(scene.Containers, position, container)
      return container._id
    end,
    -- Adds a flag to the scene containing anything
    addFlag = function (scene, flag, contents)
      scene.Flags[flag] = contents
    end,
    -- Removes a flag from the scene and returns its contents
    removeFlag = function (scene, flag)
      local contents = scene.Flags[flag]
      scene.Flags[flag] = nil
      return contents
    end,
    -- Gets the current position of a container with a given ID in scene.Containers
    findIndex = function (scene, ID)
      local indexA = 1
  
      while true do
        if indexA > #scene.Containers then
          indexA = nil
          break
        end      
        if scene.Containers[indexA]._id == ID then
          break
        end
        indexA = indexA + 1
      end
  
      return indexA
  
    end,
    -- Removes a container based on its _id
    removeContainer = function (scene, ID)
      local index = Kii.Scene.findIndex(scene, ID)
      if ID == scene.Text._textBox then
        scene.Text._textBox = nil
      elseif scene.Containers[index]._type == "Sprite" then
        scene.Visual.Sprites[scene.Containers[index]._name] = nil
      end
      table.remove(scene.Containers, index)
    end,
    -- Toggles whether or not the history is displayed
    toggleHistory = function (scene)
      if scene._pause == nil then
        local hisCon = Kii.Container.create(Kii.Containers.Simple_History)
        scene._pause = "History"
        hisCon._text = Kii.Util.parseText(scene.History.Log)
  
        Kii.Container.updateElements(hisCon)
  
        Kii.Scene.addFlag(scene, "History", Kii.Scene.addContainer(scene, hisCon, #scene.Containers + 1))
  
      elseif scene._pause == "History" then
        scene._pause = nil
        Kii.Scene.removeContainer(scene, Kii.Scene.removeFlag(scene, "History"))
      end
    end,
    -- Handles user input,
    handleEvent = function (scene, event) -- down(), up(), click(), over(), leave(), abandon()
      if event[1] == "Mouse Down" then -- Calls down() on an element at x, y
        if event[2] == 1 then
          scene._mouseDown = Kii.Scene.findElement(scene, event[3], event[4])
          if scene._mouseDown ~= nil then
            scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].down(
              scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]],
              scene.Containers[scene._mouseDown[1]],
              scene)
          end
        elseif event[2] == 2 then
          Kii.Scene.toggleHistory(scene)
        end
      elseif event[1] == "Mouse Up" then -- Calls click() if down = up, else down.abandon(), up.up()
        if event[2] == 1 then
          scene._mouseUp = Kii.Scene.findElement(scene, event[3], event[4])
          if scene._mouseUp ~= nil then
            if scene._mouseDown ~= nil then
              if scene._mouseUp[1] == scene._mouseDown[1] and
                 scene._mouseUp[2] == scene._mouseDown[2] then
                scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].click(
                  scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]],
                  scene.Containers[scene._mouseDown[1]],
                  scene)
              else 
                scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].abandon(
                  scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]],
                  scene.Containers[scene._mouseDown[1]],
                  scene)
              end
            else
              scene.Containers[scene._mouseUp[1]].Elements[scene._mouseUp[2]].up(
                scene.Containers[scene._mouseUp[1]].Elements[scene._mouseUp[2]],
                scene.Containers[scene._mouseUp[1]],
                scene)
            end
          elseif scene._mouseDown ~= nil then
            scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].abandon(
              scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]],
              scene.Containers[scene._mouseDown[1]],
              scene)
          elseif scene._pause == nil then
            if scene.Text._frame < string.len(scene.Text._text) then
              scene.Text._frame = string.len(scene.Text._text) - 1
            else
              K.sPge(scene)
            end
          end
          scene._mouseDown = nil
          scene._mouseUp = nil
        end
      elseif event[1] == "Mouse Move" then -- if oldMove ~= newMove then oldMove.leave(), newMove.over()
        local placeholder = Kii.Scene.findElement(scene, event[2], event[3])
        if placeholder ~= nil then
          if scene._mouseOver ~= nil then
            if placeholder[1] ~= scene._mouseOver[1] and
               placeholder[2] ~= scene._mouseOver[2] then
                scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave(
                  scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]],
                  scene.Containers[scene._mouseOver[1]])
                scene.Containers[placeholder[1]].Elements[placeholder[2]].over(
                  scene.Containers[placeholder[1]].Elements[placeholder[2]],
                  scene.Containers[placeholder[1]],
                  scene)
            end
          else
            scene.Containers[placeholder[1]].Elements[placeholder[2]].over(
              scene.Containers[placeholder[1]].Elements[placeholder[2]],
              scene.Containers[placeholder[1]],
              scene)
          end
        elseif scene._mouseOver ~= nil then
          scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave(
            scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]],
            scene.Containers[scene._mouseOver[1]],
            scene)
        end
        scene._mouseOver = placeholder
      end
    end,
    -- Used for logging text currently displayed to the player
    addToHistory = function (scene, text)
      table.insert(scene.History.Log, text)
      if #scene.History.Log > scene.History._length then
        table.remove(scene.History.Log, 1)
      end
    end,
    -- Changes the text to be displayed by the textBox
    changeText = function (scene, text, style)
      style = style or "Spoken"
      if style == "Spoken" then
        text = '"'..text..'"'
      elseif style == "Action" then
        text = "*"..text.."*"
      else
        -- Placeholder
      end
      Kii.Scene.addToHistory(scene,text)
      scene.Text._text = text
      scene.Text._frame = 0
    end,
    -- Changes the current speaker of the text (changes textBox header)
    changeSpeaker = function (scene, text, voice, color)
      voice = voice or nil
      color = color or "Blue"
      if text ~= "" then Kii.Scene.addToHistory(scene, text..":") end
      if scene.Text._textBox ~= nil then
        local index = Kii.Scene.findIndex(scene, scene.Text._textBox)
        scene.Containers[index]._name = text
        scene.Containers[index].Colors._speaker = color
        if voice then 
          scene.Audio._voice = love.audio.newSource("media/audio/sfx/"..voice, "static")
        else 
          scene.Audio._voice = nil
        end
      end
    end
  }