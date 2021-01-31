Kii = {
  _version = "indev_0.0.1",
  _author = "Kathrine (Kiinyo) Lemet"
}
require "kii/math"
require "kii/util"
require "kii/render"
require "kii/element"

Kii.Element.Actions = {
  FancyPress = function (self, container, scene)
    if K.gFlg(scene, "Presses") == nil then
      K.sFlg(scene, "Presses", 1)
      container._text = "You've clicked my button 1 time!"
    elseif K.gFlg(scene, "Presses") == 1 then
      K.sFlg(scene, "Presses", 2)
      container._text = "You've clicked my button twice now!"
    elseif K.gFlg(scene, "Presses") > 1 and K.gFlg(scene, "Presses") < 10 then
      K.sFlg(scene, "Presses", K.gFlg(scene, "Presses") + 1)
      container._text = tostring(K.gFlg(scene, "Presses")).." times now."
    else
      container._text = "There's more of the demo left you know..."
    end

  end,
  FancyWarn = function (self, container, scene)
    self.Animation._type = "Slide Down"
    self.Animation._modifier = 10
    if scene.Script._index < 60 then
      K.sPge(scene, "Debug", 61)
    end
  end,
  FancyJoke = function (self, container, scene)
    self.Shader._type = "None"
    self.Shader._modifier = 1
    self.Shader._frame = 0
    K.sPge(scene, "Debug", 64)
  end,
  Glow = function (self, container, scene)
    self.Shader._type = "Lighten"
    self.Shader._frame = 0
    self.Shader._modifier = 0.5
  end,
  SlideRight = function (self, container, scene)
    self.Animation._type = "Slide Right"
    self.Animation._modifier = 10
  end,
  ReturnRight = function (self, container, scene)
    self.Animation._type = "Return Right"
  end,
  SlideDown = function (self, container, scene)
    self.Animation._type = "Slide Down"
    self.Animation._modifier = 10
  end,
  ReturnDown = function (self, container, scene)
    self.Animation._type = "Return Down"
  end,
  FancyDeleteContainer = function (self, container, scene)
    Kii.Element.Actions.DeleteContainer(self, container, scene)
    K.sPge(scene, "Debug", 66)
  end,
  QuitGame = function (self, container, scene)
    love.event.quit()
  end,
  None = function (self, container, scene)
    -- Nothing here!
  end,
  Excite = function (self, container, scene)
    self.Animation._type = "Jitter"
    self.Shader._type = "Lighten"
    self.Shader._frame = 0
    self.Shader._modifier = 0.5
  end,
  Press = function (self, container, scene)
    self.Animation._type = "Press"
    self.Animation._frame = 0
  end,
  Reset = function (self, container, scene)
    self.Animation._type = "None"
    self.Shader._type = "None"
    self.Shader._modifier = 1
    self.Shader._frame = 0
    self.Animation._modifier = 1
    self.Animation._frame = 0
  end,
  DeleteContainer = function (self, container, scene)
    scene._mouseOver = nil
    scene._mouseDown = nil
    scene._mouseUp = nil
    Kii.Scene.removeContainer(scene, container._id)
  end
}

Kii.Elements = {
  Debug = {
    Shadow = {
      _name = "Debug Shadow",
      _type = "Shadow",
      Dimensions = {
        _shape = "Box",
        _color = "Detail",
        _padding = 0,
        _alpha = 0.5
      },
      Position = {
        _xOffset = 20,
        _yOffset = 20,
        _x = 0.0625,
        _y = 0.0625,
      },
      Text = {
        _text = "@None"
      }
    },
    Body = {
      _name = "Debug Body",
      _type = "Body",
      Dimensions = {
        _shape = "Box",
        _padding = 40,
        _color = "Primary"
      },
      Text = {
        _text = "This shouldn't matter...",
        _color = "Detail"
      }
    },
    Header = {
      _name = "Debug Header",
      _type = "Header",
      Dimensions = {
        _relative = "Width",
        _height = 50,
        _width = 0.25,
        _shape = "Text Box Header",
        _color = "Accent",
        _padding = 15
      },
      Position = {
        _x = 0.03125,
        _alignY = "Above"
      },
      Text = {
        _text = "I shouldn't see this anyway",
        _color = "Detail",
        _alignX = "left"
      }
    },
    ExitButton = {
      _name = "Debug ExitButton",
      _type = "Button",
      _interactive = true,
      Dimensions = {
        _color = "Red",
        _relative = "Width",
        _height = 50,
        _width = 0.25
      },
      Position = {
        _y = -0.125,
        _alignX = "Center",
        _alignY = "Below"
      },
      Text = {
        _text = "Quit Demo?",
        _color = "Black"
      },
      Actions = {
        down = "Press",
        up = "Reset",
        click = "QuitGame",
        abandon = "Reset",
        over = "Excite",
        leave = "Reset",
      }
    },
    CloseContainerButton = {
      _name = "Debug CloseContainerButton",
      _type = "Button",
      _interactive = true,
      Dimensions = {
        _relative = "Neither",
        _height = 40,
        _width = 40,
        _shape = "Rounded Box",
        _color = "Red"
      },
      Position = {
        _xOffset = -20,
        _yOffset = 20,
        _alignX = "Right",
        _alignY = "Up"
      },
      Text = {
        _text = "@None"
      },
      Actions = {
        down = "Press",
        up = "Reset",
        click = "DeleteContainer",
        abandon = "Reset",
        over = "Excite",
        leave = "Reset",
      }
    }
  },
  Fancy = {
    Shadow = {
      _name = "Fancy Shadow",
      _type = "Shadow",
      Dimensions = {
        _color = "Black",
        _shape = "Fancy Body"
      },
      Position = {
        _xOffset = 20,
        _yOffset = 20,
        _x = 0.0625,
        _y = 0.0625,
      },
      Text = {
        _text = "@None"
      }
    },
    Decoration = {
      _name = "Fancy Decoration",
      _type = "Decoration",
      Dimensions = {
        _padding = 30,
        _shape = "Fancy Decoration",
        _color = "Primary",
        _width = 1/4,
        _height = 1/2
      },
      Position = {
        _alignX = "Center",
        _alignY = "Down",
        _x = 5/16
      },
      Text = {
        _text = "@None",
        _color = "Black"
      }
    },
    Body = {
      _name = "Fancy Body",
      _type = "Body",
      Dimensions = {
        _padding = 30,
        _shape = "Fancy Body",
        _color = "Primary"
      },
      Text = {
        _color = "Black"
      }
    },
    Header = {
      _name = "Fancy Header",
      _type = "Header",
      Dimensions = {
        _width = 3/8,
        _height = 1/4,
        _shape = "Fancy Header",
        _color = "Accent"
      },
      Position = {
        _x = 1/16,
        _y = 1/16
      }
    },
    CloseButton = {
      _name = "Fancy Close Button",
      _type = "Button",
      _interactive = true,
      Dimensions = {
        _height = 1/2,
        _width = 1/8,
        _shape = "Fancy Box",
        _color = "Red"
      },
      Position = {
        _alignX = "Right",
        _alignY = "Center",
      },
      Text = {
        _text = "@None",
        _color = "Black"
      },
      Actions = {
        down = "Glow",
        up = "None",
        click = "FancyDeleteContainer",
        abandon = "Reset",
        over = "SlideRight",
        leave = "ReturnRight",
      }
    },
    Button1 = {
      _name = "Fancy Button 1",
      _type = "Button",
      _interactive = true,
      Dimensions = {
        _width = 7/32,
        _height = 1/4,
        _shape = "Fancy Box",
        _color = "Blue"
      },
      Position = {
        _x = 5/32,
        _alignX = "Left",
        _alignY = "Down",
      },
      Text = {
        _text = "\nClick Me!"
      },
      Actions = {
        down = "Glow",
        up = "None",
        click = "FancyPress",
        abandon = "Reset",
        over = "SlideDown",
        leave = "ReturnDown",
      }
    },
    Button2 = {
      _name = "Fancy Button 2",
      _type = "Button",
      _interactive = true,
      Dimensions = {
        _width = 7/32,
        _height = 1/4,
        _shape = "Fancy Box",
        _color = "Blue"
      },
      Position = {
        _x = 13/32,
        _alignX = "Left",
        _alignY = "Down",
      },
      Text = {
        _text = "\nDon't Click Me!"
      },
      Actions = {
        down = "Glow",
        up = "None",
        click = "FancyJoke",
        abandon = "Reset",
        over = "FancyWarn",
        leave = "ReturnDown",
      }
    }


  },
  Simple = {
    Box = {
      _name = "Simple Box",
      _type = "Simple",
      Dimensions = {
        _shape = "Box",
        _color = "Primary"
      },
      Text = {
        _text = "@None"
      }
    },
    History = {
      _name = "Simple History Box",
      _type = "Body",
      Dimensions = {
        _padding = 20,
        _shape = "Rounded Box",
        _alpha = 0.75,
        _color = "Primary"
      },
      Text = {
        _text = "@None",
        _alignX = "left"
      }
    },
    Image = {
      _name = "Simple Image",
      _type = "Image",
      Dimensions = {
        _color = "Clear",
        _shape = "FavoriteAlbum"
      },
      Position = {
        _alignX = "Right"
      },
      Text = {
        _text = "@None"
      }
    }
  }
}

require "kii/container"

Kii.Containers = {
  Debug = {
    _name = "Debug Container",
    _type = "Text Box",
    _text = "Just some debug stuffs",
    Position = {_x = 40, _y = 500},
    Dimensions = {
      _height = 150,
      _width = 1200
    },
    Colors = {
      _primary = "White",
      _accent = "Blue",
      _detail = "Black"
    },
    Elements = {
      Kii.Elements.Debug.Shadow,
      Kii.Elements.Debug.Body,
      Kii.Elements.Debug.Header,
      Kii.Elements.Debug.ExitButton
    }
  },
  Fancy = {
    _name = "Fancy Box",
    _type = "Fancy Box",
    _text = "Graphic Design is my passion",
    Position = {
      _x = 190,
      _y = 100
    },
    Dimensions = {
      _height = 300,
      _width = 900
    },
    Elements = {
      Kii.Elements.Fancy.Shadow,
      Kii.Elements.Fancy.Decoration,
      Kii.Elements.Fancy.CloseButton,
      Kii.Elements.Fancy.Button1,
      Kii.Elements.Fancy.Button2,
      Kii.Elements.Fancy.Body,
      Kii.Elements.Fancy.Header
    }
  },
  Simple = {
    History = {
      _name = "Simple History",
      _type = "Body",
      Dimensions = {
        _height = 640,
        _width = 640
      },
      Position = {
        _x = 320,
        _y = 40
      },
      Colors = {
        _primary = "Black",
        _detail = "White"
      },
      Elements = {
        Kii.Elements.Simple.History
      }
    }
  }
}

require "kii/scene"
require "kii/sprite"

Kii.Characters = require "script/characters"

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
    chapter = require("script/chapters/"..chapter)

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
  eSfx = function (scene, soundEffect, looping)
    local looping = looping or false
    soundEffect = love.audio.newSource("media/audio/sfx/"..soundEffect, "stream")
    soundEffect:setLooping(looping)
    soundEffect:play()
  end,

  -- Executes a specified bgm
  eBgm = function (scene, track, looping)
    local looping = looping or false
    track = love.audio.newSource("media/audio/bgm/"..track, "stream")
    track:setLooping(looping)
    track:play()
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

    return Kii.Scene.addContainer(scene, container)

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