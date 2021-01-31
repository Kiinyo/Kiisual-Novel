-- A list of math stuff I'm too lazy to look up
Kii.Math = {
    clamp = function(value, min, max)
      return math.min(math.max(value, min), max)
    end,
    checkCollision = function(x, y, tX, tY, tW, tH)
      return (
        x >= tX and x <= tX + tW and
        y >= tY and y <= tY + tH
      )
    end,
    sign = function (value)
      return (value / math.abs(value))
    end,
    lerp = function (origin, target, duration, float)
      if duration == 0 then
        print("You tried to divide by zero!")
        return target
      end
      if float then
        return origin + ((target - origin) / duration)
      end
      return math.floor(origin + ((target - origin) / duration))
    end,
    ease = function (origin, target, duration, float)
      return math.floor(origin + ((target - origin) / 2))
    end
  }