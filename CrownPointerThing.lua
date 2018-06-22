CrownPointerThing = {}

CrownPointerThing.name = ProvinatusConfig.Name

CrownPointerThing.reticle = ArrowReticle

-- From Exterminatus http://www.esoui.com/downloads/info329-0.1.html
local function NormalizeAngle(c)
  if c > math.pi then
    return c - 2 * math.pi
  end
  if c < -math.pi then
    return c + 2 * math.pi
  end
  return c
end

function CrownPointerThing:Initialize()
  CrownPointerThing.SavedVars = ZO_SavedVars:NewAccountWide("CrownPointerThingSavedVariables", 1, nil, ProvinatusConfig)
  CrownPointerThingIndicator:SetAnchor(CENTER, GuiRoot, CENTER, 0, -CrownPointerThing.SavedVars.CrownPointer.Size / 2)
  CrownPointerThing.reticle.Initialize()
end

function CrownPointerThing.OnUpdate()
  local leader = GetGroupLeaderUnitTag()
  local Px, Py, Ph = GetMapPlayerPosition("player")
  local Tx, Ty, Th = GetMapPlayerPosition(leader)
  local Heading = GetPlayerCameraHeading()
  local CrownTargetOverride = CrownPointerThing.SavedVars.Debug and CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
  if CrownTargetOverride then
    Tx = CrownPointerThing.SavedVars.DebugSettings.TargetX
    Ty = CrownPointerThing.SavedVars.DebugSettings.TargetY
  end

  local DX = Px - Tx
  local DY = Py - Ty
  local D = math.sqrt((DX * DX) + (DY * DY))

  local Angle = NormalizeAngle(Heading - math.atan2(DX, DY))
  local Linear = Angle / math.pi
  local AbsoluteLinear = math.abs(Linear)

  if CrownTargetOverride then
    -- Set debug angle now so it does not have to be calculated again. 
    CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget = Angle
  end

  CrownPointerThing.reticle.UpdateTexture(D, DX, DY, Angle, Linear, AbsoluteLinear)
end
