-- These are the shapes used by elements to know how to draw
-- their boundaries! Feel free to use them or add your own as needed!
local Shapes = {
    -- The way vertices are calculated is by using
    -- the element's width as a scaling factor!
    -- So for instance of the Right_Iso_Tri which
    -- which looks like ▶, starting from the top left
    -- coordinate, our first x, y, pair is 0% of the
    -- object's width and height, so we put 0, 0.
    -- Then we move on to the next point clockwise which
    -- is the point of the triangle, we know we want it too
    -- be halfway down the shape and on the far side so
    -- we get 100% of the width(x), and 1/2 of the height(y)
    -- and with that we can create any shape! Although due to
    -- the limitations of LOVE at the moment we can only draw
    -- convex shapes! I might add a triangulation formula later
    -- but drawing multiple shapes sometimes break the MSAA
    Right_Iso_Tri = {
        -- The top point of ▶
        {0, 0},
        -- The furthest right point of ▶
        {1, 1/2},
        -- The bottom point of ▶
        {0, 1}
    },
    -- Left pointing triangle
    Left_Iso_Tri = {
        {1, 0},
        {1, 1},
        {0, 1/2}
    },
    -- A simple box that fills the width and height
    Box = {
        {0, 0},
        {1, 0},
        {1, 1},
        {0, 1}
    },

    -- The header used for the demo
    Demo_Header = {
        {0, 0},
        {7/8, 0},
        {1, 1},
        {0, 1}
    },
    -- The fancy header used by the demo
    Fancy_Header = {
        {0, 0},
        {1, 1/8},
        {1, 1},
        {0, 1}
    },

    -- The fancy Textbox body used by the demo
    Fancy_Body = {
        {0, 5/16},
        {1, 0},
        {7/8, 7/8},
        {1/16, 13/16}
    },
    -- A decoration used by the Fancy box
    Fancy_Decoration = {
        {0, 0},
        {1, 0},
        {0, 1}
    }
}

return Shapes