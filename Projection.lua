ProvinatusProjection = {}

function ProvinatusProjection:GetOGProjection(X1, Y1, X2, Y2, CameraHeading)
  -- Horizontal distance to target
  local DistanceX = X1 - X2
  -- Vertical distance to target
  local DistanceY = Y1 - Y2
  -- Angle to target.
  local Phi = -1 * CameraHeading - math.atan2(DistanceY, DistanceX)
  -- The closer the target the more exaggerated the movement becomes. See 3d chart here https://www.wolframalpha.com/input/?i=arctan(sqrt(add(x%5E2,+y%5E2)))
  local DistanceProjected = math.min(math.atan(math.sqrt((DistanceX * DistanceX) + (DistanceY * DistanceY)) / math.sqrt(2) / math.tan(1) * CrownPointerThing.SavedVars.HUD.ZoomLevel), 1) * CrownPointerThing.SavedVars.HUD.Size
  -- Calculates where to draw on the screen.
  local XProjected = -DistanceProjected * math.cos(Phi) + CrownPointerThing.SavedVars.HUD.PositionX
  local YProjected = DistanceProjected * math.sin(Phi) + CrownPointerThing.SavedVars.HUD.PositionY
  if CrownPointerThing.SavedVars.HUD.Offset then
    YProjected = YProjected + CrownPointerThing.SavedVars.CrownPointer.Size / 2
  end

  return XProjected, YProjected
end
