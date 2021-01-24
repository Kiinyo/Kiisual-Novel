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
  if element.Text ~= "None" then
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
  local element = {
    _name = template._name or "Default Element Name",
    _type = template._type or "Box",
    _interactive = template._interactive or false,
    Dimensions = template.Dimensions or {_height = 100, _width = 300,
                                         _shape = "Right Iso Tri", _color = "Blue",
                                         _padding = 10, _alpha = 1},
    Position = template.Position or {_x = 0, _y = 0},
    Text = template.Text or {_text = "This is a default string",
                             _font = "Anime_Ace", _color = "White",
                             _alignX = "center", _alignY = "center"},
    Animation = template.Animation or {_type = "None", _frame = 0,
                                       _modifier = 1},
    Shader = template.Shader or {_type = "None", _frame = 0,
                                       _modifier = 1}
  }
  return element
end

Kii.Container = {}

function Kii.Container.create(template)
  template = template or {}

  local container = {
    _type = template._type or "Text Box",
    _shadow = template._shadow or true,
    Dimensions = template.Dimensions or {
      _height = 250, _width = 500
    },
    Position = template.Position or{
      _x = 100, _y = 100
    },
    Colors = template.Colors or {
      _primary = "White",
      _accent = "Red",
      _detail = "Black"
    },
    Header = template.Header or {
      _text = "Default Header", _font = "Anime_Ace"
    },
    Body = template.Body or {
      _text = "Just some generic body text", _font = "Anime_Ace"
    },
    Elements = template.Elements or {}
  }

  if container._type == "Text Box" then
    -- Find out if the texbox has a header
    if container.Header then
      -- If so create one based off of the textbox dimensions
      local header = Kii.Element.create({
        _name = "Text Box Header",
        Dimensions = {_height = math.floor(container.Dimensions._height / 8),
                      _width = math.floor(container.Dimensions._width / 3),
                      _shape = "Text Box Header", _color = container.Colors._accent,
                      _padding = 2, _alpha = 1},
        Position = {_x = container.Position._x + math.floor(container.Position._x / 16),
                    _y = container.Position._y - math.floor(container.Dimensions._height / 8) },
        Text = {_text = container.Header._text, _font = container.Header._font,
                _color = container.Colors._detail, _alignX = "left", _alignY = "center" }

      })

      table.insert(container.Elements, header)
    end
    -- Add the main body that holds the text
    local body = Kii.Element.create({
      _name = "Text Box Body",
      Dimensions = {
        _height = container.Dimensions._height,
        _width = container.Dimensions._width,
        _shape = "Box", _color = container.Colors._primary,
        _padding = 10, _alpha = 1
      },
      Position = container.Position,
      Text = {
        _text = container.Body._text, _font = container.Body._font,
        _color = container.Colors._detail, _alignX = "center", _alignY = "center" 
      }
    })
    table.insert(container.Elements, body)
    -- Pop in a shadow..
    if container._shadow then
      local shadow = Kii.Element.create({
        _name = "Text Box Shadow Side",
        Position = {_x = container.Position._x + container.Dimensions._width,
                    _y = container.Position._y + 10},
        Text = "None",
        Dimensions = {
          _height = container.Dimensions._height,
          _width = 10,
          _shape = "Box", _color = "Black",
          _padding = 0, _alpha = 1
        }
      })
      local shadow2 = Kii.Element.create({
        _name = "Text Box Shadow Bottom",
        Position = {_x = container.Position._x + 10,
                    _y = container.Position._y + container.Dimensions._height},
        Text = "None",
        Dimensions = {
          _height = 10,
          _width = container.Dimensions._width - 10,
          _shape = "Box", _color = "Black",
          _padding = 0, _alpha = 1
        }
      })
      table.insert(container.Elements, shadow)
      table.insert(container.Elements, shadow2)
    end
  elseif container._type == "Button" then
    local button = Kii.Element.create({
      _name = container._name or "Default Button",
      _type = container._type or "Button",
      _interactive = container._interactive or false,
      Dimensions = {
        _height = 50, _width = 150,
        _shape = "Obround", _color = "Red",
        _padding = 10, _alpha = 1
      },
      Text = template.Text or {
        _text = "I do nothing!!", _font = "Anime_Ace",
        _color = "Black", _alignX = "center", _alignY = "center"
      }
    })
    table.insert(container.Elements, button)
  end
  return container

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

Kii.Scene = {}

function Kii.Scene.create(template)
  template = template or {
    _type = "Main Menu"
  }

  local scene = template

  scene._mouseOver = nil
  scene._mouseDown = nil
  scene._mouseUp = nil
  scene.Containers = {}

  if scene._type == "Main Menu" then
    print("I got to the Main menu!")
    local container = Kii.Container.create({
      _name = "Quit Button",
      _type = "Button",
      _interactive = true,
      Text = {
        _text = "Quit!", _font = "Anime_Ace",
        _color = "Black", _alignX = "center", _alignY = "center"
      }
    })
    container.Elements[1].click = function(self)
      love.event.quit()
    end
    container.Elements[1].over = function(self)
      self.Animation._type = "Jitter"
      self.Shader._type = "Lighten"
      self.Shader._frame = 0
    end
    container.Elements[1].leave = function(self)
      self.Animation._type = "None"
      self.Shader._type = "None"
      self.Shader._frame = 0
    end
    table.insert(scene.Containers, container)

  end


  return scene

end

function Kii.Scene.findElement(scene, x, y)
  local cIndex = 1
  local eIndex = 1
  local returnValue = nil

  while (cIndex <= #scene.Containers and returnValue == nil) do
    while (eIndex <= #scene.Containers[cIndex].Elements and returnValue == nil) do
      if scene.Containers[cIndex].Elements[eIndex]._interactive ~= 999 then
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

function Kii.Scene.handleEvent(scene, event) -- down(), up(), click(), over(), leave(), abandon()
  if event[1] == "Mouse Down" then -- Calls down() on an element at x, y
    if event[2] == 1 then
      print("Mousedown works!")
      scene._mouseDown = Kii.Scene.findElement(scene, event[3], event[4])
      if scene._mouseDown ~= nil then
        if scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].down then
          scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].down(scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]])
        end
      end
    end
  elseif event[1] == "Mouse Up" then -- Calls click() if down = up, else down.abandon(), up.up()
    if event[2] == 1 then
      scene._mouseUp = Kii.Scene.findElement(scene, event[3], event[4])
      if scene._mouseUp ~= nil then
        if scene._mouseDown ~= nil then
          if scene._mouseUp[1] == scene._mouseDown[1]  and
             scene._mouseUp[2] == scene._mouseDown[2] then
            if scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].click then
              scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].click()
            end
          end
        else
          print("Mouseup works!")
          if scene.Containers[scene._mouseUp[1]].Elements[scene._mouseUp[2]].up then
            scene.Containers[scene._mouseUp[1]].Elements[scene._mouseUp[2]].up()
          end
        end
      end
      if scene._mouseDown ~= nil then
        print("Mouse abandon works!")
        if scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].abandon then
          scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]].abandon(scene.Containers[scene._mouseDown[1]].Elements[scene._mouseDown[2]])
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
            print("Mouse leave works!")
            if scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave then
              scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave(scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]])
            end
            print("Mouse over works!")
            if scene.Containers[placeholder[1]].Elements[placeholder[2]].over then
              scene.Containers[placeholder[1]].Elements[placeholder[2]].over(scene.Containers[placeholder[1]].Elements[placeholder[2]])
            end
        end
      else
        print("Mouse over works!")
        if scene.Containers[placeholder[1]].Elements[placeholder[2]].over then
          scene.Containers[placeholder[1]].Elements[placeholder[2]].over(scene.Containers[placeholder[1]].Elements[placeholder[2]])
        end
      end
    elseif scene._mouseOver ~= nil then
      print("Mouse leave works!")
      if scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave then
        scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]].leave(scene.Containers[scene._mouseOver[1]].Elements[scene._mouseOver[2]])
      end
    end
    scene._mouseOver = placeholder
  end
end


return Kii