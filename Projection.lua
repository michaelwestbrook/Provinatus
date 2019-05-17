local function DefaultProjection(X, Y)
  local Projection = {}
  -- Horizontal distance to target
  Projection.DistanceX = Provinatus.X - X
  -- Vertical distance to target
  Projection.DistanceY = Provinatus.Y - Y
  -- Angle to target.
  Projection.Phi = -1 * Provinatus.CameraHeading - math.atan2(Projection.DistanceY, Projection.DistanceX)
  -- The closer the target the more exaggerated the movement becomes. See 3d chart here https://www.wolframalpha.com/input/?i=min(atan(sqrt(x%5E2+%2B+y%5E2)%2F(sqrt(2)*tan(1))),+1)
  -- Magic number is approximation of sqrt(2) * tan(1). This value projects the distance to a value between 0 and  1ish.
  Projection.Distance =
    math.min(math.atan(math.sqrt((Projection.DistanceX * Projection.DistanceX) + (Projection.DistanceY * Projection.DistanceY)) / 2.2025071263 * Provinatus.SavedVars.Display.Zoom), 1)
  -- Calculates where to draw on the screen.
  Projection.X = -Projection.Distance * math.cos(Projection.Phi)
  Projection.Y = Projection.Distance * math.sin(Projection.Phi)
  Projection.XProjected = Provinatus.SavedVars.Display.X + Projection.X * Provinatus.SavedVars.Display.Size
  Projection.YProjected = Provinatus.SavedVars.Display.Y + Projection.Y * Provinatus.SavedVars.Display.Size

  if Provinatus.SavedVars.Display.Offset then
    Projection.YProjected = Projection.YProjected + Provinatus.SavedVars.Pointer.Size
  end

  return Projection
end

ProvinatusProjection = {}

ProvinatusProjection.Project = DefaultProjection
