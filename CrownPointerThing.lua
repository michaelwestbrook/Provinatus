CrownPointerThing = {}

CrownPointerThing.name = CustomProvTF.name

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

local function IsTFPresent()
  local manager = GetAddOnManager()
  for i = 1, manager:GetNumAddOns() do
    local name, _, _, _, _, state = manager:GetAddOnInfo(i)
    if name == "ProvisionsTeamFormation" and state == ADDON_STATE_ENABLED then
      return true
    end
  end
  return false
end

function CrownPointerThing.EVENT_ADD_ON_LOADED()
  CrownPointerThing:Initialize()
  if IsTFPresent() then
    d("Provinatus works best with 'ProvisionsTeamFormation' disabled")
  else
    CustomTeamFormation_OnInitialized()
  end
end
