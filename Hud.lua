ProvinatusHud = {}

local POIMapping = {
  ["/esoui/art/icons/poi/poi_areaofinterest_complete.dds"] = "AreaOfInterest",
  ["/esoui/art/icons/poi/poi_areaofinterest_incomplete.dds"] = "AreaOfInterest",
  ["/esoui/art/icons/poi/poi_ayleidruin_complete.dds"] = "AyleidRuin",
  ["/esoui/art/icons/poi/poi_ayleidruin_incomplete.dds"] = "AyleidRuin",
  ["/esoui/art/icons/poi/poi_ayliedruin_complete.dds"] = "AyleidRuin",
  ["/esoui/art/icons/poi/poi_ayliedruin_incomplete.dds"] = "AyleidRuin",
  ["/esoui/art/icons/poi/poi_battlefield_complete.dds"] = "Battlefield",
  ["/esoui/art/icons/poi/poi_battlefield_incomplete.dds"] = "Battlefield",
  ["/esoui/art/icons/poi/poi_camp_complete.dds"] = "Camp",
  ["/esoui/art/icons/poi/poi_camp_incomplete.dds"] = "Camp",
  ["/esoui/art/icons/poi/poi_cave_complete.dds"] = "Cave",
  ["/esoui/art/icons/poi/poi_cave_incomplete.dds"] = "Cave",
  ["/esoui/art/icons/poi/poi_cemetary_complete.dds"] = "Cemetary",
  ["/esoui/art/icons/poi/poi_cemetary_incomplete.dds"] = "Cemetary",
  ["/esoui/art/icons/poi/poi_cemetery_complete.dds"] = "Cemetary",
  ["/esoui/art/icons/poi/poi_cemetery_incomplete.dds"] = "Cemetary",
  ["/esoui/art/icons/poi/poi_city_complete.dds"] = "City",
  ["/esoui/art/icons/poi/poi_city_incomplete.dds"] = "City",
  ["/esoui/art/icons/poi/poi_crafting_complete.dds"] = "Crafting",
  ["/esoui/art/icons/poi/poi_crafting_incomplete.dds"] = "Crafting",
  ["/esoui/art/icons/poi/poi_crypt_complete.dds"] = "Crypt",
  ["/esoui/art/icons/poi/poi_crypt_incomplete.dds"] = "Crypt",
  ["/esoui/art/icons/poi/poi_daedricruin_complete.dds"] = "DaedricRuin",
  ["/esoui/art/icons/poi/poi_daedricruin_incomplete.dds"] = "DaedricRuin",
  ["/esoui/art/icons/poi/poi_darkbrotherhood_complete.dds"] = "DarkBrotherhood",
  ["/esoui/art/icons/poi/poi_darkbrotherhood_glow.dds"] = "DarkBrotherhood",
  ["/esoui/art/icons/poi/poi_darkbrotherhood_incomplete.dds"] = "DarkBrotherhood",
  ["/esoui/art/icons/poi/poi_delve_complete.dds"] = "Delve",
  ["/esoui/art/icons/poi/poi_delve_glow.dds"] = "Delve",
  ["/esoui/art/icons/poi/poi_delve_incomplete.dds"] = "Delve",
  ["/esoui/art/icons/poi/poi_dock_complete.dds"] = "Dock",
  ["/esoui/art/icons/poi/poi_dock_incomplete.dds"] = "Dock",
  ["/esoui/art/icons/poi/poi_dungeon_complete.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_dungeon_glow.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_dungeon_incomplete.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_dwemerruin_complete.dds"] = "DwemerRuin",
  ["/esoui/art/icons/poi/poi_dwemerruin_incomplete.dds"] = "DwemerRuin",
  ["/esoui/art/icons/poi/poi_estate_complete.dds"] = "Estate",
  ["/esoui/art/icons/poi/poi_estate_incomplete.dds"] = "Estate",
  ["/esoui/art/icons/poi/poi_explorable_complete.dds"] = "Explorable",
  ["/esoui/art/icons/poi/poi_explorable_incomplete.dds"] = "Explorable",
  ["/esoui/art/icons/poi/poi_farm_complete.dds"] = "Farm",
  ["/esoui/art/icons/poi/poi_farm_incomplete.dds"] = "Farm",
  ["/esoui/art/icons/poi/poi_gate_complete.dds"] = "Gate",
  ["/esoui/art/icons/poi/poi_gate_incomplete.dds"] = "Gate",
  ["/esoui/art/icons/poi/poi_groupboss_complete.dds"] = "GroupBoss",
  ["/esoui/art/icons/poi/poi_groupboss_incomplete.dds"] = "GroupBoss",
  ["/esoui/art/icons/poi/poi_groupdelve_complete.dds"] = "GroupDelve",
  ["/esoui/art/icons/poi/poi_groupdelve_glow.dds"] = "GroupDelve",
  ["/esoui/art/icons/poi/poi_groupdelve_incomplete.dds"] = "GroupDelve",
  ["/esoui/art/icons/poi/poi_groupinstance_complete.dds"] = "GroupInstance",
  ["/esoui/art/icons/poi/poi_groupinstance_glow.dds"] = "GroupInstance",
  ["/esoui/art/icons/poi/poi_groupinstance_incomplete.dds"] = "GroupInstance",
  ["/esoui/art/icons/poi/poi_group_areaofinterest_complete.dds"] = "GroupAreaOfInterest",
  ["/esoui/art/icons/poi/poi_group_areaofinterest_incomplete.dds"] = "GroupAreaOfInterest",
  ["/esoui/art/icons/poi/poi_group_ayliedruin_complete.dds"] = "GroupAyliedRuin",
  ["/esoui/art/icons/poi/poi_group_ayliedruin_incomplete.dds"] = "GroupAyliedRuin",
  ["/esoui/art/icons/poi/poi_group_battleground_complete.dds"] = "GroupBattleground",
  ["/esoui/art/icons/poi/poi_group_battleground_incomplete.dds"] = "GroupBattleground",
  ["/esoui/art/icons/poi/poi_group_camp_complete.dds"] = "GroupCamp",
  ["/esoui/art/icons/poi/poi_group_camp_incomplete.dds"] = "GroupCamp",
  ["/esoui/art/icons/poi/poi_group_cave_complete.dds"] = "GroupCave",
  ["/esoui/art/icons/poi/poi_group_cave_incomplete.dds"] = "GroupCave",
  ["/esoui/art/icons/poi/poi_group_cemetery_complete.dds"] = "GroupCemetery",
  ["/esoui/art/icons/poi/poi_group_cemetery_incomplete.dds"] = "GroupCemetery",
  ["/esoui/art/icons/poi/poi_group_crypt_complete.dds"] = "GroupCrypt",
  ["/esoui/art/icons/poi/poi_group_crypt_incomplete.dds"] = "GroupCrypt",
  ["/esoui/art/icons/poi/poi_group_dwemerruin_complete.dds"] = "GroupDwemerRuin",
  ["/esoui/art/icons/poi/poi_group_dwemerruin_incomplete.dds"] = "GroupDwemerRuin",
  ["/esoui/art/icons/poi/poi_group_estate_complete.dds"] = "GroupEstate",
  ["/esoui/art/icons/poi/poi_group_estate_incomplete.dds"] = "GroupEstate",
  ["/esoui/art/icons/poi/poi_group_gate_complete.dds"] = "GroupGate",
  ["/esoui/art/icons/poi/poi_group_gate_incomplete.dds"] = "GroupGate",
  ["/esoui/art/icons/poi/poi_group_house_glow.dds"] = "GroupHouse",
  ["/esoui/art/icons/poi/poi_group_house_owned.dds"] = "GroupHouse",
  ["/esoui/art/icons/poi/poi_group_house_unowned.dds"] = "GroupHouse",
  ["/esoui/art/icons/poi/poi_group_keep_complete.dds"] = "GroupKeep",
  ["/esoui/art/icons/poi/poi_group_keep_incomplete.dds"] = "GroupKeep",
  ["/esoui/art/icons/poi/poi_group_lighthouse_complete.dds"] = "GroupLighthouse",
  ["/esoui/art/icons/poi/poi_group_lighthouse_incomplete.dds"] = "GroupLighthouse",
  ["/esoui/art/icons/poi/poi_group_mine_complete.dds"] = "GroupMine",
  ["/esoui/art/icons/poi/poi_group_mine_incomplete.dds"] = "GroupMine",
  ["/esoui/art/icons/poi/poi_group_ruin_complete.dds"] = "GroupRuin",
  ["/esoui/art/icons/poi/poi_group_ruin_incomplete.dds"] = "GroupRuin",
  ["/esoui/art/icons/poi/poi_grove_complete.dds"] = "Grove",
  ["/esoui/art/icons/poi/poi_grove_incomplete.dds"] = "Grove",
  -- ["/esoui/art/icons/poi/poi_horserace_complete.dds"] = "HorseRace", -- No such thing right?
  -- ["/esoui/art/icons/poi/poi_horserace_incomplete.dds"] = "HorseRace",
  ["/esoui/art/icons/poi/poi_icsewer_complete.dds"] = "ICSewer",
  ["/esoui/art/icons/poi/poi_icsewer_incomplete.dds"] = "ICSewer",
  ["/esoui/art/icons/poi/poi_ic_boneshard_complete.dds"] = "BoneShard",
  ["/esoui/art/icons/poi/poi_ic_boneshard_incomplete.dds"] = "BoneShard",
  ["/esoui/art/icons/poi/poi_ic_daedricembers_complete.dds"] = "DaedricEmbers",
  ["/esoui/art/icons/poi/poi_ic_daedricembers_incomplete.dds"] = "DaedricEmbers",
  ["/esoui/art/icons/poi/poi_ic_daedricshackles_complete.dds"] = "DaedricShackles",
  ["/esoui/art/icons/poi/poi_ic_daedricshackles_incomplete.dds"] = "DaedricShackles",
  ["/esoui/art/icons/poi/poi_ic_darkether_complete.dds"] = "DarkEther",
  ["/esoui/art/icons/poi/poi_ic_darkether_incomplete.dds"] = "DarkEther",
  ["/esoui/art/icons/poi/poi_ic_marklegion_complete.dds"] = "MarkLegion",
  ["/esoui/art/icons/poi/poi_ic_marklegion_incomplete.dds"] = "MarkLegion",
  ["/esoui/art/icons/poi/poi_ic_monstrousteeth_complete.dds"] = "MonstrousTeeth",
  ["/esoui/art/icons/poi/poi_ic_monstrousteeth_incomplete.dds"] = "MonstrousTeeth",
  ["/esoui/art/icons/poi/poi_ic_planararmorscraps_complete.dds"] = "PlanarArmor",
  ["/esoui/art/icons/poi/poi_ic_planararmorscraps_incomplete.dds"] = "PlanarArmor",
  ["/esoui/art/icons/poi/poi_ic_tinyclaw_complete.dds"] = "TinyClaw",
  ["/esoui/art/icons/poi/poi_ic_tinyclaw_incomplete.dds"] = "TinyClaw",
  ["/esoui/art/icons/poi/poi_keep_complete.dds"] = "Keep",
  ["/esoui/art/icons/poi/poi_keep_incomplete.dds"] = "Keep",
  ["/esoui/art/icons/poi/poi_lighthouse_complete.dds"] = "Lighthouse",
  ["/esoui/art/icons/poi/poi_lighthouse_incomplete.dds"] = "Lighthouse",
  ["/esoui/art/icons/poi/poi_mine_compete.dds"] = "Mine",
  ["/esoui/art/icons/poi/poi_mine_complete.dds"] = "Mine",
  ["/esoui/art/icons/poi/poi_mine_incompete.dds"] = "Mine",
  ["/esoui/art/icons/poi/poi_mine_incomplete.dds"] = "Mine",
  ["/esoui/art/icons/poi/poi_mundus_complete.dds"] = "Mundus",
  ["/esoui/art/icons/poi/poi_mundus_incomplete.dds"] = "Mundus",
  ["/esoui/art/icons/poi/poi_portal_complete.dds"] = "Portal",
  ["/esoui/art/icons/poi/poi_portal_incomplete.dds"] = "Portal",
  ["/esoui/art/icons/poi/poi_publicdungeon_complete.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_publicdungeon_glow.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_publicdungeon_incomplete.dds"] = "Dungeon",
  ["/esoui/art/icons/poi/poi_raiddungeon_complete.dds"] = "RaidDungeon",
  ["/esoui/art/icons/poi/poi_raiddungeon_glow.dds"] = "RaidDungeon",
  ["/esoui/art/icons/poi/poi_raiddungeon_incomplete.dds"] = "RaidDungeon",
  ["/esoui/art/icons/poi/poi_ruin_complete.dds"] = "Ruin",
  ["/esoui/art/icons/poi/poi_ruin_incomplete.dds"] = "Ruin",
  ["/esoui/art/icons/poi/poi_sewer_complete.dds"] = "Sewer",
  ["/esoui/art/icons/poi/poi_sewer_glow.dds"] = "Sewer",
  ["/esoui/art/icons/poi/poi_sewer_incomplete.dds"] = "Sewer",
  ["/esoui/art/icons/poi/poi_soloinstance_complete.dds"] = "SoloInstance",
  ["/esoui/art/icons/poi/poi_soloinstance_glow.dds"] = "SoloInstance",
  ["/esoui/art/icons/poi/poi_soloinstance_incomplete.dds"] = "SoloInstance",
  ["/esoui/art/icons/poi/poi_solotrial_complete.dds"] = "SoloTrial",
  ["/esoui/art/icons/poi/poi_solotrial_glow.dds"] = "SoloTrial",
  ["/esoui/art/icons/poi/poi_solotrial_incomplete.dds"] = "SoloTrial",
  ["/esoui/art/icons/poi/poi_tower_complete.dds"] = "Tower",
  ["/esoui/art/icons/poi/poi_tower_incomplete.dds"] = "Tower",
  ["/esoui/art/icons/poi/poi_town_complete.dds"] = "Town",
  ["/esoui/art/icons/poi/poi_town_incomplete.dds"] = "Town",
  ["/esoui/art/icons/poi/poi_wayshrine_complete.dds"] = "Wayshrine",
  ["/esoui/art/icons/poi/poi_wayshrine_glow.dds"] = "Wayshrine",
  ["/esoui/art/icons/poi/poi_wayshrine_incomplete.dds"] = "Wayshrine",
  ["/esoui/art/icons/poi/poi_wayshrine_oneway_complete.dds"] = "Wayshrine",
  ["/esoui/art/icons/poi/poi_wayshrine_oneway_incomplete.dds"] = "Wayshrine"
}

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
  return ProvinatusProjection:GetOGProjection(X1, Y1, X2, Y2, CameraHeading)
end

local function GetQuestPins()
  local pins = ZO_WorldMap_GetPinManager():GetActiveObjects()
  local questPins = {}
  for pinKey, pin in pairs(pins) do
    local curIndex = pin:GetQuestIndex()
    if curIndex == QUEST_JOURNAL_MANAGER:GetFocusedQuestIndex() then
      table.insert(questPins, pin)
    end
  end

  return questPins
end

-- Copied from esoui source code compass.lua
local function IsPlayerInsideJournalQuestConditionGoalArea(journalIndex, stepIndex, conditionIndex)
  journalIndex = journalIndex - 1
  stepIndex = stepIndex - 1
  conditionIndex = conditionIndex - 1
  return IsPlayerInsidePinArea(MAP_PIN_TYPE_ASSISTED_QUEST_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_ASSISTED_QUEST_OPTIONAL_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_OPTIONAL_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_TRACKED_QUEST_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_TRACKED_QUEST_OPTIONAL_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_CONDITION, journalIndex, stepIndex, conditionIndex) or
    IsPlayerInsidePinArea(MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_OPTIONAL_CONDITION, journalIndex, stepIndex, conditionIndex)
end

local function IsPlayerInAreaPin()
  local _, visibility, stepType, stepOverrideText, conditionCount = GetJournalQuestStepInfo(QUEST_JOURNAL_MANAGER:GetFocusedQuestIndex(), QUEST_MAIN_STEP_INDEX)
  local Result = false
  for ConditionIndex = 1, conditionCount do
    if IsPlayerInsideJournalQuestConditionGoalArea(QUEST_JOURNAL_MANAGER:GetFocusedQuestIndex(), QUEST_MAIN_STEP_INDEX, ConditionIndex) then
      Result = true
      break
    end
  end

  return Result
end

local function DrawIcon(Icon, MyX, MyY, CameraHeading, TX, TY, Texture, Alpha, Width, Height)
  local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, TX, TY, CameraHeading)
  Icon:SetAlpha(Alpha)
  Icon:SetTexture(Texture)
  Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
  Icon:SetDimensions(Width, Height)
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
      self.Waypoint.Icon:SetDrawLevel(1)
    end

    self.Waypoint.Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
    self.Waypoint.Icon:SetAlpha(CrownPointerThing.SavedVars.HUD.PlayerWaypointIconAlpha)
    self.Waypoint.Icon:SetDimensions(CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize, CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize)
  elseif self.Waypoint ~= nil and self.Waypoint.Icon ~= nil and self.Waypoint.Icon:GetAlpha() ~= 0 then
    self.Waypoint.Icon:SetAlpha(0)
  end
end

function ProvinatusHud:DrawRallyPoint(MyX, MyY, CameraHeading)
  local RallyX, RallyY = GetMapRallyPoint()
  if (RallyX ~= 0 or RallyY ~= 0) and CrownPointerThing.SavedVars.HUD.ShowMapRallyPoint then
    local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, RallyX, RallyY, CameraHeading)
    if self.RallyPoint == nil then
      self.RallyPoint = {}
      self.RallyPoint.Icon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.RallyPoint.Icon:SetTexture("esoui/art/mappins/maprallypoint.dds")
      local animation, timeline = CreateSimpleAnimation(ANIMATION_TEXTURE, self.RallyPoint.Icon)
      animation:SetImageData(32, 1)
      animation:SetFramerate(CrownPointerThing.SavedVars.HUD.RefreshRate)
      timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
      timeline:PlayFromStart()
    end

    self.RallyPoint.Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
    self.RallyPoint.Icon:SetAlpha(CrownPointerThing.SavedVars.HUD.RallyPointIconAlpha)
    self.RallyPoint.Icon:SetDimensions(CrownPointerThing.SavedVars.HUD.RallyPointIconSize, CrownPointerThing.SavedVars.HUD.RallyPointIconSize)
  elseif self.RallyPoint ~= nil and self.RallyPoint.Icon ~= nil and self.RallyPoint.Icon:GetAlpha() ~= 0 then
    self.RallyPoint.Icon:SetAlpha(0)
  end
end

function ProvinatusHud:DrawQuestMarker(MyX, MyY, CameraHeading)
  if CrownPointerThing.SavedVars.HUD.ShowQuestMarker then
    if self.QuestMarkers == nil then
      self.QuestMarkers = {}
    end

    -- TODO cache this and use events to get quest pins
    local QuestPins = GetQuestPins()
    for i = 1, #QuestPins do
      if self.QuestMarkers[i] == nil then
        self.QuestMarkers[i] = {}
        self.QuestMarkers[i].Icon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
        self.QuestMarkers[i].Icon:SetDrawLevel(0)
      end

      if QuestPins[i] then
        local QuestTexture = QuestPins[i]:GetQuestIcon()
        local ProjectedX, ProjectedY = GetProjectedCoordinates(MyX, MyY, QuestPins[i].normalizedX, QuestPins[i].normalizedY, CameraHeading)
        self.QuestMarkers[i].Icon:SetDimensions(CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize, CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize)
        self.QuestMarkers[i].Icon:SetTexture(QuestTexture)
        self.QuestMarkers[i].Icon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, ProjectedX, ProjectedY)
        self.QuestMarkers[i].Icon:SetAlpha(CrownPointerThing.SavedVars.HUD.QuestMarkerIconAlpha)

        if QuestPins[i]:IsAreaPin() then
          if self.QuestMarkers[i].AreaIcon == nil then
            self.QuestMarkers[i].AreaIcon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
          end

          self.QuestMarkers[i].AreaIcon:SetDimensions(CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize, CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize)
          if IsPlayerInAreaPin() then
            self.QuestMarkers[i].AreaIcon:SetTexture("esoui/art/mappins/map_assistedareapin.dds")
          else
            self.QuestMarkers[i].AreaIcon:SetTexture("esoui/art/mappins/map_areapin.dds")
          end
          self.QuestMarkers[i].AreaIcon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, ProjectedX, ProjectedY)
          self.QuestMarkers[i].AreaIcon:SetAlpha(CrownPointerThing.SavedVars.HUD.QuestMarkerIconAlpha)
        elseif self.QuestMarkers[i].AreaIcon then
          self.QuestMarkers[i].AreaIcon:SetAlpha(0)
        end
      else
        self.QuestMarkers[i]:SetAlpha(0)
        if self.QuestMarkers[i].AreaIcon then
          self.QuestMarkers[i].AreaIcon:SetAlpha(0)
        end
      end
    end

    for i = #QuestPins + 1, #self.QuestMarkers do
      self.QuestMarkers[i].Icon:SetAlpha(0)
      if self.QuestMarkers[i].AreaIcon then
        self.QuestMarkers[i].AreaIcon:SetAlpha(0)
      end
    end
  elseif self.QuestMarkers then
    for i = 1, #self.QuestMarkers do
      self.QuestMarkers[i].Icon:SetAlpha(0)
    end
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

function ProvinatusHud:DrawSkyshards(MyX, MyY, CameraHeading)
  if self.SkyShards == nil then
    self.SkyShards = {}
  end

  local ShardData = MapPins_SkyShards[string.match(string.gsub(GetMapTileTexture(), "UI_Map_", ""), "%w+/%w+/%w+/(%w+_%w+)")]
  if ShardData ~= nil and CrownPointerThing.SavedVars.HUD.Skyshards.Enabled then
    local Index = 1
    for _, pinData in pairs(ShardData) do
      local _, NumCompleted, NumRequired = GetAchievementCriterion(pinData[3], pinData[4])
      if self.SkyShards[Index] == nil then
        self.SkyShards[Index] = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      end

      local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, pinData[1], pinData[2], CameraHeading)
      if NumCompleted == NumRequired then
        if CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards then
          self.SkyShards[Index]:SetDimensions(CrownPointerThing.SavedVars.HUD.Skyshards.KnownSize, CrownPointerThing.SavedVars.HUD.Skyshards.KnownSize)
          self.SkyShards[Index]:SetTexture("/esoui/art/icons/achievements_indexicon_skyshards_up.dds")
          self.SkyShards[Index]:SetAlpha(CrownPointerThing.SavedVars.HUD.Skyshards.KnownAlpha)
        else
          self.SkyShards[Index]:SetAlpha(0)
        end
      else
        self.SkyShards[Index]:SetDimensions(CrownPointerThing.SavedVars.HUD.Skyshards.UnknownSize, CrownPointerThing.SavedVars.HUD.Skyshards.UnknownSize)
        self.SkyShards[Index]:SetTexture("/esoui/art/icons/achievements_indexicon_skyshards_down.dds")
        self.SkyShards[Index]:SetAlpha(CrownPointerThing.SavedVars.HUD.Skyshards.UnknownAlpha)
      end

      self.SkyShards[Index]:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
      Index = Index + 1
    end

    for i = #ShardData + 1, #self.SkyShards do -- TODO Check that this clears correctly
      self.SkyShards[i]:SetAlpha(0)
    end
  else
    for i = 1, #self.SkyShards do
      self.SkyShards[i]:SetAlpha(0)
    end
  end
end

function ProvinatusHud:DrawLostTreasure(MyX, MyY, CameraHeading)
  if not LOST_TREASURE_DATA then
    return
  end

  -- Lost Treasure code from here...
  local Subzone = string.match(GetMapTileTexture(), "%w+/%w+/%w+/(%w+)_%w+_%d.dds")
  local LostTreasureData = LOST_TREASURE_DATA[Subzone]
  if LostTreasureData and CrownPointerThing.SavedVars.HUD.LostTreasure.Enabled then
    local function getItemLinkFromItemId(itemId)
      local Name = GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE, itemId, 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0))
      local Link = ZO_LinkHandler_CreateLinkWithoutBrackets(zo_strformat("<<t:1>>", Name), nil, ITEM_LINK_TYPE, itemId, 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0)
      return string.match(Link, "|H0:item:%d+:%d:%d%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d+:%d") .. "|h|h"
    end

    local MapBag = {}
    for Type, ZoneData in pairs(LostTreasureData) do
      for _, MapData in ipairs(ZoneData) do
        local Bag, _, _ = GetItemLinkStacks(getItemLinkFromItemId(MapData[LOST_TREASURE_INDEX.ITEMID]))
        if Bag ~= 0 then
          table.insert(MapBag, MapData)
        end
      end
    end

    -- basically to here

    if self.LostTreasure == nil then
      self.LostTreasure = {}
      self.LostTreasure.Icons = {}
    end

    for i = 1, #MapBag do
      if self.LostTreasure.Icons[i] == nil then
        self.LostTreasure.Icons[i] = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      end

      local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, MapBag[i][LOST_TREASURE_INDEX.X], MapBag[i][LOST_TREASURE_INDEX.Y], CameraHeading)
      self.LostTreasure.Icons[i]:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, XProjected, YProjected)
      self.LostTreasure.Icons[i]:SetAlpha(CrownPointerThing.SavedVars.HUD.LostTreasure.Alpha)
      self.LostTreasure.Icons[i]:SetDimensions(CrownPointerThing.SavedVars.HUD.LostTreasure.Size, CrownPointerThing.SavedVars.HUD.LostTreasure.Size)
      self.LostTreasure.Icons[i]:SetTexture("/LostTreasure/Icons/x_red.dds")
    end

    for i = #MapBag + 1, #self.LostTreasure.Icons do
      self.LostTreasure.Icons[i]:SetAlpha(0)
    end
  else
    if self.LostTreasure then
      for i = 1, #self.LostTreasure.Icons do
        self.LostTreasure.Icons[i]:SetAlpha(0)
      end
    end
  end
end

function ProvinatusHud:DrawMyIcon(Heading, CameraHeading)
  if CrownPointerThing.SavedVars.HUD.MyIcon.Enabled then
    if self.MyIcon == nil then
      self.MyIcon = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      self.MyIcon:SetTexture("/esoui/art/icons/mapkey/mapkey_player.dds")
      self.MyIcon:SetDrawLevel(100)
    end

    local Y = CrownPointerThing.SavedVars.HUD.PositionY
    if CrownPointerThing.SavedVars.HUD.Offset then
      Y = Y + CrownPointerThing.SavedVars.CrownPointer.Size / 2
    end

    self.MyIcon:SetAlpha(CrownPointerThing.SavedVars.HUD.MyIcon.Alpha)
    self.MyIcon:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, CrownPointerThing.SavedVars.HUD.PositionX, Y)
    self.MyIcon:SetDimensions(CrownPointerThing.SavedVars.HUD.MyIcon.Size, CrownPointerThing.SavedVars.HUD.MyIcon.Size)
    self.MyIcon:SetTextureRotation(CameraHeading - Heading)
  else
    if self.MyIcon then
      self.MyIcon:SetAlpha(0)
    end
  end
end

function ProvinatusHud:DrawPOI(MyX, MyY, CameraHeading)
  if not CrownPointerThing.SavedVars.HUD.POI.Enabled then
    if self.Destinations then
      for key, value in pairs(self.Destinations) do
        value:SetAlpha(0)
      end
    end

    return
  end

  if self.Destinations == nil then
    self.Destinations = {}
  end

  local zoneIndex = GetCurrentMapZoneIndex()
  for poiIndex = 1, GetNumPOIs(zoneIndex) do
    local normalizedX, normalizedY, poiType, icon, isShownInCurrentMap, linkedCollectibleIsLocked, isDiscovered, isNearby = GetPOIMapInfo(zoneIndex, poiIndex)
    local POIType = POIMapping[icon]
    if POIType and CrownPointerThing.SavedVars.HUD.POI[POIType] and (not isDiscovered or CrownPointerThing.SavedVars.HUD.POI.ShowKnownPOI) and isShownInCurrentMap then
      local XProjected, YProjected = GetProjectedCoordinates(MyX, MyY, normalizedX, normalizedY, CameraHeading)
      if self.Destinations[poiIndex] == nil then
        self.Destinations[poiIndex] = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
      end

      DrawIcon(
        self.Destinations[poiIndex],
        MyX,
        MyY,
        CameraHeading,
        normalizedX,
        normalizedY,
        icon,
        CrownPointerThing.SavedVars.HUD.POI.Alpha,
        CrownPointerThing.SavedVars.HUD.POI.Size,
        CrownPointerThing.SavedVars.HUD.POI.Size
      )
    elseif self.Destinations[poiIndex] and self.Destinations[poiIndex]:GetAlpha() ~= 0 then
      self.Destinations[poiIndex]:SetAlpha(0)
    end
  end

  for key, value in pairs(self.Destinations) do
    if key > GetNumPOIs(zoneIndex) and value:GetAlpha() ~= 0 then
      value:SetAlpha(0)
    end
  end
end

function ProvinatusHud:DrawLoreBooks(MyX, MyY, CameraHeading)
  if LoreBooks_GetLocalData == nil then
    return
  end

  if self.LoreBooks == nil then
    self.LoreBooks = {}
  end

  local lorebooks = LoreBooks_GetLocalData(select(3, (GetMapTileTexture()):lower():find("maps/([%w%-]+)/([%w%-]+_[%w%-]+)")))
  if CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled then
    if lorebooks then
      for i, pinData in ipairs(lorebooks) do
        local _, Texture, Known = GetLoreBookInfo(1, pinData[3], pinData[4])

        if self.LoreBooks[i] == nil then
          self.LoreBooks[i] = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_TEXTURE)
        end

        if not Known or CrownPointerThing.SavedVars.HUD.LoreBooks.ShowKnownLoreBooks then
          DrawIcon(
            self.LoreBooks[i],
            MyX,
            MyY,
            CameraHeading,
            pinData[1],
            pinData[2],
            Texture,
            CrownPointerThing.SavedVars.HUD.LoreBooks.Alpha,
            CrownPointerThing.SavedVars.HUD.LoreBooks.Size,
            CrownPointerThing.SavedVars.HUD.LoreBooks.Size
          )
        elseif self.LoreBooks[i]:GetAlpha() ~= 0 then
          self.LoreBooks[i]:SetAlpha(0)
        end
      end
    end
  end

  local i
  if lorebooks == nil then
    i = 0
  else
    i = #lorebooks
  end

  for key, value in pairs(self.LoreBooks) do
    if not CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled or key > i and value:GetAlpha() ~= 0 then
      value:SetAlpha(0)
    end
  end
end

function ProvinatusHud:OnUpdate()
  if not CrownPointerThing or not CrownPointerThing.SavedVars then
    return
  end

  if not ZO_WorldMap_IsWorldMapShowing() and not DoesCurrentMapMatchMapForPlayerLocation() and SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
    CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
  end

  local MyX, MyY, MyHeading = GetMapPlayerPosition("player")
  local CameraHeading = GetPlayerCameraHeading()
  self:DrawWaypoint(MyX, MyY, CameraHeading)
  self:DrawRallyPoint(MyX, MyY, CameraHeading)
  self:DrawQuestMarker(MyX, MyY, CameraHeading)
  self:DrawSkyshards(MyX, MyY, CameraHeading)
  self:DrawLostTreasure(MyX, MyY, CameraHeading)
  self:DrawMyIcon(CameraHeading, MyHeading)
  self:DrawPOI(MyX, MyY, CameraHeading)
  self:DrawLoreBooks(MyX, MyY, CameraHeading)
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
