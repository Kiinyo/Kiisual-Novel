local Actions = {
    FancyPress = function (self, container, scene)
      if K.gFlg(scene, "Presses") == nil then
        K.sFlg(scene, "Presses", 1)
        container._text = "You've clicked my button 1 time!"
      elseif K.gFlg(scene, "Presses") == 1 then
        K.sFlg(scene, "Presses", 2)
        container._text = "You've clicked my button twice now!"
      elseif K.gFlg(scene, "Presses") > 1 and K.gFlg(scene, "Presses") < 10 then
        K.sFlg(scene, "Presses", K.gFlg(scene, "Presses") + 1)
        container._text = tostring(K.gFlg(scene, "Presses")).." times now."
      else
        container._text = "There's more of the demo left you know..."
      end
  
    end,
    FancyWarn = function (self, container, scene)
      self.Animation._type = "Slide_Down"
      self.Animation._modifier = 10
      if scene.Script._index < 60 then
        K.sPge(scene, "Demo", 61)
      end
    end,
    FancyJoke = function (self, container, scene)
      self.Shader._type = "None"
      self.Shader._modifier = 1
      self.Shader._frame = 0
      K.sPge(scene, "Demo", 64)
    end,
    Glow = function (self, container, scene)
      self.Shader._type = "Lighten"
      self.Shader._frame = 0
      self.Shader._modifier = 30
      self.Shader._target = 0.5
    end,
    SlideRight = function (self, container, scene)
      self.Animation._type = "Slide_Right"
      self.Animation._modifier = 10
    end,
    ReturnRight = function (self, container, scene)
      self.Animation._type = "Return_Right"
    end,
    SlideDown = function (self, container, scene)
      self.Animation._type = "Slide_Down"
      self.Animation._modifier = 10
    end,
    ReturnDown = function (self, container, scene)
      self.Animation._type = "Return_Down"
    end,
    FancyDeleteContainer = function (self, container, scene)
      Kii.Element.Actions.DeleteContainer(self, container, scene)
      K.sPge(scene, "Demo", 66)
    end,
    QuitGame = function (self, container, scene)
      love.event.quit()
    end,
    None = function (self, container, scene)
      -- Nothing here!
    end,
    Excite = function (self, container, scene)
      self.Animation._type = "Jitter_Everything"
      Kii.Element.Actions.Glow(self, container, scene)
    end,
    Press = function (self, container, scene)
      self.Animation._type = "Press_Down"
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

  return Actions