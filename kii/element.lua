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
          _shape = template.Dimensions._shape or "Box",
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
          _text = template.Text._text or "@None",
          _font = template.Text._font or "Anime_Ace",
          _color = template.Text._color or "White",
          _alignX = template.Text._alignX or "center",
          _alignY = template.Text._alignY or "center",
          _size = template.Text._size or 18,
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