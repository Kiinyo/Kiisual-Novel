
  local Debug = {
    -- 1 - 10
    function (s) K.sSpk(s, "Narrator", "Hey there and welcome to my VN frameworks's tech demo!") end,
    function (s) K.eBgm("Generic_Jazz", true) end,
    function (s)
      if K.cFlg(s, "Loop") then
        K.sFlg(s, "Loop", K.cFlg(s, "Loop") + 1)
      else
        K.sFlg(s, "Loop", 1)
      end
      K.sPge(s)
    end,
    function (s) K.sTxt(s, "Looks like we're on loop " .. tostring(K.cFlg(s, "Loop"))) end,
    function (s) if (K.cFlg(s, "Loop") == 1) then K.sTxt(s, "Oh, that means it's your first time! Hello!") else K.sTxt(s, "It's nice to see you again!") end end,
    function (s) K.sTxt(s, "I guess we'd better get started!") end,
    function (s) K.sTxt(s, "First let's get a background going...") end,
    function (s) K.sBga(s, "Generic", "Zoom In", 100) end,
    function (s) K.sTxt(s, "Now let's add a character") end,
    function (s) K.aCha(s, "Generic", "Default", 800, "Stage Left", 30) end,
    -- 11 - 20
    function (s) K.sTxt(s, "And zoom in on them...") end,
    function (s) K.tCha(s, "Generic", "Zoom", 2, 30) end,
    function (s) K.sTxt(s, "Jitter them around!") end,
    function (s) K.sCha(s, "Generic", "Jitter", 1, "Animation") end,
    function (s) K.sCha(s, "Generic", "Jitter", 10, "Animation") end,
    function (s) K.sCha(s, "Generic", "Jitter", 100, "Animation") end,
    function (s) K.sTxt(s, "Ehehe.") end,
    function (s) K.sCha(s, "Generic", "None", 1, "Animation") end,
    function (s) K.sTxt(s, "Let's change the emotion to happy!") end,
    function (s) K.sCha(s, "Generic", "Happy") end,
    -- 21 - 30
    function (s) K.sTxt(s, "And sad! ;~;") end,
    function (s) K.sCha(s, "Generic", "Sad") end,
    function (s) K.sTxt(s, "And then zoom back out...") end,
    function (s) K.tCha(s, "Generic", "Zoom", 0.5, 30) end,
    function (s) K.sTxt(s, "Let's slide the character along the X axis...") end,
    function (s) K.sFlg(s, "Original Position", K.mCha(s, "Generic", 1000, nil, 20)) end,
    function (s) K.mCha(s, "Generic", 100, nil, 20) end,
    function (s) K.sTxt(s, "Along the Y...") end,
    function (s) K.mCha(s, "Generic", nil, 500, 10) end,
    function (s) K.sTxt(s, "Now let's get it back to where it was") end,
    -- 31 - 40
    function (s) 
      local x = K.cFlg(scene, "Original Position")[1] 
      local y = K.cFlg(scene, "Original Position")[2] 
      K.mCha(s, "Generic", x, y, 20, true) 
    end,
    function (s) K.sTxt(s, "Oh and we can flip too!") end,
    function (s) K.tCha(s, "Generic", "Flip", nil, 0) end,

    function (s) K.sTxt(s, "And then remove it!") end,
    function (s) K.rCha(s, "Generic", "Fade Out", 10) end,
    function (s) K.aCha(s, "Generic", "Happy", 640, "Stage Right", 10) end,

    function (s) K.sTxt(s, "Or not!") end,
    function (s) K.rCha(s, "Generic", "Stage Left", 10) end,
    function (s) K.sTxt(s, "It's entirely up to you!") end,
    function (s) K.sTxt(s, "There's also a bunch of UI things we can do!") end,
    -- 41 - 50
    function (s) K.sTxt(s, "Like shrinking the text box...") end,
    function (s) K.tTbx(s, 700, 200, 10) end,
    function (s) K.sTxt(s, "Oh, while I'm here I can show you how the textwrapping works in real time even if you're resizing!") end,

    function (s) K.tTbx(s, 900, nil, 100) end,
    function (s) K.sTxt(s, "Fun stuff!") end,
    function (s) K.sTxt(s, "Oh and obviously we can move the text box around if we want to") end,

    function (s) K.mTbx(s, 300, 300, 10) end,
    function (s) K.sTxt(s, "Haven't quite thought of a use for it yet but it's cool to have!") end,
    function (s) K.sTxt(s, "Oh, you can also remove elements if you want to!") end,
    function (s) 
      s.Containers[K.gTbx(s)].Elements[4].Shader._type = "Fade Out"
      s.Containers[K.gTbx(s)].Elements[4].Shader._frame = 0
      s.Containers[K.gTbx(s)].Elements[4].Shader._modifier = 10
    end,
    -- 51 - 60
    function (s) K.sTxt(s, "Unfortunately this is super specific and I'm not sure how to make a sensible API for it so you'll have to do it by hand for now.") end,
    function (s) K.sTxt(s, "Let's just add that back...") end,
    function (s) 
      local element = Kii.Element.create(Kii.Elements.Debug.ExitButton)
      element.Shader._type = "Fade In"
      element.Shader._frame = 0
      element.Shader._modifier = 25
      Kii.Container.addElement(s.Containers[K.gTbx(s)], element)
    end,

    function (s) K.sTxt(s, "And fix the text box") end,
    function (s) K.mTbx(s, 40, 500, 20) K.tTbx(s, 1200, 150, 20) end,
    function (s) K.sTxt(s, "Now we can see about adding another another UI element!") end,

    function (s) K.aCon(s, "Fancy") end,
    function (s) K.sTxt(s, "There we go!") end,
    function (s) K.sTxt(s, "Feel free to play around with it and click the red tab when you're ready to move on!") end,
    function (s) K.sPge(s, "Debug", 59) end,
    -- 61 - 70
    function (s) K.sTxt(s, "!!!") end,
    function (s) K.sTxt(s, "Be careful, it'll delete system32!") end,
    function (s) K.sPge(s, "Debug", 59) end,

    function (s) K.sTxt(s, "Just kidding, it's useless!") end,
    function (s) K.sPge(s, "Debug", 59) end,
    function (s) K.sTxt(s, "Awesome!") end,

    function (s) K.sTxt(s, "So as you can see, there's a whole bunch of stuff you can wire through UI elements!") end,
    function (s) K.sTxt(s, "And with that I think that concludes this demo, I hope you've enjoyed yourself!") end,
    function (s) K.sTxt(s, "Oh, before I forget, you can right click to see the chat history.") end,
    function (s) K.sTxt(s, "There's a bit of an easter egg in the first couple of lines after the script resets to show off flags, but other than that thanks so much again for checking this out!") end,

    function (s) K.sTxt(s, "See you next time!") end,
    function (s) K.sPge(s, "Debug", 1) end
  }

  return Debug