ProvinatusHud = {}

local ClassMapping = {
  [1] = "Dragonknight",
  [2] = "Sorcerer",
  [3] = "Nightblade",
  [4] = "Warden",
  [6] = "Templar"
}

local function GetIconDimensions(UnitTag)
  -- TODO Leader might not be the 'group' leader
  if IsUnitGroupLeader(UnitTag) then
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
  if IsUnitDead(UnitTag) and not UnitHasBeenTendedTo(UnitTag) then
      G = 0
      B = 0
  else
    local health, maxHealth, effectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
    local ratio = health / maxHealth
    G = ratio
    B = ratio
  end
  return R, G, B
end

local function GetIconTexture(UnitTag)
  local Texture
  -- TODO this logic could prolly be handled more better
  if UnitHasBeenTendedTo(UnitTag) then
    Texture = CrownPointerThing.SavedVars.PlayerIcons.ResurrectionPending
  elseif IsUnitDead(UnitTag) then
    Texture = CrownPointerThing.SavedVars.PlayerIcons.Dead
  elseif IsUnitGroupLeader(UnitTag) then
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
  return Texture
end

local function GetLifeBarDimensions(UnitTag, IconX, IconY)
  local health, maxHealth, effectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
  local ratio = health / maxHealth
  -- TODO increase height based on IconY
  return IconX / 2 * ratio, 2
end

local function GetIconAlpha(UnitTag)
  local Apha
  if not IsUnitOnline(UnitTag) or ZO_ReticleContainer:IsHidden() then
    Alpha = 0
  elseif IsUnitGroupLeader(UnitTag) then
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

function ProvinatusHud:Initialize()
  self.Players = {}
end

function ProvinatusHud:OnUpdate()
  if not CrownPointerThing or not CrownPointerThing.SavedVars then
    return
  end

  for i = 1, GetGroupSize() do
    if self.Players[i] == nil then
      self.Players[i] = {}
      self.Players[i].Icon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.Players[i].LifeBar = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.Players[i].LifeBar:SetColor(1, 0, 0)
    end
    local UnitTag = "group" .. i
    -- If unit not in group, unit is me, or unit in a different zone than me...  hide icon
    if (not IsPlayerInGroup(GetUnitName(UnitTag)) or GetUnitName(UnitTag) == GetUnitName("player") or GetUnitZone(UnitTag) ~= GetUnitZone("player")) and self.Players[i] ~= nil then
      self.Players[i].Icon:SetAlpha(0)
      self.Players[i].LifeBar:SetAlpha(0)
    elseif GetUnitName(UnitTag) ~= GetUnitName("player") then
      local X, Y, Heading = GetMapPlayerPosition(UnitTag)
      local MyX, MyY, MyHeading = GetMapPlayerPosition("player")
      -- Horizontal distance to target
      local DistanceX = MyX - X
      -- Vertical distance to target
      local DistanceY = MyY - Y
      -- Angle to target. ¯\_(ツ)_/¯
      local Phi = -1 * GetPlayerCameraHeading() - math.atan2(DistanceY, DistanceX)
      -- The closer the target the more exaggerated the movement becomes.
      local DistanceProjected = math.atan(math.sqrt((DistanceX * DistanceX) + (DistanceY * DistanceY)) * 250) * (CrownPointerThing.SavedVars.HUD.Size / 2)
      -- Calculates where to draw on the screen.
      local XProjected = -DistanceProjected * math.cos(Phi)
      local YProjected = DistanceProjected * math.sin(Phi) + CrownPointerThing.SavedVars.CrownPointer.Size / 2

      -- Get icon dimensions
      local IconX, IconY = GetIconDimensions(UnitTag)
      local IconAlpha = GetIconAlpha(UnitTag)

      -- Need to flip the x axis.
      self.Players[i].Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
      self.Players[i].Icon:SetTexture(GetIconTexture(UnitTag))
      self.Players[i].Icon:SetDimensions(IconX, IconY)
      self.Players[i].Icon:SetColor(GetIconColor(UnitTag))
      self.Players[i].Icon:SetAlpha(IconAlpha)
      
      self.Players[i].LifeBar:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected + IconY * 0.4
    )
      self.Players[i].LifeBar:SetDimensions(GetLifeBarDimensions(UnitTag, IconX, IconY))
      self.Players[i].LifeBar:SetAlpha(GetLifeBarAlpha(UnitTag, IconAlpha))
    end
  end

  for i = GetGroupSize() + 1, #self.Players do
    -- TODO only hide if not already hidden.
    if self.Players[i] ~= nil and self.Players[i].Icon ~= nil then
      self.Players[i].Icon:SetAlpha(0)
      self.Players[i].LifeBar:SetAlpha(0)
    end
  end
end