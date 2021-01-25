local Kii = {
  _version = "indev_0.0.1",
  _author = "Kathrine (Kiinyo) Lemet"
}
-- A list of math stuff I'm too lazy to look up
Kii.Math = {}
-- Clamps values for a variety of reasons
function Kii.Math.clamp(value, min, max)
  local value = math.min(math.max(value, min), max)
  return value
end
-- Simple point colission detection
function Kii.Math.checkCollision(x, y, tX, tY, tW, tH)
  return (
    x >= tX and x <= tX + tW and
    y >= tY and y <= tY + tH
  )
end

-- All things related to actually rendering the game!
Kii.Render = {
  Fonts = {
    Anime_Ace = love.graphics.newFont("kii/media/anime-ace.regular.ttf")
  },
  Palette = {
    Tauriel = { -- https://lospec.com/palette-list/tauriel-16
      Black  = { 023/255, 023/255, 028/255 },
      White  = { 220/255, 214/255, 207/255 },
      Red    = { 155/255, 053/255, 053/255 },
      Blue   = { 059/255, 083/255, 106/255 },
      Yellow = { 217/255, 189/255, 102/255 }
    }
  }
}
-- Takes in a "Color" and transparancy and sets things accordingly
function Kii.Render.setColor(color, alpha, palette)
  color = color or "Black"
  alpha = alpha or 1
  palette = palette or "Tauriel"

  love.graphics.setColor(Kii.Render.Palette[palette][color][1],
                         Kii.Render.Palette[palette][color][2],
                         Kii.Render.Palette[palette][color][3],
                         alpha)
end
-- Returns the correct color code
function Kii.Render.colorFind(color, palette)
  color = color or "Black"
  palette = palette or "Tauriel"

  return Kii.Render.Palette[palette][color][1],
         Kii.Render.Palette[palette][color][2],
         Kii.Render.Palette[palette][color][3]
end
-- Takes in a string argument for the "Font"!
function Kii.Render.setFont(font)
  love.graphics.setFont(Kii.Render.Fonts[font])
end
-- Prints a string inside a defined area, returns any text clipped
function Kii.Render.printText(text, x, y, width, height, alignx, aligny)

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
end
-- Draws complex shapes!
function Kii.Render.polygon(x, y, width, height, shape)
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
end
-- Handles animating color and transparancy changes to elements
function Kii.Render.applyShaders(element)
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
end
-- Handles animating physical changes to elements
function Kii.Render.applyAnimations(element)
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
end
-- Handles drawing Elements!
function Kii.Render.drawElement(element)
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

end
-- Handles drawing Containers
function Kii.Render.drawContainer(container)
  local index = 1
  while index <= #container.Elements do
    Kii.Render.drawElement(container.Elements[index])
    index = index + 1
  end
end
-- Handles drawing Scenes
function Kii.Render.drawScene(scene)
  local index = 1
  while index <= #scene.Containers do
    Kii.Render.drawContainer(scene.Containers[index])
    index = index + 1
  end
end


Kii.Element = {}

function Kii.Element.create(template)
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
      down = template.Actions.down or "DebugDown",
      -- Mouse release on the object
      up = template.Actions.up or "DebugUp",
      -- Mouse press and release on the object
      click = template.Actions.click or "DebugClick",
      -- Mouse release not over the object after mouse press
      abandon = template.Actions.abandon or "DebugAbandon",
      -- Moving the mouse over the element
      over = template.Actions.over or "DebugOver",
      -- Moving the mouse away from the element
      leave = template.Actions.leave or "DebugLeave"
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
  DebugDown = function (self, container, scene)
    print("DebugDown")
  end,
  DebugUp = function (self, container, scene)
    print("DebugUp")
  end,
  DebugClick = function (self, container, scene)
    print("DebugClick")
  end,
  DebugAbandon = function (self, container, scene)
    print("DebugAbandon")
  end,
  DebugOver = function (self, container, scene)
    print("DebugOver")
  end,
  DebugLeave = function (self, container, scene)
    print("DebugLeave")
  end,
  DeleteContainer = function (self, container, scene)
    scene._mouseOver = nil
    scene._mouseDown = nil
    scene._mouseUp = nil
    Kii.Scene.removeContainer(scene, container._name)
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
        _height = 0.125,
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
  }
}

Kii.Container = {}

function Kii.Container.create(template)
  template = template or {}
  template.Dimensions = template.Dimensions or {}
  template.Position = template.Position or {}
  template.Colors = template.Colors or {}
  template.Elements = template.Elements or {Kii.Elements.Default}

  local container = {
    _name = template._name or "Default Container",
    _type = template._type or "Default Container",
    _text = template._text or "Default container text",
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
      _detail = template.Colors._detail or "Black"
    },
    Elements = {}
  }

  local index = 1
  local element = nil
  while index <= #template.Elements do
    element = Kii.Element.create(template.Elements[index])
    Kii.Container.formatElement(element, container)
    table.insert(container.Elements, element)
    index = index + 1
  end
  return container
end

function Kii.Container.formatElement(element, container)
  local xOffset = element.Position._yOffset or math.floor(container.Dimensions._width * element.Position._x)
  local yOffset = element.Position._yOffset or math.floor(container.Dimensions._height * element.Position._y)
  -- Width adjustment
  if element.Dimensions._relative == "Width" or element.Dimensions._relative == "Both" then
    print(element._name)
    xOffset = math.floor(container.Dimensions._width * element.Position._x) 
    element.Dimensions._width = math.floor(element.Dimensions._width * container.Dimensions._width)
  end
  -- Height adjustment
  if element.Dimensions._relative == "Height" or element.Dimensions._relative == "Both" then
    element.Dimensions._height = math.floor(element.Dimensions._height * container.Dimensions._height)
  end
  -- X alignment
  if element.Position._alignX ~= "Free" then
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
  if element.Position._alignY ~= "Free" then
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
end

function Kii.Container.updateElements(container)
  local index = 1
  while index <= #container.Elements do
    if container.Elements[index]._type == "Header" then
      container.Elements[index].Text._text = container._name
    elseif container.Elements[index]._type == "Body" then
      container.Elements[index].Text._text = container._text
    end
  end
end


-- Allows for moving of a container with all its elements!
function Kii.Container.translate(container, x, y)
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
end

Kii.Containers = {
  Debug = {
    _name = "Debug Container",
    _type = "Debug Container",
    Position = {_x = 100, _y = 100},
    Dimensions = {
      _height = 500,
      _width = 1000
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
      Kii.Elements.Debug.ExitButton,
      Kii.Elements.Debug.CloseContainerButton,
    }
  }
}

Kii.Scene = {}

function Kii.Scene.create(template)
  template = template or {}
  template.Containers = template.Containers or {Kii.Containers.Debug}

  local scene = {
    _mouseOver = template._mouseOver or nil,
    _mouseDown = template._mouseDown or nil,
    _mouseUp = template._mouseUp or nil,
    Containers = {}
  }

  local index = 1
  local container = nil

  while index <= #template.Containers do
    container = Kii.Container.create(template.Containers[index])
    table.insert(scene.Containers, container)
    index = index + 1
  end

  return scene

end

function Kii.Scene.findElement(scene, x, y)
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
end

function Kii.Scene.addContainer(scene, container)
  table.insert(scene.Containers,container)
end

function Kii.Scene.removeContainer(scene, containerName)
  local cIndex = 1
  while cIndex <= #scene.Containers do
    if scene.Containers[cIndex]._name == containerName then
      table.remove(scene.Containers, cIndex)
    end
  end
end

function Kii.Scene.handleEvent(scene, event) -- down(), up(), click(), over(), leave(), abandon()
  if event[1] == "Mouse Down" then -- Calls down() on an element at x, y
    if event[2] == 1 then
      scene._mouseDown = Kii.Scene.findElement(scene, event[3], event[4])
      if scene._mouseDown ~= nil then
        scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].down(
          scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]],
          scene.Containers[scene._mouseDown[1]],
          scene)
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
end

Kii.Script = {}

return Kii