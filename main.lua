require "kii/kii"

function love.load()
  love.graphics.setBackgroundColor(Kii.Render.colorFind("Black"))
  love.keyboard.setKeyRepeat(false)
  love.window.setMode(1280, 720, {msaa = 4})
  scene = Kii.Scene.create()
end

function love.update()
  Kii.Scene.update(scene)
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
