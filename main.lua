local Kii = require "kii/main"

function love.load()
  love.graphics.setBackgroundColor(Kii.Render.colorFind("Yellow"))
  button = Kii.Element.create()
  container = Kii.Container.create()
end

function love.update()
  if love.keyboard.isDown("left") then Kii.Container.translate(container, container.Position._x - 1, container.Position._y)
  elseif love.keyboard.isDown("right") then Kii.Container.translate(container, container.Position._x + 1, container.Position._y)
  elseif love.keyboard.isDown("up") then button.Dimensions._height = button.Dimensions._height + 1
  elseif love.keyboard.isDown("down") then button.Dimensions._height = button.Dimensions._height - 1
  elseif love.keyboard.isDown("a") then button.Shader._frame = 0
  elseif love.keyboard.isDown("b") then container.test()
  end
end

function love.draw()
  Kii.Render.drawElement(button)
  Kii.Render.drawContainer(container)
end
