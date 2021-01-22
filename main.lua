local Kii = require "kii/main"

function love.load()
  button = Kii.Element.createElement()
end

function love.update()
  if love.keyboard.isDown("left") then button.Dimensions._width = button.Dimensions._width - 1
  elseif love.keyboard.isDown("right") then button.Dimensions._width = button.Dimensions._width + 1
  elseif love.keyboard.isDown("up") then button.Dimensions._height = button.Dimensions._height + 1
  elseif love.keyboard.isDown("down") then button.Dimensions._height = button.Dimensions._height - 1
  elseif love.keyboard.isDown("a") then button.Shader._frame = 0
  end
end

function love.draw()
  Kii.Render.drawElement(button)
end
