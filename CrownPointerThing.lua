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

function CrownPointerThing.ClearTarget()
  d(GetString(PROVINATUS_CLEARED_CUSTOM_TARGET))
  CrownPointerThing.CustomTarget = nil
end

local function IsValidTarget(GroupNumber)
  return GroupNumber > 0 and GetUnitName(GetGroupUnitTagByIndex(GroupNumber)) ~= GetUnitName("player") and IsUnitOnline(GetGroupUnitTagByIndex(GroupNumber))
end

-- Group number can be found in the "Group & Activity Finder" menu.
local function SetTarget(GroupNumber)
  if GetGroupSize() > 0 and GroupNumber then
    if IsValidTarget(GroupNumber) then
      TargetUnitName = GetUnitName(GetGroupUnitTagByIndex(GroupNumber))
      d(GetString(PROVINATUS_SET_CUSTOM_TARGET) .. ": " .. TargetUnitName)
      CrownPointerThing.CustomTarget = TargetUnitName
    else
      d(GetString(PROVINATUS_CANNOT_SET_TARGET))
    end
  else
    d(GetString(PROVINATUS_NO_TARGET_PROVIDED))
    CrownPointerThing.ClearTarget()
  end
end

-- Gets the index of the current target or 0 otherwise.
local function GetTargetIndex()
  for i = 1, GetGroupSize() do
    if CrownPointerThing.CustomTarget ~= nil and GetUnitName(GetGroupUnitTagByIndex(i)) == CrownPointerThing.CustomTarget then
      return i
    elseif CrownPointerThing.CustomTarget == nil and GetGroupUnitTagByIndex(i) == GetGroupLeaderUnitTag() then
      return i
    end
  end

  return 0
end

function CrownPointerThing:NextTarget()
  local GroupSize = GetGroupSize()
  if GroupSize < 2 then
    -- TODO strings
    d(GetString(PROVINATUS_NEED_TWO_MEMBERS))
    return
  end
  -- Get current target sort index since we don't retain it
  local CurrentTargetIndex = GetTargetIndex()
  for i = 1, GroupSize do
    local TargetIndex = i + CurrentTargetIndex
    if TargetIndex > GroupSize then
      TargetIndex = TargetIndex % GroupSize
    end
    if IsValidTarget(TargetIndex) then
      SetTarget(TargetIndex)
      return
    end
  end
  d(GetString(PROVINATUS_NO_SUITABLE_TARGET))
end

function CrownPointerThing:Initialize()
  CrownPointerThing.SavedVars = ZO_SavedVars:NewAccountWide("CrownPointerThingSavedVariables", 1, nil, ProvinatusConfig)
  CrownPointerThing.reticle.Initialize()
  SLASH_COMMANDS["/settarget"] = SetTarget
  SLASH_COMMANDS["/cleartarget"] = CrownPointerThing.ClearTarget
end

-- TODO can this handle leader setting custom target?
function CrownPointerThing.GetGroupLeaderUnitTag()
  local IsCustomTargetSet = CrownPointerThing.CustomTarget ~= nil
  if GetGroupSize() > 0 then
    if not IsUnitGroupLeader("player") and not IsCustomTargetSet then
      return GetGroupLeaderUnitTag()
    elseif IsCustomTargetSet then
      -- TODO Cache this value
      for i = 1, GetGroupSize() do
        UnitTag = GetGroupUnitTagByIndex(i)
        if GetUnitName(UnitTag) == CrownPointerThing.CustomTarget and IsUnitOnline(UnitTag) then
          return UnitTag
        end
      end
      return GetGroupLeaderUnitTag()
    else
      return nil
    end
  else
    return nil
  end
end

function CrownPointerThing.OnUpdate()
  local leader = CrownPointerThing.GetGroupLeaderUnitTag()
  if leader ~= nil then
    CrownPointerThing.reticle.Hide(false)
    local Px, Py, Ph = GetMapPlayerPosition("player")
    local Tx, Ty, Th = GetMapPlayerPosition(leader)
    local Heading = GetPlayerCameraHeading()
    -- Debug override
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
  else
    CrownPointerThing.reticle.Hide(true)
  end
end
