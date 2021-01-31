
Kii.Container = {
    create = function (template)
      template = template or {}
      template.Dimensions = template.Dimensions or {}
      template.Position = template.Position or {}
      template.Colors = template.Colors or {}
      template.Elements = template.Elements or {}
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
        Elements = {}
      }
  
      container.Resize = {
        _type = template.Resize._type or "None",
        _frame = template.Resize._frame or 0,
        _targetWidth = template.Resize._targetWidth or container.Dimensions._width,
        _targetHeight = template.Resize._targetHeight or container.Dimensions._height
      }
      container.Reposition = {
        _type = template.Reposition._type or "None",
        _frame = template.Reposition._frame or 0,
        _targetX = template.Reposition._targetX or container.Position._x,
        _targetY = template.Reposition._targetY or container.Position._y
      }
    
      local index = 1
      local element = nil
      while index <= #template.Elements do
        if container._type == "Background" or container._type == "Sprite" then
          element = Kii.Element.create(template.Elements[index])
        else
          element = Kii.Element.create(Kii.Elements[template.Elements[index]])
        end
        Kii.Container.addElement(container, element)
        index = index + 1
      end
      return container
    end,
    -- Removes the element associated with the current id
    removeElement = function (container, id)
      table.remove(container.Elements, Kii.Container.findIndex(container, id))
    end,
    findIndex = function (container, id)
      local indexA = 1
  
      while true do
        if indexA > #container.Elements then
          indexA = nil
          break
        end      
        if container.Elements[indexA]._id == id then
          break
        end
        indexA = indexA + 1
      end
  
      return indexA
  
    end,
    -- Adds an element and returns its id
    addElement = function (container, element)
      container._elementIDs = container._elementIDs + 1
      element._id = container._elementIDs
      Kii.Container.formatElement(container, element)
      table.insert(container.Elements, element)
      return container._elementIDs
    end,
    -- Scale and position all the elements
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
        element.Text._text = container._textupdate
      end
    end,
    -- Cycles through the elements and updates headers and bodies
    updateElements = function (container)
      local index = 1
      while index <= #container.Elements do
        if container.Elements[index]._type == "Header" then
          container.Elements[index].Text._text = container._name
          container.Elements[index].Text._color = container.Colors._speaker
        elseif container.Elements[index]._type == "Body" then
          container.Elements[index].Text._text = container._text
        end
        if container.Elements[index]._deleteMe then
          Kii.Container.removeElement(container, container.Elements[index]._id)
        end
        index = index + 1
      end
    end,
  
    setShader = function (container, shader, scale)
      scale = scale or 1
      local index = 1
      while index <= #container.Elements do
        container.Elements[index].Shader._type = shader
        container.Elements[index].Shader._frame = 0
        container.Elements[index].Shader._modifier = scale
        index = index + 1
      end
    end,
  
    animate = function (container, animation, scale)
      scale = scale or 1
      local index = 1
      while index <= #container.Elements do
        container.Elements[index].Animation._type = animation
        container.Elements[index].Animation._frame = 0
        container.Elements[index].Animation._modifier = scale
        index = index + 1
      end
    end,
  
    -- Flags container for deletion after time
    selfDestruct = function (container, duration, type)
      container._countdown = duration or 0
      if type == "Fade Out" then
        container._fadeout = true
      elseif type == "Stage Left" then
        Kii.Container.move(
          container,
          love.graphics.getWidth(),
          container.Position._y,
          duration
        )
      elseif type == "Stage Right" then
        Kii.Container.move(
          container,
          0 - container.Dimensions._width,
          container.Position._y,
          duration
        )
      end
    end,
  
    -- General update function, also processes self destruct
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
    setPosition = function (container, x, y, setTarget)
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
  
      if setTarget then
        container.Reposition._targetX = x
        container.Reposition._targetY = y
      end
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
              container.Reposition._frame,
              true
            ),
            Kii.Math[tween](
              container.Position._y,
              container.Reposition._targetY,
              container.Reposition._frame,
              true
            )
          )
  
          container.Reposition._frame = container.Reposition._frame - 1
        end
      end
    end,
    -- Ordering the actual animation
    move = function (container, x, y, duration, type)
      Kii.Container.setPosition(
        container,
        container.Reposition._targetX,
        container.Reposition._targetY
      )
      
      container.Reposition._type = type or "Linear"
      container.Reposition._targetX = x or container.Position._x
      container.Reposition._targetY = y or container.Position._y
      container.Reposition._frame = duration or 10
    end,
  
    -- Set the container's width and height
    setDimensions = function (container, width, height, setTarget)
      container.Dimensions._width = width
      container.Dimensions._height =  height
  
      if setTarget then
        container.Resize._targetWidth = width
        container.Resize._targetHeight = height
      end
    
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
              container.Resize._frame,
              true
            ),
            Kii.Math[tween](
              container.Dimensions._height,
              container.Resize._targetHeight,
              container.Resize._frame,
              true
            )
          )
  
          container.Resize._frame = container.Resize._frame - 1
  
        end
      end
    end,
    -- Ordering the actual animation
    scale = function (container, width, height, duration, type)
      Kii.Container.setDimensions(
        container,
        container.Resize._targetWidth,
        container.Resize._targetHeight
      )
  
      container.Resize._type = type or "Linear"
      container.Resize._targetWidth = width or container.Dimensions._width
      container.Resize._targetHeight = height or container.Dimensions._height
      container.Resize._frame = duration or 10
    end,
    flip = function (container, length)
      length = length or 0
      Kii.Container.scale(
        container,
        container.Dimensions._width * -1,
        container.Dimensions._height,
        length
      )
      Kii.Container.move(
        container,
        container.Position._x + container.Dimensions._width,
        container.Position._y,
        length
      )
    end,
    zoom = function (container, magnitude, length)
      local width = container.Resize._targetWidth
      local height = container.Resize._targetHeight
  
      Kii.Container.scale(
        container,
        container.Resize._targetWidth * magnitude,
        container.Resize._targetHeight * magnitude,
        length
      )
      Kii.Container.move(
        container,
        math.floor(container.Reposition._targetX - ((container.Resize._targetWidth - width) / 2)),
        math.floor(container.Reposition._targetY - ((container.Resize._targetHeight - height) / 2)),
        length
      )
  
    end,
    enterAnimation = function (container, animation, length)
      if animation == "Fade In" then
        Kii.Container.setShader(container, animation, length)
      elseif animation == "Zoom In" then
        Kii.Container.setDimensions(
          container,
          1,
          1,
          true
        )
        Kii.Container.setPosition(
          container,
          love.graphics.getWidth() / 2,
          love.graphics.getHeight() / 2,
          true
        )
        Kii.Container.scale(
          container,
          love.graphics.getWidth(),
          love.graphics.getHeight(),
          length
        )
        Kii.Container.move(
          container,
          0,
          0,
          length
        )
      elseif animation == "Stage Right" then
        local x = container.Reposition._targetX
        Kii.Container.setPosition(
          container,
          0 - container.Dimensions._width,
          container.Position._y,
          true
        )
        Kii.Container.move(container, x, container.Position._y, length)
      elseif animation == "Stage Left" then
        local x = container.Reposition._targetX
        Kii.Container.setPosition(
          container,
          love.graphics.getWidth(),
          container.Position._y,
          true
        )
        Kii.Container.move(container, x, container.Position._y, length)
      end
    end
  }