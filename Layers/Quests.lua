ProvinatusQuests = {}

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

-- Copied from esoui source code compass.lua https://esodata.uesp.net/100018/src/ingame/compass/compass.lua.html#35
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

local function CreateElement(QuestPin)
  local Element = {}
  Element.Texture = QuestPin:GetQuestIcon()
  Element.X = QuestPin.normalizedX
  Element.Y = QuestPin.normalizedY
  Element.Alpha = Provinatus.SavedVars.Quest.Alpha
  Element.Height = Provinatus.SavedVars.Quest.Size
  Element.Width = Provinatus.SavedVars.Quest.Size
  return Element
end

function ProvinatusQuests.Update()
  local Elements = {}
  if Provinatus.SavedVars.Quest.Enabled then
    local QuestPins = GetQuestPins()
    for i = 1, #QuestPins do
      table.insert(Elements, CreateElement(QuestPins[i]))
    end
  end

  Provinatus.DrawElements(ProvinatusQuests, Elements)
end

function ProvinatusQuests.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_ACTIVE_QUEST,
    reference = "ProvinatusQuestMenu",
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_QUEST_ENABLE,
        getFunc = function()
          return Provinatus.SavedVars.Quest.Enabled
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Quest.Enabled = value
        end,
        tooltip = PROVINATUS_QUEST_ENABLE_TT,
        width = "full",
        default = ProvinatusConfig.Quest.Enabled
      },
      [2] = {
        type = "submenu",
        name = PROVINATUS_ICON_SETTINGS,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.Quest.Size
          end,
          function(value)
            Provinatus.SavedVars.Quest.Size = value
          end,
          function()
            return Provinatus.SavedVars.Quest.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.Quest.Alpha = value / 100
          end,
          ProvinatusConfig.Quest.Size,
          ProvinatusConfig.Quest.Alpha * 100,
          function()
            return not Provinatus.SavedVars.Quest.Enabled
          end
        )
      }
    }
  }
end

function ProvinatusQuests.SetMenuIcon()
  local Icon = ProvinatusMenu.DrawMenuIcon(ProvinatusQuestMenu.arrow, "esoui/art/quest/questjournal_trackedquest_icon.dds")
  Icon:SetDimensions(40, 40)
end
