local Containers = {
    Debug = {
      _name = "Debug Container",
      _type = "Text Box",
      _text = "Just some debug stuffs",
      Position = {_x = 40, _y = 500},
      Dimensions = {
        _height = 150,
        _width = 1200
      },
      Colors = {
        _primary = "White",
        _accent = "Blue",
        _detail = "Black"
      },
      Elements = {
        "Debug_Shadow",
        "Debug_Body",
        "Debug_Header",
        "Debug_ExitButton"
      }
    },
    Fancy = {
      _name = "Fancy Box",
      _type = "Fancy Box",
      _text = "Graphic Design is my passion",
      Position = {
        _x = 190,
        _y = 100
      },
      Dimensions = {
        _height = 300,
        _width = 900
      },
      Elements = {
        "Fancy_Shadow",
        "Fancy_Decoration",
        "Fancy_CloseButton",
        "Fancy_Button1",
        "Fancy_Button2",
        "Fancy_Body",
        "Fancy_Header"
      }
    },
    Simple = {
      History = {
        _name = "Simple History",
        _type = "Body",
        Dimensions = {
          _height = 640,
          _width = 640
        },
        Position = {
          _x = 320,
          _y = 40
        },
        Colors = {
          _primary = "Black",
          _detail = "White"
        },
        Elements = {
          "Simple_History"
        }
      }
    }
}

return Containers