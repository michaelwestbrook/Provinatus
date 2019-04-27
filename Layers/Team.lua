ProvinatusTeam = {}

local ClassMapping = {
  [1] = "dragonknight",
  [2] = "sorcerer",
  [3] = "nightblade",
  [4] = "warden",
  [6] = "templar"
}

local function GetIconTexture(UnitTag)
  local Texture
  if IsUnitDead(UnitTag) then
    if IsUnitReincarnating(UnitTag) or IsUnitBeingResurrected(UnitTag) or DoesUnitHaveResurrectPending(UnitTag) then
      Texture = "/esoui/art/icons/poi/poi_groupboss_complete.dds"
    else
      Texture = "/esoui/art/icons/poi/poi_groupboss_incomplete.dds"
    end
  else
    if IsUnitGroupLeader(UnitTag) then
      Texture = "/esoui/art/icons/mapkey/mapkey_groupleader.dds"
    elseif Provinatus.SavedVars.Team.ShowRoleIcons then
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
        Texture = "/esoui/art/icons/class/class_" .. Class .. ".dds"
      end
    end
  end
  return Texture
end

local function GetColor(UnitTag)
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

local function CreateElement(UnitTag)
  if AreUnitsEqual("player", UnitTag) then
    return
  end

  local X, Y, _ = GetMapPlayerPosition(UnitTag)
  local R, G, B = GetColor(UnitTag)
  local Alpha, Size
  if Provinatus.CustomTarget == GetUnitName(UnitTag) or IsUnitGroupLeader(UnitTag) then
    Alpha = Provinatus.SavedVars.Team.Leader.Alpha
    Size = Provinatus.SavedVars.Team.Leader.Size
  else
    Alpha = Provinatus.SavedVars.Team.Teammate.Alpha
    Size = Provinatus.SavedVars.Team.Teammate.Size
  end

  local Element = {
    X = X,
    Y = Y,
    Alpha = Alpha,
    Height = Size,
    Width = Size,
    Texture = GetIconTexture(UnitTag),
    R = R,
    G = G,
    B = B,
    UnitTag = UnitTag
  }

  return Element
end

local function GetLifebarDimensions(UnitTag, Icon)
  local Health, MaxHealth, EffectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
  local IconWidth, IconHeight = Icon:GetDimensions()
  return IconWidth * (Health / MaxHealth), IconHeight / 9
end

local function SetLifeBar(Element, Icon)
  if Icon.ProvLifebar == nil then
    Icon.ProvLifebar = WINDOW_MANAGER:CreateControl(nil, Icon, CT_TEXTURE)
    Icon.ProvLifebar:SetColor(1, 0, 0)
  end

  if Provinatus.SavedVars.Team.Lifebars.Enabled and (not Provinatus.SavedVars.Team.Lifebars.OnlyInCombat or IsUnitInCombat(Element.UnitTag)) then
    Icon.ProvLifebar:SetDimensions(GetLifebarDimensions(Element.UnitTag, Icon))
    Icon.ProvLifebar:SetAlpha(1)
    Icon.ProvLifebar:SetAnchor(BOTTOM, Icon, BOTTOM, 0, 0)
  else
    Icon.ProvLifebar:SetAlpha(0)
  end
end

local function SetIconColor(Element, Icon) 
  Icon:SetColor(Element.R, Element.G, Element.B)
end

function ProvinatusTeam.Initialize()
  ProvinatusTeam.Icons = {}
  ProvinatusTeam.Lifebars = {}
end

function ProvinatusTeam.Update()
  local Elements = {}
  if Provinatus.GroupSize > 0 then
    for UnitIndex = 1, Provinatus.GroupSize do
      local UnitTag = ZO_Group_GetUnitTagForGroupIndex(UnitIndex)
      local Element = CreateElement(UnitTag)
      if Element ~= nil and IsUnitGrouped(UnitTag) and IsUnitOnline(UnitTag) and GetUnitZoneIndex("player") == GetUnitZoneIndex(UnitTag) then
        table.insert(Elements, Element)
      end
    end
  end

  for Element, Icon in pairs(Provinatus.DrawElements(ProvinatusTeam, Elements)) do
    SetIconColor(Element, Icon)
    SetLifeBar(Element, Icon)
  end
end

function ProvinatusTeam.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_GROUP,
    reference = "ProvinatusTeamMenu",
    controls = {
      [1] = {
        type = "submenu",
        name = PROVINATUS_LEADER_ICON,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.Team.Leader.Size
          end,
          function(value)
            Provinatus.SavedVars.Team.Leader.Size = value
          end,
          function()
            return Provinatus.SavedVars.Team.Leader.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.Team.Leader.Alpha = value / 100
          end,
          ProvinatusConfig.Team.Leader.Size,
          ProvinatusConfig.Team.Leader.Alpha * 100
        )
      },
      [2] = {
        type = "submenu",
        name = PROVINATUS_TEAM_ICON,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.Team.Teammate.Size
          end,
          function(value)
            Provinatus.SavedVars.Team.Teammate.Size = value
          end,
          function()
            return Provinatus.SavedVars.Team.Teammate.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.Team.Teammate.Alpha = value / 100
          end,
          ProvinatusConfig.Team.Teammate.Size,
          ProvinatusConfig.Team.Teammate.Alpha * 100
        )
      },
      [3] = {
        type = "submenu",
        name = "Life Bars",
        controls = {
          [1] = {
            type = "checkbox",
            name = PROVINATUS_HEALTH_SHOW, -- or string id or function returning a string
            getFunc = function()
              return Provinatus.SavedVars.Team.Lifebars.Enabled
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Team.Lifebars.Enabled = value
            end,
            tooltip = PROVINATUS_HEALTH_SHOW_TT,
            width = "full",
            default = ProvinatusConfig.Team.Lifebars.Enabled
          }
        },
        [2] = {
          type = "checkbox",
          name = PROVINATUS_HEALTH_COMBAT_ONLY, -- or string id or function returning a string
          getFunc = function()
            return Provinatus.SavedVars.Team.Lifebars.OnlyInCombat
          end,
          setFunc = function(value)
            Provinatus.SavedVars.Team.Lifebars.OnlyInCombat = value
          end,
          tooltip = PROVINATUS_HEALTH_COMBAT_ONLY_TT,
          width = "full",
          default = ProvinatusConfig.Team.Lifebars.OnlyInCombat
        }
      }
    }
  }
end

function ProvinatusTeam.SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(ProvinatusTeamMenu.arrow, "/esoui/art/compass/groupLeader.dds")
end
