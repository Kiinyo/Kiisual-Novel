local Kii = require "kii/main"

function love.load()
  love.graphics.setBackgroundColor(Kii.Render.colorFind("Yellow"))
  love.window.setMode(1280, 720)
  scene = Kii.Scene.create()
end

function love.update()
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
  Kii.Render.drawScene(scene)
end
