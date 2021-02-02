
-- All things related to actually rendering the game!
Kii.Render = {
    Palette = require "ui/palette",
    Shapes = require "ui/shapes",
    -- Takes in a color name and sets the color to be drawn next
    setColor = function (color, alpha, palette)
      color = color or "Black"
      alpha = alpha or 1
      palette = palette or "Default"
    
      love.graphics.setColor(Kii.Render.Palette[palette][color][1],
                             Kii.Render.Palette[palette][color][2],
                             Kii.Render.Palette[palette][color][3],
                             alpha)
    end,
    -- Returns, R, G, B of color given
    colorFind = function (color, palette)
      color = color or "Black"
      palette = palette or "Default"
    
      return Kii.Render.Palette[palette][color][1],
             Kii.Render.Palette[palette][color][2],
             Kii.Render.Palette[palette][color][3]
    end,
    -- Sets the font
    setFont = function (font, size)
      size = size or 18
      love.graphics.setNewFont("media/visual/fonts/"..font..".ttf", size)
    end,
    -- Draws text on screen and returns any leftover text
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
    -- Renders a polygon
    polygon = function (x, y, width, height, shape, wiggly)
      -- First find out if there even is something to draw
      if Kii.Render.Shapes[shape] then
        -- Set up our variables
        local vertices = {}
        local index = 1
        local pointX = 0
        local pointY = 0
        -- Generate all the points and add them to the grid
        while index <= #Kii.Render.Shapes[shape] do
          -- Define the points to be drawn
          pointX = Kii.Render.Shapes[shape][index][1] * width + x
          pointY = Kii.Render.Shapes[shape][index][2] * height + y
          -- Add the wiggle if needed
          if wiggly then
            if math.random(1, 3) == 3 then
              pointX = pointX + math.random(-3, 3)
              pointY = pointY + math.random(-3, 3)
            end
          end
          -- Add the points to the vertices
          table.insert(vertices, pointX)
          table.insert(vertices, pointY)
          -- Finally increment the counter
          index = index + 1
        end
        -- Finally draw the object based on the generated points.
        love.graphics.polygon('fill', vertices)
      end
    end,
    -- Preps the draw function's colors
    applyShaders = function (element)
      -- A bit of shenaniganery
      local r, g, b = Kii.Render.colorFind(element.Dimensions._color, element.Dimensions._palette)
      local a = element.Dimensions._alpha
      -- Shaders
      if element.Shader._type == "Fade To" then
        local newR, newG, newB = Kii.Render.colorFind(element.Shader._target)
    
        r = Kii.Math.clamp(r + ((newR - r) * (element.Shader._frame / element.Shader._modifier)), r, newR)
        g = Kii.Math.clamp(g + ((newG - g) * (element.Shader._frame / element.Shader._modifier)), g, newG)
        b = Kii.Math.clamp(b + ((newB - b) * (element.Shader._frame / element.Shader._modifier)), b, newB)
    
        if element.Shader._frame < element._modifier then
          element.Shader._frame = element.Shader._frame + 1
        else
          element.Dimensions._color = element.Shader._target
          element.Shader._frame = 0
          element.Shader._modifier = 1
          element.Shader._type = "None"
          element.Shader._target = "None"
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
        -- Duration: _modifier frames for full effect!
        -- Effect increases the alpha from 0% to 100%
        a = a * Kii.Math.clamp(0 + (1 * (element.Shader._frame / element.Shader._modifier )), 0, 1) -- Alpha calculation
        -- Increment frame if it's less than 10!
        if element.Shader._frame < element.Shader._modifier then element.Shader._frame = element.Shader._frame + 1
        else
          element.Shader._type = "None"
        end
      elseif element.Shader._type == "Fade Out" then
        -- Fading out animation!
        -- Duration: 10 frames for full effect!
        -- Effect decreases the Alpha from 100% to 0%
        a = a * Kii.Math.clamp(1 - (1 * (element.Shader._frame / element.Shader._modifier)), 0, 1) -- Alpha calculation
        -- Increment frame if it's less than 10!
        if element.Shader._frame < element.Shader._modifier then element.Shader._frame = element.Shader._frame + 1
        else
          element._deleteMe = true
        end
      elseif element.Shader._type == "Lighten" then
        -- Change color animation!
        -- Lightens to white over 100 frames
        -- Modifier [0 - 1] determines how close to white
        local newR, newG, newB = Kii.Render.colorFind("White")
    
        r = Kii.Math.clamp(r + ((newR - r) * (element.Shader._frame / 100)) * element.Shader._modifier, r, newR)
        g = Kii.Math.clamp(g + ((newG - g) * (element.Shader._frame / 100)) * element.Shader._modifier, g, newG)
        b = Kii.Math.clamp(b + ((newB - b) * (element.Shader._frame / 100)) * element.Shader._modifier, b, newB)
    
        if element.Shader._frame < 100 then
          element.Shader._frame = element.Shader._frame + 1
        end
      end
    
      love.graphics.setColor(r, g, b, a)
    end,
    -- Preps the draw functions coords
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
      elseif element.Animation._type == "Slide Right" then
        x = x + element.Animation._frame
        if element.Animation._frame < element.Animation._modifier then
          element.Animation._frame = element.Animation._frame + 1
        end
      elseif element.Animation._type == "Press Right" then
        x = x + 10
      elseif element.Animation._type == "Return Right" then
        x = x + element.Animation._frame
        if element.Animation._frame <= 0 then
          element.Animation._frame = 0
          element.Animation._modifier = 1
          element.Animation._type = "None"
        else
          element.Animation._frame = element.Animation._frame - 1
        end
  
      elseif element.Animation._type == "Slide Down" then
        y = y + element.Animation._frame
        if element.Animation._frame < element.Animation._modifier then
          element.Animation._frame = element.Animation._frame + 1
        end
      elseif element.Animation._type == "Return Down" then
        y = y + element.Animation._frame
        if element.Animation._frame <= 0 then
          element.Animation._frame = 0
          element.Animation._modifier = 1
          element.Animation._type = "None"
        else
          element.Animation._frame = element.Animation._frame - 1
        end
      end
      return x, y, width, height
    end,
    -- Draw an image at x, y, while also maintaining aspect ratio if needed
    drawImage = function (image, x, y, width, height, aspectRatio)
      width = width or image:getWidth()
      height = height or image:getHeight()
  
      if aspectRatio then
        -- Figure out which is the largest
        sW = math.min(math.abs(width / image:getWidth()), math.abs(height / image:getHeight()))
        sH = sW * Kii.Math.sign(height)
        sW = sW * Kii.Math.sign(width)
        -- Then alter the x and y to center its location
        x = math.floor(x + ((width - (image:getWidth() * sW)) / 2))
        y = math.floor(y + ((height - (image:getHeight() * sH)) / 2))
      else
        sW = width / image:getWidth()
        sH = height / image:getHeight()
      end
        
      love.graphics.draw(image, x, y, 0, sW, sH)
    end,
    -- Simple enough
    drawElement = function (element)
      -- First thing's first, let's set the colors
      Kii.Render.applyShaders(element)
      -- Now let's figure out where to draw it
      local x, y, width, height = Kii.Render.applyAnimations(element)
  
      if element._type == "Image" then 
        Kii.Render.drawImage(element.Dimensions._shape, x, y, width, height, true)
      else
        local jitter = false
        Kii.Render.polygon(x, y, width, height, element.Dimensions._shape)
      end
      -- Now render any applicable text on top!
      -- The fun part, we need to just get the current alpha
      local r, g, b, a = love.graphics.getColor()
      if element.Text._text ~= "@None" then
        Kii.Render.setColor(element.Text._color, a, element.Dimensions._palette)
        Kii.Render.setFont(element.Text._font, element.Text._size)
        -- Now we can render the text and be done!
        Kii.Render.printText(element.Text._text,
                             x + element.Dimensions._padding,
                             y + element.Dimensions._padding,
                             width - element.Dimensions._padding * 2,
                             height - element.Dimensions._padding * 2,
                             element.Text._alignX, element.Text._alignY)
      end
    
    end,
    -- Simple enough
    drawContainer = function (container)
      local index = 1
      while index <= #container.Elements do
        Kii.Render.drawElement(container.Elements[index])
        index = index + 1
      end
    end,
    -- Simple enough
    drawScene = function (scene)
      local index = 1
      while index <= #scene.Containers do
        Kii.Render.drawContainer(scene.Containers[index])
        index = index + 1
      end
    end
}