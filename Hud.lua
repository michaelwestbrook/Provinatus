ProvinatusHud = {}

local ClassMapping = {
  [1] = "Dragonknight",
  [2] = "Sorcerer",
  [3] = "Nightblade",
  [4] = "Warden",
  [6] = "Templar"
}

local function GetIconDimensions(UnitTag)
  if IsUnitGroupLeader(UnitTag) or GetUnitName(UnitTag) == CrownPointerThing.CustomTarget then
    return CrownPointerThing.SavedVars.HUD.TargetIconSize, CrownPointerThing.SavedVars.HUD.TargetIconSize
  else
    return CrownPointerThing.SavedVars.HUD.PlayerIconSize, CrownPointerThing.SavedVars.HUD.PlayerIconSize
  end
end

local function UnitHasBeenTendedTo(UnitTag)
  return IsUnitReincarnating(UnitTag) or IsUnitBeingResurrected(UnitTag) or DoesUnitHaveResurrectPending(UnitTag)
end

local function GetIconColor(UnitTag)
  local R, G, B = 1, 1, 1
  if not IsUnitDead(UnitTag) then
    local health, maxHealth, effectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
    local ratio = health / maxHealth
    G = ratio
    B = ratio
  elseif not DoesUnitHaveResurrectPending(UnitTag) then
    G = 0
    B = 0
  end
  return R, G, B
end

local function GetIconTexture(UnitTag)
  local Texture
  if IsUnitDead(UnitTag) then
    if UnitHasBeenTendedTo(UnitTag) then
      Texture = CrownPointerThing.SavedVars.PlayerIcons.ResurrectionPending
    else
      Texture = CrownPointerThing.SavedVars.PlayerIcons.Dead
    end
  else
    if IsUnitGroupLeader(UnitTag) then
      Texture = CrownPointerThing.SavedVars.PlayerIcons.Crown.Alive
    elseif CrownPointerThing.SavedVars.HUD.ShowRoleIcons then
      local IsDps, IsHealer, IsTank = GetGroupMemberRoles(UnitTag)
      local Role = "dps"
      if IsTank then
        Role = "tank"
      elseif IsHealer then
        Role = "healer"
      end
      Texture = "/esoui/art/lfg/lfg_" .. Role .. "_up.dds"
    else
      local Class = ClassMapping[GetUnitClassId(UnitTag)]
      if Class == nil then
        Texture = "/esoui/art/icons/mapkey/mapkey_groupmember.dds"
      else
        Texture = "esoui/art/contacts/social_classicon_" .. Class .. ".dds"
      end
    end
  end
  return Texture
end

local function GetLifeBarDimensions(UnitTag, IconX, IconY)
  local health, maxHealth, effectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
  local ratio = health / maxHealth
  -- TODO increase height based on IconY
  return IconX / 2 * ratio, 2
end

local function GetIconAlpha(UnitTag)
  local Alpha
  if not IsUnitGrouped(UnitTag) or not IsUnitOnline(UnitTag) or GetUnitZoneIndex("player") ~= GetUnitZoneIndex(UnitTag) then
    Alpha = 0
  elseif IsUnitGroupLeader(UnitTag) or GetUnitName(UnitTag) == CrownPointerThing.CustomTarget then
    Alpha = CrownPointerThing.SavedVars.HUD.TargetIconAlpha
  else
    Alpha = CrownPointerThing.SavedVars.HUD.PlayerIconAlpha
  end
  return Alpha
end

local function GetLifeBarAlpha(UnitTag, SuggestedAlpha)
  local Alpha = SuggestedAlpha or GetIconAlpha(UnitTag)
  if not IsUnitInCombat(UnitTag) then
    Alpha = 0
  end
  return Alpha
end

local function GetDrawLevel(UnitTag)
  if IsUnitGroupLeader(UnitTag) or GetUnitName(UnitTag) == CrownPointerThing.CustomTarget then
    return CrownPointerThing.SavedVars.HUD.TargetIconDrawLevel
  else
    return CrownPointerThing.SavedVars.HUD.PlayerIconDrawLevel
  end
end

local function GetProjectedCoordinates(X1, Y1, X2, Y2, CameraHeading)
  -- Horizontal distance to target
  local DistanceX = X1 - X2
  -- Vertical distance to target
  local DistanceY = Y1 - Y2
  -- Angle to target.
  local Phi = -1 * CameraHeading - math.atan2(DistanceY, DistanceX)
  -- The closer the target the more exaggerated the movement becomes. See 3d chart here https://www.wolframalpha.com/input/?i=atan(sqrt(x%5E2+%2B+y%5E2))
  local DistanceProjected = math.atan(math.sqrt((DistanceX * DistanceX) + (DistanceY * DistanceY)) * 250) * (CrownPointerThing.SavedVars.HUD.Size / 2)
  -- Calculates where to draw on the screen.
  local XProjected = -DistanceProjected * math.cos(Phi) + CrownPointerThing.SavedVars.HUD.PositionX
  local YProjected = DistanceProjected * math.sin(Phi) + CrownPointerThing.SavedVars.HUD.PositionY
  if CrownPointerThing.SavedVars.HUD.Offset then
    YProjected = YProjected + CrownPointerThing.SavedVars.CrownPointer.Size / 2
  end

  return XProjected, YProjected
end

function ProvinatusHud:Initialize()
  self.Players = {}
end

function ProvinatusHud:DrawWaypoint(MyX, MyY, CameraHeading)
  local WaypointX, WaypointY = GetMapPlayerWaypoint()
  if (WaypointX ~= 0 or WaypointY ~= 0) and CrownPointerThing.SavedVars.HUD.ShowMapPlayerWaypoint then
    local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, WaypointX, WaypointY, CameraHeading)
    if self.Waypoint == nil then
      self.Waypoint = {}
      self.Waypoint.Icon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.Waypoint.Icon:SetTexture("esoui/art/compass/compass_waypoint.dds")
    end

    self.Waypoint.Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
    self.Waypoint.Icon:SetAlpha(CrownPointerThing.SavedVars.HUD.PlayerWaypointIconAlpha)
    self.Waypoint.Icon:SetDimensions(CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize, CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize)
  elseif self.Waypoint ~= nil and self.Waypoint.Icon ~= nil and self.Waypoint.Icon:GetAlpha() ~= 0 then
    self.Waypoint.Icon:SetAlpha(0)
  end
end

function ProvinatusHud:DrawUnit(MyX, MyY, CameraHeading, UnitIndex)
  local UnitTag = "group" .. UnitIndex

  -- If unit not in group, unit is me, or unit in a different zone than me...  hide icon
  if GetUnitName(UnitTag) ~= GetUnitName("player") then
    if self.Players[UnitIndex] == nil then
      self.Players[UnitIndex] = {}
      self.Players[UnitIndex].Icon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.Players[UnitIndex].LifeBar = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.Players[UnitIndex].LifeBar:SetColor(1, 0, 0)
    end
    local X, Y, Heading = GetMapPlayerPosition(UnitTag)
    local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, X, Y, CameraHeading)
    -- Get icon dimensions
    local IconX, IconY = GetIconDimensions(UnitTag)
    local IconAlpha = GetIconAlpha(UnitTag)

    -- Get icon draw level
    local DrawLevel = GetDrawLevel(UnitTag)

    -- Need to flip the x axis.
    self.Players[UnitIndex].Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
    self.Players[UnitIndex].Icon:SetTexture(GetIconTexture(UnitTag))
    self.Players[UnitIndex].Icon:SetDimensions(IconX, IconY)
    self.Players[UnitIndex].Icon:SetColor(GetIconColor(UnitTag))
    self.Players[UnitIndex].Icon:SetAlpha(IconAlpha)
    self.Players[UnitIndex].Icon:SetDrawLevel(DrawLevel)

    self.Players[UnitIndex].LifeBar:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected + self.Players[UnitIndex].Icon:GetWidth() / 2)
    self.Players[UnitIndex].LifeBar:SetDimensions(GetLifeBarDimensions(UnitTag, IconX, IconY))
    self.Players[UnitIndex].LifeBar:SetAlpha(GetLifeBarAlpha(UnitTag, IconAlpha))
    self.Players[UnitIndex].LifeBar:SetDrawLevel(DrawLevel)
  end
end

function ProvinatusHud:OnUpdate()
  if not CrownPointerThing or not CrownPointerThing.SavedVars then
    return
  end

  local MyX, MyY, MyHeading = GetMapPlayerPosition("player")
  local CameraHeading = GetPlayerCameraHeading()
  self:DrawWaypoint(MyX, MyY, CameraHeading)
  for i = 1, GetGroupSize() do
    ProvinatusHud:DrawUnit(MyX, MyY, CameraHeading, i)
  end

  for i = GetGroupSize() + 1, #self.Players do
    if self.Players[i] ~= nil and self.Players[i].Icon ~= nil and self.Players[i].Icon:GetAlpha() ~= 0 then
      self.Players[i].Icon:SetAlpha(0)
      self.Players[i].LifeBar:SetAlpha(0)
    end
  end
end
