
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
        _type = "Image",
        Dimensions = {
          _color = "Clear",
          _shape = love.graphics.newImage("media/visual/sprites/"..sprite._name.."/bases/"..base..".png"),
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
        _type = "Image",
        Dimensions = {
          _color = "Clear",
          _shape = love.graphics.newImage("media/visual/sprites/"..sprite._name.."/expressions/"..expression..".png"),
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