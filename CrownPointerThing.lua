CrownPointerThing = {}

CrownPointerThing.name = ProvTF.name

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
  EVENT_MANAGER:RegisterForEvent(
    CrownPointerThing.name,
    EVENT_PLAYER_ACTIVATED,
    CrownPointerThing.EVENT_PLAYER_ACTIVATED
  )
end

function CrownPointerThing.EVENT_PLAYER_ACTIVATED(eventCode, initial)
  CrownPointerThingIndicator:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
  CrownPointerThing.reticle.Initialize()
end

function CrownPointerThing.onUpdate()
  local leader = GetGroupLeaderUnitTag()
  local Px, Py, Ph = GetMapPlayerPosition("player")
  local Tx, Ty, Th = GetMapPlayerPosition(leader)
  local Heading = GetPlayerCameraHeading()

  local DX = Px - Tx
  local DY = Py - Ty
  local D = math.sqrt((DX * DX) + (DY * DY))

  local Angle = NormalizeAngle(Heading - math.atan2(DX, DY))
  local Linear = Angle / math.pi
  local AbsoluteLinear = math.abs(Linear)

  CrownPointerThing.reticle.UpdateTexture(D, DX, DY, Angle, Linear, AbsoluteLinear)
end

function CrownPointerThing.EVENT_ADD_ON_LOADED(event, addonName)
  if addonName == CrownPointerThing.name then
    CrownPointerThing:Initialize()
  end
end
