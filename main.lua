local Kii = require "kii/main"

function love.load()
  love.graphics.setBackgroundColor(Kii.Render.colorFind("Yellow"))
  love.window.setMode(1280, 720)
  element = Kii.Element.create()
  container = Kii.Container.create()
  scene = Kii.Scene.create()
end

function love.update()

  

  if love.keyboard.isDown("left") then Kii.Container.translate(container, container.Position._x - 1, container.Position._y)
  elseif love.keyboard.isDown("right") then Kii.Container.translate(container, container.Position._x + 1, container.Position._y)
  elseif love.keyboard.isDown("up") then element.Dimensions._height = element.Dimensions._height + 1
  elseif love.keyboard.isDown("down") then element.Dimensions._height = element.Dimensions._height - 1
  elseif love.keyboard.isDown("a") then element.Shader._frame = 0
  elseif love.keyboard.isDown("q") then scene.Containers[1].Elements[1].click()
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  if scene then
    Kii.Scene.handleEvent(scene, {"Mouse Down", button, x, y})
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  if scene then
    Kii.Scene.handleEvent(scene, {"Mouse Up", button, x, y})
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  if scene then
    Kii.Scene.handleEvent(scene, {"Mouse Move", x, y})
  end
end



function love.draw()
  Kii.Render.drawElement(element)
  Kii.Render.drawContainer(container)
  Kii.Render.drawScene(scene)


  love.graphics.arc("fill", 600, 600, 100, 0, -3.1415, 10)
end
