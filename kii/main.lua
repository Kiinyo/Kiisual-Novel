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
-- Returns the correct color
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

  else -- Defaults to box
    vertices =       {x, y,
                      x + width, y,
                      x + width, y + height,
                      x, y + height}
  end
  love.graphics.polygon('fill', vertices)
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

function Kii.Render.drawContainer(container)
  local index = 1
  while index <= #container.Elements do
    Kii.Render.drawElement(container.Elements[index])
    index = index + 1
  end
end

Kii.Element = {}

function Kii.Element.create(template)
  template = template or {}
  local element = {
    _name = template._name or "Default Element Name",
    _type = template._type or "Box",
    _interactive = false,
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
  template = template or {
    _type = "Text Box",
    _shadow = true,
    Dimensions = {
      _height = 250, _width = 500
    },
    Position = {
      _x = 100, _y = 100
    },
    Colors = {
      _primary = "White",
      _accent = "Red",
      _detail = "Black"
    },
    Header = {
      _text = "Default Header", _font = "Anime_Ace"
    },
    Body = {
      _text = "Just some generic body text", _font = "Anime_Ace"
    },
    Elements = {}
  }

  local container = template

  if template._type == "Text Box" then
    -- Find out if the texbox has a header
    if template.Header then
      -- If so create one based off of the textbox dimensions
      local header = Kii.Element.create({
        _name = "Text Box Header",
        Dimensions = {_height = math.floor(template.Dimensions._height / 8),
                      _width = math.floor(template.Dimensions._width / 3),
                      _shape = "Text Box Header", _color = template.Colors._accent,
                      _padding = 2, _alpha = 1},
        Position = {_x = template.Position._x + math.floor(template.Position._x / 16),
                    _y = template.Position._y - math.floor(template.Dimensions._height / 8) },
        Text = {_text = template.Header._text, _font = template.Header._font,
                _color = template.Colors._detail, _alignX = "left", _alignY = "center" }
        
      })

      table.insert(container.Elements, header)
    end
    -- Add the main body that holds the text
    local body = Kii.Element.create({
      _name = "Text Box Body",
      Dimensions = {
        _height = template.Dimensions._height, 
        _width = template.Dimensions._width,
        _shape = "Box", _color = template.Colors._primary,
        _padding = 10, _alpha = 1
      },
      Position = template.Position,
      Text = {
        _text = template.Body._text, _font = template.Body._font,
        _color = template.Colors._detail, _alignX = "center", _alignY = "center" 
      }
    })
    table.insert(container.Elements, body)
    -- Pop in a shadow..
    if template._shadow then
      local shadow = Kii.Element.create({
        _name = "Text Box Shadow Side",
        Position = {_x = template.Position._x + template.Dimensions._width,
                    _y = template.Position._y + 10},
        Text = "None",
        Dimensions = {
          _height = template.Dimensions._height,
          _width = 10,
          _shape = "Box", _color = "Black",
          _padding = 0, _alpha = 1
        }
      })
      local shadow2 = Kii.Element.create({
        _name = "Text Box Shadow Bottom",
        Position = {_x = template.Position._x + 10,
                    _y = template.Position._y + template.Dimensions._height},
        Text = "None",
        Dimensions = {
          _height = 10,
          _width = template.Dimensions._width - 10,
          _shape = "Box", _color = "Black",
          _padding = 0, _alpha = 1
        }
      })
      table.insert(container.Elements, shadow)
      table.insert(container.Elements, shadow2)
    end
  end

  return container

end

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

return Kii