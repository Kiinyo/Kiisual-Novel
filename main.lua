local Kii = require "kii/main"

function love.load()
  love.graphics.setBackgroundColor(Kii.Render.colorFind("Yellow"))
  love.window.setMode(1280, 720)
  scene = Kii.Scene.create()
end

function love.update()
  if love.keyboard.isDown("w") then
    Kii.Container.resize(scene.Containers[1], 0, 5)    
  end
  if love.keyboard.isDown("s") then
    Kii.Container.resize(scene.Containers[1], 0, -5)    
  end
  if love.keyboard.isDown("a") then
    Kii.Container.resize(scene.Containers[1], -5, 0)    
  end
  if love.keyboard.isDown("d") then
    Kii.Container.resize(scene.Containers[1], 5, 0)    
  end

  if love.keyboard.isDown("space") then
    scene.Text._frame = 0
  end
  if love.keyboard.isDown("q") then
    scene.Text._frame = string.len(scene.Text._text) - 1
  end

  if love.keyboard.isDown("left") then
    Kii.Container.move(scene.Containers[1], -5, 0)    
  end
  if love.keyboard.isDown("right") then
    Kii.Container.move(scene.Containers[1], 5, 0)    
  end
  if love.keyboard.isDown("up") then
    Kii.Container.move(scene.Containers[1], 0, -5)    
  end
  if love.keyboard.isDown("down") then
    Kii.Container.move(scene.Containers[1], 0, 5)    
  end

  Kii.Scene.update(scene)

end

function love.mousepressed(x, y, button, istouch, presses)
  if scene then
    Kii.Scene.handleEvent(scene, {"Mouse Down", button, x, y})
  end
  if button == 2 then
    local container2 = Kii.Container.create(Kii.Containers.Debug)
    Kii.Scene.addContainer(scene, container2)
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
