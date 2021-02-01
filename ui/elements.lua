-- A breakdown of everything an Element has
-- Included are the default values. If your
-- element uses the defaule value you don't
-- have to define it!
local template = {

  -- This is the name given to the Element
  -- It is used to find the Element in a Container
  -- so make sure Containers don't have two Elements
  -- with the same name!

  _name = "Default Element Name", -- "String"

  -- This indicates what the element is to other parts
  -- of the program, use "Image" if you want do display
  -- an image from the media/visual/images folder!

  _type = "Default Type", -- "Anything you want", "Image"

  -- This tells the scene whether or not the Element can
  -- perform actions, if it can't it gets ignored during
  -- actions like clicking the mouse

  _interactive = false, -- boolean

  -- Now we get to the Dimensions of the Element!

  Dimensions = {

    -- This tells the constructor whether ot not the Dimensions
    -- of the Element are bound to the container

    _relative = "Both", -- "Width", "Height", "Both", "Neither"

    -- The width and height of the element in pixels, if
    -- _relative then the _width and/or _height is multiplied 
    -- by corresponding _width / _height of the container
    
    _width = 1,  -- For 50% you could use 0.5
    _height = 1, -- Or a fraction like 1/2

    -- This is where things can get a bit complicated, for
    -- the shape you can add either a shape from shapes.lua
    -- file OR the filename of an image if you set the _type
    -- to "Image" earlier!

    _shape = "Box", -- "Generic.png", "Right Iso Tri", etc.
  
    -- This one's pretty simple, it's the color used to fill
    -- in the shape, choose "Clear" if your element is an "Image"
    -- or it'll add the color's hue to your image! You can find a
    -- a complete list of colors in the palette.lua file!

    _color = "Blue", -- "Red", "Clear", etc.

    -- How many pixels of space between the edge of the element
    -- and the element's text. Hardcoded as pixels at the moment
    -- but should be an easy fix if anyone wants it to be scaled!

    _padding = 10, -- Any number works!

    -- Transparancy of the object, an _alpha of 0 is fully
    -- transparent while an _alpha of 1 is fully visible!

    _alpha = 1 -- 0.6, 3/4, etc.
  },

  -- The Position of the Element!

  Position = {

    -- First up we have the equivalent of _relative from
    -- the Dimensions section. The alignment determines
    -- where in the Container the Element is located.
    -- Use "Free" if you'd like its position to be independent
    -- of the container! Here's a diagram to help!
    --
    --  Free            Above
    --          +-------------------+
    --          |        Up         |
    --          |                   |
    --    Before|Left  Center  Right|After
    --          |                   |
    --          |       Down        |
    --          +-------------------+
    --                  Below

    _alignX = "Left", -- "Before", "Left", "Center", "Right", "After", "Free"
    _alignY = "Up", -- "Above", "Up", "Center", "Down", "Below", "Free"

    -- Now here are the _x and _y offset of the Element.
    -- These turn into percentages of the related Container's
    -- _width and _height unless using the "Free" _align in
    -- which case they become pixel coordinates on the screen!

    _x = 0, -- 1, 3.14, 2/3
    _y = 0, -- Any number works here

    -- We can also hardcode an offset to a pixel value if we
    -- want to, can be used for things like drop shadows but
    -- keep in mind this will overwrite the _x and _y offset!

    _xOffset = nil, -- By default these are not used, but you
    _yOffset = nil  -- can put any number in here!
  },

  -- As mentioned earlier, Elements contain a Shape and Text!

  Text = {
    
    -- This is the text to be displayed by the element, by
    -- default it is set to "@None" which lets the renderer
    -- know not to bother rendering anything, if set to "",
    -- the drawText function will be still be called

    _text = "@None", -- "String", "Hello, World!" "\n Second Lines"

    -- The font to use to draw the text, pulls from
    -- media/visual/fonts the .ttf is appended
    -- automatically for you! Might change this to
    -- support other font types
    
    _font = "Anime_Ace", -- "Times New Roman", "Arial", etc.

    -- Color to display the text as, refer to palette.lua
    -- for a list of possible colors!

    _color = "White", -- "Blue", "Red", "Green", etc.

    -- The size of the font to be displayed, currently
    -- hardcoded as pixels but also changeable if needed!

    _size = 18,

    -- The alignment of the font inside of the element
    -- since we use LÖVE's framework for this we have to
    -- use lowercase letters here, I can fix this later
    -- but it's a bit of a non-issue at the moment!

    _alignX = "center", -- "left", "center", "right"
    _alignY = "center" -- "top", "center", "bottom"
  },

  -- These are transformations over time that affect the
  -- Element's Position and Dimensions without changing
  -- their actual values like a move/scale function would

  Animation = {

    -- The type of animation to be performed! See the 
    -- animations.lua file for a full list of possible
    -- animations you can perform on an Element! Usually
    -- this is set to "None" to start with though!

    _type = "None", -- "Jitter", "Press", etc.

    -- Usually left untouched and used by the animation
    -- to keep track of the time passed in the animation!

    _frame = 0, -- 6, 4.3, 1/7

    -- Usually left untouched and used by the animation
    -- to keep track of the magnitude or duration!

    _modifier = 1  -- 0.9, 83, 4
  },

  -- There are effects that deal with the color of the
  -- Element, essentially "shading" it. Hence the name!

  Shader = {

    _type = "None", -- "Lighten", "Fade Out", etc.

    -- Usually left untouched and used by the shader
    -- to keep track of the time passed in the shader!

    _frame = 0, -- 6, 4.3, 1/7

    -- Usually left untouched and used by the shader
    -- to keep track of the magnitude or duration!

    _modifier = 1, -- 0.9, 83, 4

    -- Usually left untouched and used by the shader
    -- to keep track of things like what color to
    -- shade the Element.

    _target = "None"
  },

  -- The fun bit, if we set _interactive to true there
  -- are a bunch of different interactions a player
  -- can have with the object which need their own Action!
  -- They can be a bit confusing at first but it'll really
  -- separate your VN from others if you can master them!
  -- Consult the actions.lua file for a list of things
  -- your Elements can do! Note the lack of an underscore
  -- prefix since these aren't _traits but actions()!

  Actions = {

    -- First up is the over action, this is triggered when
    -- the player puts their mouse "over" the element. Common
    -- actions are things like "Excite" to let the player know
    -- they are hovering over something interactable.

    over = "None",

    -- Paired with over we have leave. This occurs when the
    -- when the mouse "leave"s the element. Common actions
    -- are things like "Reset" to stop any animations or
    -- shaders they might have been triggered other Actions

    leave = "None",

    -- Next we have down which is different from click! Down occurs
    -- when the player presses the left mouse button "down" on the
    -- Element. Can be used to display a pressed animation for an
    -- object or to clip the element to the mouse if you want to
    -- drag it somewhere!

    down = "None",

    -- The opposite of down, this occurs when the player lets the
    -- left mouse button go back "up" after being pressed. Again
    -- this is not click! If the player wants to drag and drop
    -- an element to another Element, up can be used to let the
    -- Element know something has been dropped on it!

    up = "None",

    -- In the same vein as up we have abandon. This occurs when
    -- a player pressed LMB 'down' on an Element and then lifts
    -- 'up' outside of the element, hence "abandon"ed. Can be
    -- used to tell an Element where it has been dragged to or
    -- reset a down animation.

    abandon = "None",

    -- Finally we have click, this happens when the mouse is both
    -- pressed and release over the Element. This also helps prevent
    -- misclicks by allowing the player to drag the mouse off the
    -- Element before releasing to prevent the action from taking
    -- place. Common Actions include flag and page setting.

    click = "None"
  }

}

-- A condensed cheat sheet of sorts with all the default values
local template2 = {
  _name = "Default Element Name", -- Make sure it's unique!
  _type = "Default Type", -- "Image" for images
  _interactive = false, -- enables Actions
  Dimensions = {
    _relative = "Both", -- "Width", "Height", "Both", "Neither"
    _height = 1, -- Percentage if _relative, Pixel if not
    _width = 1, -- Percentage if _relative, Pixel if not
    _shape = "Box", -- shapes.lua or media/visual/images
    _color = "Blue", -- palette.lua "Clear" for images!
    _alpha = 1, -- 0 = tranparent, 1 = solid
    _padding = 10, -- Hard coded as pixel values
  },
  Position = {
    _alignX = "Left", -- "Before", "Left", "Center", "Right", "After", "Free"
    _alignY = "Up", -- "Above", "Up", "Center", "Down", "Below", "Free"
    _x = 0, -- % of container offset width if _align, Pixel if not
    _y = 0, -- % of container offset width if _align, Pixel if not
    _xOffset = nil, -- By default these are not used, but you
    _yOffset = nil  -- can put any number in here!
  },
  Text = {
    _text = "@None", -- "@None" means don't render text
    _font = "Anime_Ace", -- media/visual/fonts don't add the .ttf!
    _color = "White", -- palette.lua,
    _alignX = "center", -- "left", "center", "right"
    _alignY = "center", -- "top", "center", "bottom"
    _size = 18 -- pixel height
  },
  Animation = { -- Can ignore
    _type = "None", -- animations.lua
    _frame = 0, -- usually left alone
    _modifier = 1, -- usually left alone
  },
  Shader = { -- Can ignore
    _type = "None", -- shaders.lua
    _frame = 0, -- usually left alone
    _modifier = 1, -- usually left alone
    _target = "None" -- usually left alone
  },
  Actions = {
    up = "None", -- actions.lua
    down = "None", -- actions.lua
    over = "None", -- actions.lua
    leave = "None", -- actions.lua
    click = "None", -- actions.lua
    abandon = "None" -- actions.lua
  }
}

local Elements = {
  Demo_Shadow = {
    _name = "Demo Shadow",
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
  Demo_Body = {
    _name = "Demo Body",
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
  Demo_Header = {
    _name = "Demo Header",
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
  Demo_ExitButton = {
    _name = "Demo ExitButton",
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
  Demo_CloseContainerButton = {
    _name = "Demo CloseContainerButton",
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
  History = {
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