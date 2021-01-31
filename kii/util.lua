Kii.Util = {
    parseText = function (texts)
      local index = 1
      local text = ""
      while index <= #texts do
        if texts[index]:sub(1, 1) == '"' then   
          text = text.."\n".."    "..texts[index]
        else
          text = text.."\n".."\n"..texts[index]
        end
        index = index + 1
      end
      return text
    end
  }
  