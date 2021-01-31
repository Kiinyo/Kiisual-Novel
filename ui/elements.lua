local Elements = {
  Debug_Shadow = {
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
  Debug_Body = {
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
  Debug_Header = {
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
  Debug_ExitButton = {
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
  Debug_CloseContainerButton = {
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
  },
  Fancy_Shadow = {
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
  Fancy_Decoration = {
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
  Fancy_Body = {
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
  Fancy_Header = {
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
  Fancy_CloseButton = {
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
  Fancy_Button1 = {
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
  Fancy_Button2 = {
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
  },
  Simple_Box = {
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
  Simple_History = {
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
  Simple_Image = {
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

return Elements