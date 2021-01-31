Kii = {
  _version = "indev_0.0.1",
  _author = "Kathrine (Kiinyo) Lemet"
}
require "kii/math"
require "kii/util"
require "kii/render"
require "kii/audio"

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
        _modifier = template.Shader._modifier or 1,
        _target = template.Shader._target or "None"
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
  FancyPress = function (self, container, scene)
    if K.cFlg(scene, "Presses") == nil then
      K.sFlg(scene, "Presses", 1)
      container._text = "You've clicked my button 1 time!"
    elseif K.cFlg(scene, "Presses") == 1 then
      K.sFlg(scene, "Presses", 2)
      container._text = "You've clicked my button twice now!"
    elseif K.cFlg(scene, "Presses") > 1 and K.cFlg(scene, "Presses") < 10 then
      K.sFlg(scene, "Presses", K.cFlg(scene, "Presses") + 1)
      container._text = tostring(K.cFlg(scene, "Presses")).." times now."
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
    scene._mouseOver = nil
    scene._mouseDown = nil
    scene._mouseUp = nil
    Kii.Scene.removeContainer(scene, container._id)
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
      element = Kii.Element.create(template.Elements[index])
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
    print(animation)
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

Kii.Visuals = {
  Background = {
    Simple = {
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
    }
  }
}

Kii.Scene = {
  -- Creates a new scene and sets a bunch of defaults, returns a Scene
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
        Sprites = template.Visual.Sprites or {},
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
    if scene.Audio._voice ~= nil then K.eSfx(scene.Audio._voice) end
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
      local hisCon = Kii.Container.create(Kii.Containers.Simple.History)
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
      scene.Audio._voice = voice
    end
  end
}

Kii.Sprite = {
  create = function (name, base, expression, position)
    local x = position or 800
    local y = math.floor(love.graphics.getHeight() / 7) + 5
    x = math.floor(x - love.graphics.getWidth() * (6 / 7) / 4)
    
    local sprite = Kii.Container.create({
      _name = name,
      _type = "Sprite",
      Dimensions = {
        _height = math.floor(love.graphics.getHeight() * (6 / 7)),
        _width = math.floor(love.graphics.getWidth() * (6 / 7) / 2)
      },
      Position = {
        _x = x,
        _y = y
      }
    })
    sprite.Sprite = {
      _base = nil,
      _expression = nil,
    }
    Kii.Sprite.changeBase(sprite, base)
    Kii.Sprite.changeExpression(sprite, expression)

    return sprite
  end,
  changeBase = function(sprite, base)
    base = Kii.Element.create({
        _name = sprite._name,
        _type = "SpriteBase",
        Dimensions = {
          _color = "Clear",
          _shape = base,
        },
        Text = {
          _text = "@None"
        }
    })
    if sprite.Sprite._base then
      Kii.Container.removeElement(sprite, sprite.Sprite._base)
    end
    sprite.Sprite._base = Kii.Container.addElement(sprite, base)
  end,
  changeExpression = function (sprite, expression)
    expression = Kii.Element.create({
        _name = sprite._name,
        _type = "SpriteExpression",
        Dimensions = {
          _color = "Clear",
          _shape = expression,
        },
        Text = {
          _text = "@None"
        }
    })
    if sprite.Sprite._expression then
      Kii.Container.removeElement(sprite, sprite.Sprite._expression)
    end
    sprite.Sprite._expression = Kii.Container.addElement(sprite, expression)

  end
}

Kii.Sprites = {
  Default = {
    Bases = {
      Default = love.graphics.newImage("media/visual/sprites/default/bases/default.png")
    },
    Expressions = {
      Default = love.graphics.newImage("media/visual/sprites/default/expressions/default.png"),
      Happy = love.graphics.newImage("media/visual/sprites/default/expressions/happy.png"),
      Sad = love.graphics.newImage("media/visual/sprites/default/expressions/sad.png"),
    }
  }
}

Kii.Script = {
  Characters = {
    Default = {
      _name = "Default",
      _voice = "Generic",
      _color = "Black",
      Sprite = "Default"
    },
    Kiinyo = {
      _name = "Kiinyo",
      _voice = "Generic_Female",
      _color = "White",
      Sprite = nil
    }
  }
}

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
    page = page or scene.Script._index

    Kii.Chapters[chapter][page](scene)
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
      Kii.Script.Characters[speaker]._name,
      Kii.Script.Characters[speaker]._voice,
      Kii.Script.Characters[speaker]._color      
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

  mTbx = function (scene, x, y, duration)
    duration = duration or 20
    Kii.Container.move(scene.Containers[K.gTbx(scene)], x, y, duration)
  end,

  tTbx = function (scene, width, height, duration)
    duration = duration or 20
    Kii.Container.scale(scene.Containers[K.gTbx(scene)], width, height, duration)
  end,

  -- Executes a specified sound effect
  eSfx = function (soundEffect)
    Kii.Audio.SFX[soundEffect]:play()
  end,

  -- Executes a specified sound effect
  eBgm = function (soundEffect)
    Kii.Audio.BGM[soundEffect]:play()
  end,

  -- Checks if the Scene currently has a background
  cBga = function (scene)
    return scene.Visual._bg
  end,
  -- Sets the current Background while removing the old one
  sBga = function (scene, Background, animation, duration)
    duration = duration or 0
    Background = Kii.Container.create(Kii.Visuals.Background[Background])

    Kii.Container.setDimensions(
      Background, 
      love.graphics.getWidth(),
      love.graphics.getHeight(),
      true
    )
    
    if K.cBga(scene) then
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
  aCha = function (scene, Character, Emotion, position, animation, duration, variant)
    local character = Kii.Script.Characters[Character].Sprite
    variant = variant or "Default"
    local sprite = Kii.Sprite.create(character, variant, Emotion, position)

    return Kii.Scene.addSprite(scene, sprite, animation, duration)
  end,
  -- Removes a Character from the scene
  rCha = function (scene, character, animation, length)
    character = Kii.Script.Characters[character].Sprite
    Kii.Container.selfDestruct(
      scene.Containers[Kii.Scene.findIndex(scene, scene.Visual.Sprites[character])],
      length,
      animation
    )
  end,
  -- Set a Character's Animation and Shaders and Emotions
  -- If type is omitted, animation becomes emotion
  sCha = function (scene, character, animation, scale, type)
    character = Kii.Script.Characters[character].Sprite

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

    character = Kii.Script.Characters[character].Sprite
    duration = duration or 30

    Kii.Container.move(
      Kii.Scene.getSprite(scene, character),
      x, y, duration
    )

    return {oldX, oldY}
  end,
  -- Transforms a Character in the scene
  tCha = function (scene, character, type, magnitude, duration)
    character = Kii.Script.Characters[character].Sprite

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
  cFlg = function (scene, flag)
    return scene.Flags[flag]
  end,

}

Kii.Chapters = {
  Debug = {
    -- 1 - 10
    function (s) K.sSpk(s, "Kiinyo", "Hey there and welcome to my VN frameworks's tech demo!") end,
    function (s) K.eBgm("Generic_Jazz") end,
    function (s) 
      if K.cFlg(s, "Loop") then
        K.sFlg(s, "Loop", K.cFlg(s, "Loop") + 1)
      else
        K.sFlg(s, "Loop", 1)
      end
      K.sPge(s)
    end,
    function (s) K.sTxt(s, "Looks like we're on loop " .. tostring(K.cFlg(s, "Loop"))) end,
    function (s) if (K.cFlg(s, "Loop") == 1) then K.sTxt(s, "Oh, that means it's your first time! Hello!") else K.sTxt(s, "It's nice to see you again!") end end,
    function (s) K.sTxt(s, "I guess we'd better get started!") end,
    function (s) K.sTxt(s, "First let's get a background going...") end,
    function (s) 
      if K.cFlg(s, "Loop") % 3 == 1 then
        K.sBga(s, "Simple", "Zoom In", 100)
        s.Containers[Kii.Scene.findIndex(s, s.Visual._bg)].Elements[1].Dimensions._color = "Yellow"
      elseif K.cFlg(s, "Loop") % 3 == 0 then
        K.sBga(s, "Simple", "Stage Left", 100)
      else
        K.sBga(s, "Simple", "Fade In", 100)
        s.Containers[Kii.Scene.findIndex(s, s.Visual._bg)].Elements[1].Dimensions._color = "Blue"
      end
    end,
    function (s) K.sTxt(s, "Now let's add a character") end,
    function (s) K.aCha(s, "Default", "Default", 800, "Stage Left", 30) end,
    -- 11 - 20
    function (s) K.sTxt(s, "And zoom in on them...") end,
    function (s) K.tCha(s, "Default", "Zoom", 2, 30) end,
    function (s) K.sTxt(s, "Jitter them around!") end,
    function (s) K.sCha(s, "Default", "Jitter", 1, "Animation") end,
    function (s) K.sCha(s, "Default", "Jitter", 10, "Animation") end,
    function (s) K.sCha(s, "Default", "Jitter", 100, "Animation") end,
    function (s) K.sTxt(s, "Ehehe.") end,
    function (s) K.sCha(s, "Default", "None", 1, "Animation") end,
    function (s) K.sTxt(s, "Let's change the emotion to happy!") end,
    function (s) K.sCha(s, "Default", "Happy") end,
    -- 21 - 30
    function (s) K.sTxt(s, "And sad! ;~;") end,
    function (s) K.sCha(s, "Default", "Sad") end,
    function (s) K.sTxt(s, "And then zoom back out...") end,
    function (s) K.tCha(s, "Default", "Zoom", 0.5, 30) end,
    function (s) K.sTxt(s, "Let's slide the character along the X axis...") end,
    function (s) K.sFlg(s, "Original Position", K.mCha(s, "Default", 1000, nil, 20)) end,
    function (s) K.mCha(s, "Default", 100, nil, 20) end,
    function (s) K.sTxt(s, "Along the Y...") end,
    function (s) K.mCha(s, "Default", nil, 500, 10) end,
    function (s) K.sTxt(s, "Now let's get it back to where it was") end,
    -- 31 - 40
    function (s) 
      local x = K.cFlg(scene, "Original Position")[1] 
      local y = K.cFlg(scene, "Original Position")[2] 
      K.mCha(s, "Default", x, y, 20, true) 
    end,
    function (s) K.sTxt(s, "Oh and we can flip too!") end,
    function (s) K.tCha(s, "Default", "Flip", nil, 0) end,

    function (s) K.sTxt(s, "And then remove it!") end,
    function (s) K.rCha(s, "Default", "Fade Out", 10) end,
    function (s) K.aCha(s, "Default", "Happy", 640, "Stage Right", 10) end,

    function (s) K.sTxt(s, "Or not!") end,
    function (s) K.rCha(s, "Default", "Stage Left", 10) end,
    function (s) K.sTxt(s, "It's entirely up to you!") end,
    function (s) K.sTxt(s, "There's also a bunch of UI things we can do!") end,
    -- 41 - 50
    function (s) K.sTxt(s, "Like shrinking the text box...") end,
    function (s) K.tTbx(s, 700, 200, 10) end,
    function (s) K.sTxt(s, "Oh, while I'm here I can show you how the textwrapping works in real time even if you're resizing!") end,

    function (s) K.tTbx(s, 900, nil, 100) end,
    function (s) K.sTxt(s, "Fun stuff!") end,
    function (s) K.sTxt(s, "Oh and obviously we can move the text box around if we want to") end,

    function (s) K.mTbx(s, 300, 300, 10) end,
    function (s) K.sTxt(s, "Haven't quite thought of a use for it yet but it's cool to have!") end,
    function (s) K.sTxt(s, "Oh, you can also remove elements if you want to!") end,
    function (s) 
      s.Containers[K.gTbx(s)].Elements[4].Shader._type = "Fade Out"
      s.Containers[K.gTbx(s)].Elements[4].Shader._frame = 0
      s.Containers[K.gTbx(s)].Elements[4].Shader._modifier = 10
    end,
    -- 51 - 60
    function (s) K.sTxt(s, "Unfortunately this is super specific and I'm not sure how to make a sensible API for it so you'll have to do it by hand for now.") end,
    function (s) K.sTxt(s, "Let's just add that back...") end,
    function (s) 
      local element = Kii.Element.create(Kii.Elements.Debug.ExitButton)
      element.Shader._type = "Fade In"
      element.Shader._frame = 0
      element.Shader._modifier = 25
      Kii.Container.addElement(s.Containers[K.gTbx(s)], element)
    end,

    function (s) K.sTxt(s, "And fix the text box") end,
    function (s) K.mTbx(s, 40, 500, 20) K.tTbx(s, 1200, 150, 20) end,
    function (s) K.sTxt(s, "Now we can see about adding another another UI element!") end,

    function (s) K.aCon(s, "Fancy") end,
    function (s) K.sTxt(s, "There we go!") end,
    function (s) K.sTxt(s, "Feel free to play around with it and click the red tab when you're ready to move on!") end,
    function (s) K.sPge(s, "Debug", 59) end,
    -- 61 - 70
    function (s) K.sTxt(s, "!!!") end,
    function (s) K.sTxt(s, "Be careful, it'll delete system32!") end,
    function (s) K.sPge(s, "Debug", 59) end,

    function (s) K.sTxt(s, "Just kidding, it's useless!") end,
    function (s) K.sPge(s, "Debug", 59) end,
    function (s) K.sTxt(s, "Awesome!") end,

    function (s) K.sTxt(s, "So as you can see, there's a whole bunch of stuff you can wire through UI elements!") end,
    function (s) K.sTxt(s, "And with that I think that concludes this demo, I hope you've enjoyed yourself!") end,
    function (s) K.sTxt(s, "Oh, before I forget, you can right click to see the chat history.") end,
    function (s) K.sTxt(s, "There's a bit of an easter egg in the first couple of lines after the script resets to show off flags, but other than that thanks so much again for checking this out!") end,

    function (s) K.sTxt(s, "See you next time!") end,
    function (s) K.sPge(s, "Debug", 1) end
  },
}

return Kii