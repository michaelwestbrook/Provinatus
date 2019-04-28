local function DefaultProjection(X, Y)
    -- Horizontal distance to target
    local DistanceX = Provinatus.X - X
    -- Vertical distance to target
    local DistanceY = Provinatus.Y - Y
  -- Angle to target.
  local Phi = -1 * Provinatus.CameraHeading - math.atan2(DistanceY, DistanceX)
  -- The closer the target the more exaggerated the movement becomes. See 3d chart here https://www.wolframalpha.com/input/?i=min(atan(sqrt(x%5E2%2By%5E2)%2F(sqrt(2)*tan(1))),+1)
  -- Magic number is approximation of sqrt(2) * tan(1). This value projects the distance to a value between 0 and  1ish.
  local DistanceProjected = math.min(math.atan(math.sqrt((DistanceX * DistanceX) + (DistanceY * DistanceY)) / 2.2025071263 * 250), 1) * Provinatus.SavedVars.Display.Size
  -- Calculates where to draw on the screen.
  local XProjected = -DistanceProjected * math.cos(Phi) + Provinatus.SavedVars.Display.X
  local YProjected = DistanceProjected * math.sin(Phi) + Provinatus.SavedVars.Display.Y

  if Provinatus.SavedVars.Display.Offset then
    YProjected = YProjected + Provinatus.SavedVars.Pointer.Size
  end

  return XProjected, YProjected, DistanceProjected
end

ProvinatusProjection = {}

ProvinatusProjection.Project = DefaultProjection