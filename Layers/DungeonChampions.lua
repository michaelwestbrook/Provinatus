local DungeonChampions = ZO_Object:Subclass()
local DisableDungeonChampions = DungeonChampions_GetLocalData == nil

local function CreateElement(ChampData)
  local Element
  local _, NumCompleted = GetAchievementCriterion(ChampData[3], ChampData[4])
  if NumCompleted == 0 or Provinatus.SavedVars.DungeonChampions.ShowDefeated then
    Element = {}
    Element.Height = Provinatus.SavedVars.DungeonChampions.Size
    Element.Width = Provinatus.SavedVars.DungeonChampions.Size
    Element.Alpha = Provinatus.SavedVars.DungeonChampions.Alpha
    Element.X = ChampData[1]
    Element.Y = ChampData[2]
    if NumCompleted == 0 then
      Element.Texture = "/esoui/art/icons/poi/poi_groupboss_incomplete.dds"
    else
      Element.Texture = "/esoui/art/icons/poi/poi_groupboss_complete.dds"
    end
  end

  return Element
end

function DungeonChampions:New(...)
  return ZO_Object.New(self)
end

function DungeonChampions:Update()
  if Provinatus.SavedVars.DungeonChampions.Enabled and not DisableDungeonChampions and DungeonChampions_GetLocalData then
    local Elements = {}
    local data = DungeonChampions_GetLocalData(Provinatus.Zone, Provinatus.Subzone)
    if data then
      for _, ChampData in pairs(data) do
        local Element = CreateElement(ChampData)
        if Element then
          table.insert(Elements, Element)
        end
      end
    end

    Provinatus.DrawElements(self, Elements)
  end
end

function DungeonChampions:GetMenu()
  local function getSize()
    return Provinatus.SavedVars.DungeonChampions.Size
  end

  local function setSize(value)
    Provinatus.SavedVars.DungeonChampions.Size = value
  end

  local function getAlpha()
    return Provinatus.SavedVars.DungeonChampions.Alpha * 100
  end

  local function setAlpha(value)
    Provinatus.SavedVars.DungeonChampions.Alpha = value / 100
  end

  local Controls = {
    [1] = {
      type = "checkbox",
      name = PROVINATUS_ENABLE,
      getFunc = function()
        return Provinatus.SavedVars.DungeonChampions.Enabled
      end,
      setFunc = function(value)
        Provinatus.SavedVars.DungeonChampions.Enabled = value
      end,
      width = "full",
      tooltip = PROVINATUS_DUNGEON_CHAMPIONS_ENABLE_TT,
      default = ProvinatusConfig.DungeonChampions.Enabled,
      disabled = DisableDungeonChampions
    },
    [2] = {
      type = "checkbox",
      name = PROVINATUS_DUNGEON_CHAMPIONS_SHOW_DEFEATED,
      getFunc = function()
        return Provinatus.SavedVars.DungeonChampions.ShowDefeated
      end,
      setFunc = function(value)
        Provinatus.SavedVars.DungeonChampions.ShowDefeated = value
      end,
      width = "full",
      default = ProvinatusConfig.DungeonChampions.ShowDefeated,
      disabled = DisableDungeonChampions
    },
    [3] = {
      type = "slider",
      name = PROVINATUS_ICON_SIZE,
      getFunc = getSize,
      setFunc = setSize,
      min = 20,
      max = 150,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_ICON_SIZE_TT,
      width = "half",
      default = ProvinatusConfig.DungeonChampions.Size,
      disabled = DisableDungeonChampions
    },
    [4] = {
      type = "slider",
      name = PROVINATUS_TRANSPARENCY,
      getFunc = getAlpha,
      setFunc = setAlpha,
      min = 0,
      max = 100,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_TRANSPARENCY_TT,
      width = "half",
      default = ProvinatusConfig.DungeonChampions.Alpha * 100,
      disabled = DisableDungeonChampions
    }
  }

  return {
    type = "submenu",
    name = PROVINATUS_DUNGEON_CHAMPIONS,
    tooltip = PROVINATUS_DUNGEON_CHAMPIONS_TT,
    reference = "ProvinatusDungeonChampionsMenu",
    controls = Controls
  }
end

function DungeonChampions:SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(
    ProvinatusDungeonChampionsMenu.arrow,
    "/esoui/art/icons/poi/poi_groupboss_complete.dds"
  )
end

-- TODO need to bite the bullet and switch to the `ZO_Object:Subclass()` model everywhere
local DUNGEON_CHAMPIONS = DungeonChampions:New()

ProvinatusDungeonChampions = {}

function ProvinatusDungeonChampions.Update()
  DUNGEON_CHAMPIONS:Update()
end

function ProvinatusDungeonChampions.GetMenu()
  return DUNGEON_CHAMPIONS:GetMenu()
end

function ProvinatusDungeonChampions.SetMenuIcon()
  return DUNGEON_CHAMPIONS:SetMenuIcon()
end
