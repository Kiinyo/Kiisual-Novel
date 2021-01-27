local Kii = {
  _version = "indev_0.0.1",
  _author = "Kathrine (Kiinyo) Lemet"
}
-- A list of math stuff I'm too lazy to look up
Kii.Math = {
  clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
  end,
  checkCollision = function(x, y, tX, tY, tW, tH)
    return (
      x >= tX and x <= tX + tW and
      y >= tY and y <= tY + tH
    )
  end,
  lerp = function (origin, target, time, float)
    if time == 0 then
      print("You tried to divide by zero!")
      return target
    end
    if float then
      return origin + ((target - origin) / time)
    end
    return math.floor(origin + ((target - origin) / time))
  end,
  ease = function (origin, target, time)
    return math.floor(origin + ((target - origin) / 2))
  end
}

Kii.Util = {
  parseText = function (texts)
    local index = 1
    local text = ""
    while index <= #texts do
      if texts[index]:sub(1, 1) == '"' then   
        text = text.."\n".."    "..texts[index]
      else
        text = text.."\n".."\n"..texts[index]
      end
      index = index + 1
    end
    return text
  end
}

-- All things related to actually rendering the game!
Kii.Render = {
  Fonts = {
    Anime_Ace = love.graphics.newFont("kii/media/anime-ace.regular.ttf", 18)
  },
  Palette = {
    Tauriel = { -- https://lospec.com/palette-list/tauriel-16
      Black  = { 023/255, 023/255, 028/255 },
      White  = { 220/255, 214/255, 207/255 },
      Red    = { 155/255, 053/255, 053/255 },
      Blue   = { 059/255, 083/255, 106/255 },
      Yellow = { 217/255, 189/255, 102/255 }
    }
  },
  setColor = function (color, alpha, palette)
    color = color or "Black"
    alpha = alpha or 1
    palette = palette or "Tauriel"
  
    love.graphics.setColor(Kii.Render.Palette[palette][color][1],
                           Kii.Render.Palette[palette][color][2],
                           Kii.Render.Palette[palette][color][3],
                           alpha)
  end,
  colorFind = function (color, palette)
    color = color or "Black"
    palette = palette or "Tauriel"
  
    return Kii.Render.Palette[palette][color][1],
           Kii.Render.Palette[palette][color][2],
           Kii.Render.Palette[palette][color][3]
  end,
  setFont = function (font)
    love.graphics.setFont(Kii.Render.Fonts[font])
  end,
  printText = function (text, x, y, width, height, alignx, aligny)

    local font = love.graphics.getFont()
    local pointless, wrappedText = font:getWrap(text, width)
    local fontHeight = font:getHeight()
  
    -- How many lines to draw
    local lines = math.min(math.floor(height/fontHeight), #wrappedText)
  
    -- Sort out alignment
    if aligny == "top" then
      y = y
    elseif aligny == "bottom" then
      y = y + height - lines * fontHeight
    elseif aligny == "center" then
      y = math.floor(y + (height - lines * fontHeight) / 2)
    end
    -- Establish a counter for line displacement
    local counter = 0
    while counter < lines do
      love.graphics.printf(table.remove(wrappedText,1),
                           x, y + counter * fontHeight,
                           width, alignx)
      counter = counter + 1
    end
  
    return wrappedText
  end,
  polygon = function (x, y, width, height, shape)
    local vertices = {}
    if shape == "Right Iso Tri" then -- looks like ▶
      vertices = {x, y,
                  x + width, y + math.floor(height / 2),
                  x, y + height}
      -- Placeholder
    elseif shape == "Text Box Header" then
      vertices = {x, y,
                  math.floor(x + width * (7/8)), y,
                  x + width, y + height,
                  x, y + height}
    elseif shape == "Shadow" then
      vertices = {x + width, y + 10,
                  x + width + 10, y + 10,
                  x + width + 10, y + 10 + height,
                  x + 10, y + 10 + height,
                  x + 10, y + height}
    elseif shape == "Rounded Box" then
      local e = 10
      -- Draw the top bar
      love.graphics.polygon('fill',
        x + e, y,
        x + width - e, y,
        x + width - e, y + e,
        x + e, y + e)
      -- Draw the bottom bar
      love.graphics.polygon('fill',
        x + e, y + height - e,
        x + width - e, y + height - e,
        x + width - e, y + height,
        x + e, y + height
      )
      -- Draw the main bar
      love.graphics.polygon('fill',
        x, y + e,
        x + width, y + e,
        x + width, y + height - e,
        x, y + height - e
      )
      -- NW arch
      love.graphics.arc("fill",
        x + e, y + e, 
        e, -3.1415, -3.1415 / 2, 10
      )
      -- NE arch
      love.graphics.arc("fill",
        x + width - e, y + e, 
        e, 0, -3.1415 / 2, 10
      )
      -- SE arch
      love.graphics.arc("fill",
        x + width - e, y + height - e, 
        e, 0, 3.1415 / 2, 10
      )
      -- SW arch
      love.graphics.arc("fill",
        x + e, y + height - e, 
        e, 3.1415, 3.1415 / 2, 10
      )
      shape = "None"
    elseif shape == "Obround" then
      local radius = math.floor(height / 2)
      -- Draw the rectangle
      love.graphics.polygon("fill",
        x + radius, y,
        x + width - radius, y,
        x + width - radius, y + height,  
        x + radius, y + height
      )
      -- Draw the left side arc
      love.graphics.arc("fill",
        x + radius, y + radius,
        radius, 3.1415 / 2, 3.1415 * 3/2,
        20
        )
      love.graphics.arc("fill",
        x + width - radius, y + radius,
        radius, -3.1415 / 2, 3.1415 / 2,
        20
      )
  
      shape = "None"
    else -- Defaults to box
      vertices =       {x, y,
                        x + width, y,
                        x + width, y + height,
                        x, y + height}
    end
    if shape ~= "None" then love.graphics.polygon('fill', vertices) end
  end,
  applyShaders = function (element)
    -- A bit of shenaniganery
    local r, g, b = Kii.Render.colorFind(element.Dimensions._color)
    local a = element.Dimensions._alpha
    -- Shaders
    if element.Shader._type == "Lighten" then
      -- Lighten animation!
      -- Lightens to white over 100 frames
      -- Modifier [0 - 1] determines how close to white
      local newR, newG, newB = Kii.Render.colorFind("White")
  
      r = Kii.Math.clamp(r + ((newR - r) * (element.Shader._frame / 100)) * element.Shader._modifier, r, newR)
      g = Kii.Math.clamp(g + ((newG - g) * (element.Shader._frame / 100)) * element.Shader._modifier, g, newG)
      b = Kii.Math.clamp(b + ((newB - b) * (element.Shader._frame / 100)) * element.Shader._modifier, b, newB)
  
      if element.Shader._frame < 100 then
        element.Shader._frame = element.Shader._frame + 1
      end
    elseif element.Shader._type == "Darken" then
      -- Darken animation!
      -- Darkens to black over 100 frames
      -- Modifier [0 - 1] determines how close to white
      local newR, newG, newB = Kii.Render.colorFind("Black")
  
      r = Kii.Math.clamp(r + ((newR - r) * (element.Shader._frame / 100)) * element.Shader._modifier, newR, r)
      g = Kii.Math.clamp(g + ((newG - g) * (element.Shader._frame / 100)) * element.Shader._modifier, newG, g)
      b = Kii.Math.clamp(b + ((newB - b) * (element.Shader._frame / 100)) * element.Shader._modifier, newB, b)
      if element.Shader._frame < 100 then
        element.Shader._frame = element.Shader._frame + 1
      end
    elseif element.Shader._type == "Fade In" then
      -- Fading in animation!
      -- Duration: 10 frames for full effect!
      -- Effect increases the alpha from 0% to 100%
      a = a * Kii.Math.clamp(0 + (1 * (element.Shader._frame / 100)), 0, 1) -- Alpha calculation
      -- Increment frame if it's less than 10!
      if element.Shader._frame < 100 then element.Shader._frame = element.Shader._frame + 1 end
    elseif element.Shader._type == "Fade Out" then
      -- Fading out animation!
      -- Duration: 10 frames for full effect!
      -- Effect decreases the Alpha from 100% to 0%
      a = a * Kii.Math.clamp(1 - (1 * (element.Shader._frame / 10)), 0, 1) -- Alpha calculation
      -- Increment frame if it's less than 10!
      if element.Shader._frame < 10 then element.Shader._frame = element.Shader._frame + 1 end
    end
  
    love.graphics.setColor(r, g, b, a)
  end,
  applyAnimations = function (element)
    local x = element.Position._x
    local y = element.Position._y
    local width = element.Dimensions._width
    local height = element.Dimensions._height
    if element.Animation._type == "Jitter" then
      x = math.floor(x + element.Animation._modifier * math.random() - element.Animation._modifier / 2)
      y = math.floor(y + element.Animation._modifier * math.random() - element.Animation._modifier / 2)
    elseif element.Animation._type == "Press" then
      y = y + element.Dimensions._height / 16
    end
    return x, y, width, height
  end,
  drawElement = function (element)
    -- First thing's first, let's set the colors
    Kii.Render.applyShaders(element)
    -- Now let's figure out where to draw it
    local x, y, width, height = Kii.Render.applyAnimations(element)
    Kii.Render.polygon(x, y, width, height, element.Dimensions._shape)
    -- Now render any applicable text on top!
    -- The fun part, we need to just get the current alpha
    local r, g, b, a = love.graphics.getColor()
    if element.Text._text ~= "@None" then
      Kii.Render.setColor(element.Text._color, a)
      Kii.Render.setFont(element.Text._font)
      -- Now we can render the text and be done!
      Kii.Render.printText(element.Text._text,
                           x + element.Dimensions._padding,
                           y + element.Dimensions._padding,
                           width - element.Dimensions._padding * 2,
                           height - element.Dimensions._padding * 2,
                           element.Text._alignX, element.Text._alignY)
    end
  
  end,
  drawContainer = function (container)
    local index = 1
    while index <= #container.Elements do
      Kii.Render.drawElement(container.Elements[index])
      index = index + 1
    end
  end,
  drawScene = function (scene)
    local index = 1
    while index <= #scene.Containers do
      Kii.Render.drawContainer(scene.Containers[index])
      index = index + 1
    end
  end
}

Kii.Audio = {
  SFX = {
    Generic = love.audio.newSource("kii/media/audio/sfx/Generic.wav", "static"),
    Generic_Male = love.audio.newSource("kii/media/audio/sfx/Generic_Male.wav", "static"),
    Generic_Female = love.audio.newSource("kii/media/audio/sfx/Generic_Female.wav", "static")
  },
  playSFX = function (sfx)
    Kii.Audio.SFX[sfx]:play()
  end
}

Kii.Element = {
  create = function (template)
    template = template or {}
    template.Dimensions = template.Dimensions or {}
    template.Position = template.Position or {}
    template.Text = template.Text or {}
    template.Animation = template.Animation or {}
    template.Shader = template.Shader or {}
    template.Actions = template.Actions or {}
  
    local element = {
      _name = template._name or "Default Element Name",
      _type = template._type or "Default Type",
      _interactive = template._interactive or false,
      Dimensions = {
        _relative = template.Dimensions._relative or "Both",
        _height = template.Dimensions._height or 1,
        _width = template.Dimensions._width or 1,
        _shape = template.Dimensions._shape or "Obround",
        _color = template.Dimensions._color or "Blue",
        _padding = template.Dimensions._padding or 10,
        _alpha = template.Dimensions._alpha or 1,
      },
      Position = { -- Becomes % of container width if adopted by a container
        _x = template.Position._x or 0,
        _y = template.Position._y or 0,
        _xOffset = template.Position._xOffset or nil,
        _yOffset = template.Position._yOffset or nil,
        _alignX = template.Position._alignX or "Left",
        _alignY = template.Position._alignY or "Up"
      },
      Text = {
        _text = template.Text._text or "This is a default string",
        _font = template.Text._font or "Anime_Ace",
        _color = template.Text._color or "White",
        _alignX = template.Text._alignX or "center",
        _alignY = template.Text._alignY or "center"
      },
      Animation = {
        _type = template.Animation._type or "None",
        _frame = template.Animation._frame or 0,
        _modifier = template.Animation._modifier or 1
      },
      Shader = {
        _type = template.Shader._type or "None",
        _frame = template.Shader._frame or 0, 
        _modifier = template.Shader._modifier or 1
      },
      Actions = {
        -- Mouse press the object
        down = template.Actions.down or "None",
        -- Mouse release on the object
        up = template.Actions.up or "None",
        -- Mouse press and release on the object
        click = template.Actions.click or "None",
        -- Mouse release not over the object after mouse press
        abandon = template.Actions.abandon or "None",
        -- Moving the mouse over the element
        over = template.Actions.over or "None",
        -- Moving the mouse away from the element
        leave = template.Actions.leave or "None"
      }
    }
  
    element.down = Kii.Element.Actions[element.Actions.down]
    element.up = Kii.Element.Actions[element.Actions.up]
    element.click = Kii.Element.Actions[element.Actions.click]
    element.abandon = Kii.Element.Actions[element.Actions.abandon]
    element.over = Kii.Element.Actions[element.Actions.over]
    element.leave = Kii.Element.Actions[element.Actions.leave]
  
    return element
  end
}

Kii.Element.Actions = {
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
        _height = 0.25,
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
        _height = 0.25,
        _width = 0.25
      },
      Position = {
        _y = -0.125,
        _alignX = "Center",
        _alignY = "Below"
      },
      Text = {
        _text = "Quit Game?",
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
        _text = "X"
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
    }
  }
}

Kii.Container = {
  create = function (template)
    template = template or {}
    template.Dimensions = template.Dimensions or {}
    template.Position = template.Position or {}
    template.Colors = template.Colors or {}
    template.Elements = template.Elements or {Kii.Elements.Default}
    template.Resize = template.Resize or {}
    template.Reposition = template.Reposition or {}
  
    local container = {
      _name = template._name or "Default Container",
      _type = template._type or "Default Container",
      _text = template._text or "Default container text",
      _elementIDs = template._elementIDs or 1,
      _id = template._id or nil,
      Dimensions = {
        _height = template.Dimensions._height or 100,
        _width = template.Dimensions._width or 300
      },
      Position = {
        _x = template.Position._x or 700,
        _y = template.Position._y or 500
      },
      Colors = {
        _primary = template.Colors._primary or "White",
        _accent = template.Colors._accent or "Red",
        _detail = template.Colors._detail or "Black",
        _speaker = template.Colors._speaker or "White",
      },
      Resize = {
        _type = template.Resize._type or "None",
        _frame = template.Resize._frame or 0,
        _targetWidth = template.Resize._targetWidth or 0,
        _targetHeight = template.Resize._targetHeight or 0
      },
      Reposition = {
        _type = template.Reposition._type or "None",
        _frame = template.Reposition._frame or 0,
        _targetX = template.Reposition._targetX or 0,
        _targetY = template.Reposition._targetY or 0
      },
      Elements = {}
    }
  
    local index = 1
    local element = nil
    while index <= #template.Elements do
      element = Kii.Element.create(template.Elements[index])
      Kii.Container.addElement(container, element)
      index = index + 1
    end
    return container
  end,
  removeElement = function (container, element)

  end,
  addElement = function (container, element)
    container._elementIDs = container._elementIDs + 1
    element._id = container._elementIDs
    Kii.Container.formatElement(container, element)
    table.insert(container.Elements, element)
    return container._elementIDs
  end,
  formatElement = function (container, element)
    local xOffset = element.Position._xOffset or math.floor(container.Dimensions._width * element.Position._x)
    local yOffset = element.Position._yOffset or math.floor(container.Dimensions._height * element.Position._y)
    element._relativeX = element.Position._x
    element._relativeY = element.Position._y
    element._relativeWidth = element.Dimensions._width
    element._relativeHeight = element.Dimensions._height
  
    -- Width adjustment
    if element.Dimensions._relative == "Width" or element.Dimensions._relative == "Both" then
      element.Dimensions._width = math.floor(element.Dimensions._width * container.Dimensions._width)
    end
    -- Height adjustment
    if element.Dimensions._relative == "Height" or element.Dimensions._relative == "Both" then
      element.Dimensions._height = math.floor(element.Dimensions._height * container.Dimensions._height)
    end
    -- X alignment
    if element.Position._alignX ~= "Free" or element.Position._alignX ~= "Resized" then
      if element.Position._alignX == "Left" then
        element.Position._x = container.Position._x + 
          xOffset -- Offset
      elseif element.Position._alignX == "Right" then
        element.Position._x = container.Position._x + container.Dimensions._width
          - element.Dimensions._width +
          xOffset -- Offset
      elseif element.Position._alignX == "Before" then
        element.Position._x = container.Position._x - element.Dimensions._width + 
          xOffset -- Offset
      elseif element.Position._alignX == "After" then
        element.Position._x = container.Position._x + container.Dimensions._width + 
          xOffset -- Offset
      elseif element.Position._alignX == "Center" then -- Centered
        element.Position._x = container.Position._x + math.floor( container.Dimensions._width / 2)
          - math.floor(element.Dimensions._width / 2) + 
          xOffset -- Offset
      end
    end
    -- Y alignment
    if element.Position._alignY ~= "Free" or element.Position._alignY ~= "Resized" then
      if element.Position._alignY == "Up" then
        element.Position._y = container.Position._y + 
          yOffset  -- Offset
      elseif element.Position._alignY == "Down" then
        element.Position._y = container.Position._y + container.Dimensions._height
          - element.Dimensions._height +
          yOffset  -- Offset
      elseif element.Position._alignY == "Above" then
        element.Position._y = container.Position._y - element.Dimensions._height + 
          yOffset  -- Offset
      elseif element.Position._alignY == "Below" then
        element.Position._y = container.Position._y + container.Dimensions._height + 
          yOffset  -- Offset
      else -- Centered
        element.Position._y = container.Position._y + math.floor( container.Dimensions._height / 2)
          - math.floor(element.Dimensions._height / 2) + 
          yOffset  -- Offset
      end
    end
    -- Coloring Body
    if element.Dimensions._color == "Primary" then
      element.Dimensions._color = container.Colors._primary
    elseif element.Dimensions._color == "Accent" then
      element.Dimensions._color = container.Colors._accent
    elseif element.Dimensions._color == "Detail" then
      element.Dimensions._color = container.Colors._detail
    end
    -- Coloring Text
    if element.Text._color == "Primary" then
      element.Text._color = container.Colors._primary
    elseif element.Text._color == "Accent" then
      element.Text._color = container.Colors._accent
    elseif element.Text._color == "Detail" then
      element.Text._color = container.Colors._detail
    end
    -- Heading configurations
    if element._type == "Header" then
      element.Text._text = container._name
    elseif element._type == "Body" then
      element.Text._text = container._text
    end
  end,
  updateElements = function (container)
    local index = 1
    while index <= #container.Elements do
      if container.Elements[index]._type == "Header" then
        container.Elements[index].Text._text = container._name
        container.Elements[index].Text._color = container.Colors._speaker
      elseif container.Elements[index]._type == "Body" then
        container.Elements[index].Text._text = container._text
      end
      index = index + 1
    end
  end,

  -- Flags container for deletion after time
  selfDestruct = function (container, time, type)
    container._countdown = time or 0
    if type == "Fade Out" then
      container._fadeout = true
    end
  end,

  update = function (container)
    Kii.Container.resize(container)
    Kii.Container.reposition(container)
    Kii.Container.updateElements(container)

    if container._countdown ~= nil then
      if container._countdown <= 0 then
        container._deleteMe = true
      else
        if container._fadeout then
          local index = 1
          while index <= #container.Elements do
            container.Elements[index].Dimensions._alpha = Kii.Math.lerp(
              container.Elements[index].Dimensions._alpha,
              0,
              container._countdown,
              true
            )
            index = index + 1
          end
        end
        container._countdown = container._countdown - 1
      end
    end
    
  end,

  -- Place the container at x, y
  setPosition = function (container, x, y)
    local xDis = container.Position._x - x
    local yDis = container.Position._y - y
  
    local index = 1
    while index <= #container.Elements do
      container.Elements[index].Position._x = container.Elements[index].Position._x - xDis
      container.Elements[index].Position._y = container.Elements[index].Position._y - yDis
      index = index + 1
    end
    container.Position._x = x
    container.Position._y = y
  end,
  -- Translation function animation
  reposition = function (container)
    if container.Reposition._type ~= "None" then
      if container.Reposition._frame <= 0 then
        -- Make sure the animation is finished
        Kii.Container.setPosition(
          container,
          container.Reposition._targetX,
          container.Reposition._targetY
        )
        container.Reposition = {
          _type = "None",
          _frame = 0,
          _targetX = container.Position._x,
          _targetY = container.Position._y
        }
      else
        local tween = "lerp"
        if container.Reposition._type == "Linear" then
          tween = 'lerp'
        elseif container.Reposition._type == "Ease" then
          tween = 'ease'
        end

        Kii.Container.setPosition(
          container,
          Kii.Math[tween](
            container.Position._x,
            container.Reposition._targetX,
            container.Reposition._frame
          ),
          Kii.Math[tween](
            container.Position._y,
            container.Reposition._targetY,
            container.Reposition._frame
          )
        )

        container.Reposition._frame = container.Reposition._frame - 1
      end
    end
  end,
  -- Ordering the actual animation
  move = function (container, x, y, time, type)
    container.Reposition._type = type or "Linear"
    container.Reposition._targetX = x or 0
    container.Reposition._targetY = y or 0
    container.Reposition._frame = time or 10
  end,

  -- Set the container's width and height
  setDimensions = function (container, width, height)
    container.Dimensions._width = width
    container.Dimensions._height =  height
  
    local index = 1
    while index <= #container.Elements do
      -- To Do: There's a bug here if the x, y, width, and height aren't relative i think?
      container.Elements[index].Position._x = container.Elements[index]._relativeX
      container.Elements[index].Position._y = container.Elements[index]._relativeY
      container.Elements[index].Dimensions._width = container.Elements[index]._relativeWidth
      container.Elements[index].Dimensions._height = container.Elements[index]._relativeHeight
  
  
      Kii.Container.formatElement(container, container.Elements[index])
      index = index + 1
    end
  end,
  -- Scaling function animation
  resize = function (container)
    if container.Resize._type ~= "None" then
      if container.Resize._frame <= 0 then
        -- Make sure the animation is finished
        Kii.Container.setDimensions(
          container,
          container.Resize._targetWidth,
          container.Resize._targetHeight
        )
        container.Resize = {
          _type = "None",
          _frame = 0,
          _targetWidth = container.Dimensions._width,
          _targetHeight = container.Dimensions._height
        }
      else
        local tween = "lerp"
        if container.Resize._type == "Linear" then
          tween = 'lerp'
        end

        Kii.Container.setDimensions(
          container,
          Kii.Math[tween](
            container.Dimensions._width,
            container.Resize._targetWidth,
            container.Resize._frame
          ),
          Kii.Math[tween](
            container.Dimensions._height,
            container.Resize._targetHeight,
            container.Resize._frame
          )
        )

        container.Resize._frame = container.Resize._frame - 1

      end
    end
  end,
  -- Ordering the actual animation
  scale = function (container, width, height, time, type)
    container.Resize._type = type or "Linear"
    container.Resize._targetWidth = width or 100
    container.Resize._targetHeight = height or 100
    container.Resize._frame = time or 10
  end
}

Kii.Containers = {
  Debug = {
    _name = "Debug Container",
    _type = "Text Box",
    _text = "Just some debug stuffs",
    Position = {_x = 100, _y = 100},
    Dimensions = {
      _height = 500,
      _width = 500
    },
    Colors = {
      _primary = "White",
      _accent = "Blue",
      _detail = "Black"
    },
    Elements = {
      Kii.Elements.Debug.Shadow,
      Kii.Elements.Debug.Body,
      Kii.Elements.Debug.Header
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
  },
  Backgrounds = {
    SimpleRed = {
      _name = "Simple Background",
      _type = "Background",
      Position = {
        _x = 0,
        _y = 0
      },
      Dimensions = {
        _height = 720,
        _width = 1280
      },
      Colors = {
        _primary = "Red"
      },
      Elements = {
        Kii.Elements.Simple.Box
      }
    },
    SimpleYellow = {
      _name = "Simple Background",
      _type = "Background",
      Position = {
        _x = 0,
        _y = 0
      },
      Dimensions = {
        _height = 720,
        _width = 1280
      },
      Colors = {
        _primary = "Yellow"
      },
      Elements = {
        Kii.Elements.Simple.Box
      }
    },
  }
}

Kii.Scene = {
  create = function (template)
    template = template or {}
    template.Containers = template.Containers or {Kii.Containers.Debug}
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
        Sprites = template.Visual.Sprites or {}
      },
      Containers = {},
      Flags = {},

    }
  
    local index = 1
    local container = nil
  
    while index <= #template.Containers do
      container = Kii.Container.create(template.Containers[index])
      Kii.Scene.addContainer(scene, container)
      index = index + 1
    end
  
    Kii.Script.lookUp(scene.Script._current, scene.Script._index, scene)
  
    return scene
  
  end,
  displayHistory = function (scene)

  end,
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
  advance = function (scene)
    scene.Script._index = scene.Script._index + 1
    Kii.Script.lookUp(scene.Script._current, scene.Script._index, scene)
  end,
  goTo = function (scene, script, index)
    scene.Script._index = index
    scene.Script._current = script
    Kii.Script.lookUp(script, index, scene)
  end,
  playVoice = function (scene)
    if scene.Audio._voice ~= nil then Kii.Audio.playSFX(scene.Audio._voice)end
  end,
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
  addContainer = function (scene, container, position)
    scene._id = scene._id + 1
    container._id = scene._id + 0
    if container._type == "Text Box" then 
      scene.Text._textBox = container._id
      position = position or #scene.Containers + 1
    elseif container._type == "Background" then
      scene.Visual._bg = container._id
      position = position or 1
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
  addFlag = function (scene, flag, contents)
    scene.Flags[flag] = contents
  end,
  removeFlag = function (scene, flag)
    local contents = scene.Flags[flag]
    scene.Flags[flag] = nil
    return contents
  end,
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
  removeContainer = function (scene, ID)
    if ID == scene.Text._textBox then
      scene.Text._textBox = nil
    end
    table.remove(scene.Containers, Kii.Scene.findIndex(scene, ID))
  end,
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
        if scene._pause == nil then
          local hisCon = Kii.Container.create(Kii.Containers.Simple.History)
          scene._pause = "History"
          hisCon._text = Kii.Util.parseText(scene.History.Log)

          Kii.Container.updateElements(hisCon)

          Kii.Scene.addFlag(scene, "History", Kii.Scene.addContainer(scene, hisCon, #scene.Containers + 1))

        elseif scene._pause == "History" then
          scene._pause = nil
          Kii.Scene.removeContainer(scene, Kii.Scene.removeFlag(scene, "History"))
        end
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
            Kii.Scene.advance(scene)
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
  addToHistory = function (scene, text)
    table.insert(scene.History.Log, text)
    if #scene.History.Log > scene.History._length then
      table.remove(scene.History.Log, 1)
    end
  end,
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
  changeSpeaker = function (scene, text, voice, color)
    voice = voice or nil
    color = color or "Blue"
    if text ~= "" then Kii.Scene.addToHistory(scene, text..":") end
    if scene.Text._textBox ~= nil then
      local index = Kii.Scene.findIndex(scene, scene.Text._textBox)
      scene.Containers[index]._name = text
      scene.Containers[index].Colors._speaker = color
      scene.Audio._voice = voice
    end
  end
}

Kii.Script = {
  Characters = {
    Kiinyo = {
      _color = "White",
      _voice = "Generic_Female"
    },
    Alistair = {
      _color = "Red",
      _voice = "Generic_Male"
    },
    System = {
      _color = "Black",
      _voice = "Generic"
    },
    None = {
      _color = "White",
      _voice = "Generic"
    }
  },
  lookUp = function (script, index, scene)
    Kii.Scripts[script][index](scene)
    Kii.Scene.update(scene)
  end
}

K = {
  -- (n)ext frame
  n = function (s)
    Kii.Scene.advance(s)
  end,
  -- Shorthand to (c)hange (s)peaker
  cs = function (s, Speaker, text, style)
    Kii.Scene.changeSpeaker(
      s,
      Speaker,
      Kii.Script.Characters[Speaker]._voice,
      Kii.Script.Characters[Speaker]._color
    )
    if text then K.nl(s, text, style) else
      Kii.Scene.advance(s)
    end
  end,
  -- Shorthand for (n)ew (l)ine
  nl = function (s, text, style)
    style = style or nil
    Kii.Scene.changeText(s, text, style)
  end,
  -- Shorthand to (g)o (t)o line
  gt = function (s, script, line)
    Kii.Scene.goTo(s, script, line)
  end,
  -- Shorthand to (s)et (B)ack(G)round
  sBG = function (s, BG, animation, time)
    BG = Kii.Container.create(Kii.Containers.Backgrounds[BG])

    if s.Visual._bg then
      if animation then
        if animation == "Fade In" then
          time = time or 100
          Kii.Container.selfDestruct(
            s.Containers[Kii.Scene.findIndex(s, s.Visual._bg)], 
            time,
            "Fade Out"
          )
        end
      else
        Kii.Scene.removeContainer(s, s.Visual._bg)
        Kii.Scene.addContainer(s, BG)
      end
    end

    Kii.Scene.addContainer(s, BG)

  end,
  -- (p)osition (T)ext(B)ox
  pTB = function (s, x, y, time, type)
    Kii.Container.move(s.Containers[Kii.Scene.findIndex(s, s.Text._textBox)], x, y, time, type)
  end,
  -- (s)cale (T)ext(B)ox
  sTB = function (s, width, height, time, type)
    Kii.Container.scale(s.Containers[Kii.Scene.findIndex(s, s.Text._textBox)], width, height, time, type)
  end

}

Kii.Scripts = {
  Debug = {
    function (s) K.cs(s,"System", "NOW ENTERING KIINYO'S VN TECH DEMO", "None") end,
    function (s) K.cs(s,"Kiinyo", "Hello, is this thing on?") end,
    function (s) K.nl(s,"Oh hey, it works!" ) end,
    function (s) K.nl(s,"Hey there, it's very nice to meet you!" ) end,
    function (s) K.nl(s,"I'm super glad I finally got this working!" ) end,
    function (s) K.nl(s,"Although before we get started, let's fix this awful text box!" ) end,
    function (s) K.pTB(s, 40, 450, 20) K.sTB(s, 1200, 200, 20) K.n(s) end,
    function (s) K.cs(s,"System", "Clackety Clack", "Action") end,
    function (s) K.cs(s,"Kiinyo", "There we go!") end,
    function (s) K.nl(s, "And the lights, I can't see a thing!") end,
    function (s) K.sBG(s, "SimpleRed") K.n(s) end,
    function (s) K.cs(s,"System", "Click", "Action") end,
    function (s) K.cs(s,"Kiinyo", "Hmmmm, it's a start but I don't like this color..") end,
    function (s) K.sBG(s, "SimpleYellow", "Fade In") K.n(s) end,
    function (s) K.cs(s,"System", "Whooosh", "Action") end,
    function (s) K.cs(s,"Kiinyo", "Much better!") end,
    function (s) K.gt(s,"Debug", 1) end
  }
}

return Kii