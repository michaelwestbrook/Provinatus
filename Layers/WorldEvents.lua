local function GetCurrentWorldEvents(eventCode, _worldEventInstanceId_)
  for i = 1, GetNumWorldEventInstanceUnits(_worldEventInstanceId_) do
    local UnitTag = GetWorldEventInstanceUnitTag(_worldEventInstanceId_, i)
    local PinType = GetWorldEventInstanceUnitPinType(_worldEventInstanceId_, UnitTag)
    if UnitTag and PinType then
      ProvinatusWorldEvents.WorldEventUnitTags[UnitTag] = PinType
    end
  end
end

local function WorldEventUnitDestroyed(EventCode, _worldEventInstanceId_, _unitTag_)
  ProvinatusWorldEvents.WorldEventUnitTags[_unitTag_] = nil
end

local function WorldEventUnitChangedPinType(EventCode, _worldEventInstanceId_, _unitTag_, _oldPinType_, _newPinType_)
  ProvinatusWorldEvents.WorldEventUnitTags[_unitTag_] = _newPinType_
end

local function ApplyAnimation(Element, Icon)
  local IsAnimated = Element.PinData.isAnimated
  local IconHasAnimation = Icon.Animation ~= nil
  local AnimationPlaying = IconHasAnimation and Icon.Timeline:IsPlaying()
  if not IsAnimated and AnimationPlaying then
    Icon.Timeline:Stop()
    Icon.Animation:SetImageData(1, 1)
  elseif IsAnimated and IconHasAnimation and not AnimationPlaying then
    Icon.Animation:SetImageData(Element.PinData.framesWide, Element.PinData.framesHigh)
    Icon.Timeline:PlayFromStart()
  elseif IsAnimated and not IconHasAnimation then
    local animation, timeline = CreateSimpleAnimation(ANIMATION_TEXTURE, Icon)
    animation:SetImageData(Element.PinData.framesWide, Element.PinData.framesHigh)
    animation:SetFramerate(Element.PinData.framesPerSecond)
    timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
    timeline:PlayFromStart()
    Icon.Animation = animation
    Icon.Timeline = timeline
  end
end

local function SetColor(UnitTag, Icon)
  local health, maxHealth, effectiveMaxHealth = GetUnitPower(UnitTag, POWERTYPE_HEALTH)
  local ratio = health / maxHealth
  local G = ratio
  local B = ratio
  Icon:SetColor(1, G, B, Provinatus.SavedVars.WorldEvent.Alpha)
end

ProvinatusWorldEvents = {}

ProvinatusWorldEvents.WorldEventUnitTags = {}

function ProvinatusWorldEvents.Initialize()
  EVENT_MANAGER:RegisterForEvent(ProvinatusConfig.Name, EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE, WorldEventUnitChangedPinType)
  EVENT_MANAGER:RegisterForEvent(ProvinatusConfig.Name, EVENT_WORLD_EVENT_UNIT_DESTROYED, WorldEventUnitDestroyed)
  for i = 1, 5 do
    GetCurrentWorldEvents(0, i)
  end
end

function ProvinatusWorldEvents.Update()
  local Elements = {}
  if Provinatus.SavedVars.WorldEvent.Enabled then
    for UnitTag, PinType in pairs(ProvinatusWorldEvents.WorldEventUnitTags) do
      local X, Y, Heading, OnCurrentMap = GetMapPlayerPosition(UnitTag)
      if PinType and OnCurrentMap then
        local PinData = ZO_MapPin.PIN_DATA[PinType]
        local Element = {}
        Element.X = X
        Element.Y = Y
        Element.Texture = PinData.texture
        Element.Alpha = Provinatus.SavedVars.WorldEvent.Alpha
        Element.PinData = PinData
        Element.Height = Provinatus.SavedVars.WorldEvent.Size
        Element.Width = Provinatus.SavedVars.WorldEvent.Size
        Element.UnitTag = UnitTag
        table.insert(Elements, Element)
      end
    end
  end

  local RenderedElements = Provinatus.DrawElements(ProvinatusWorldEvents, Elements)
  for Element, Icon in pairs(RenderedElements) do
    ApplyAnimation(Element, Icon)
    SetColor(Element.UnitTag, Icon)
  end
end

function ProvinatusWorldEvents.GetMenu()
  local function getSize()
    return Provinatus.SavedVars.WorldEvent.Size
  end
  local function setSize(value)
    Provinatus.SavedVars.WorldEvent.Size = value
  end

  local function getAlpha()
    return Provinatus.SavedVars.WorldEvent.Alpha * 100
  end

  local function setAlpha(value)
    Provinatus.SavedVars.WorldEvent.Alpha = value / 100
  end

  return {
    type = "submenu",
    name = "World Events (Dragons)",
    reference = "ProvinatusWorldEventsMenu",
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_ENABLE,
        getFunc = function()
          return Provinatus.SavedVars.WorldEvent.Enabled
        end,
        setFunc = function(value)
          Provinatus.SavedVars.WorldEvent.Enabled = value
        end,
        tooltip = "Show world events on HUD",
        width = "full",
        default = ProvinatusConfig.WorldEvent.Enabled
      },
      [2] = {
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
        default = ProvinatusConfig.WorldEvent.Size
      },
      [3] = {
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
        default = ProvinatusConfig.WorldEvent.Alpha * 100
      }
    }
  }
end

function ProvinatusWorldEvents.SetMenuIcon(Panel)
  ProvinatusMenu.DrawMenuIcon(ProvinatusWorldEventsMenu.arrow, "EsoUI/Art/MapPins/Dragon_Fly.dds"):SetDimensions(50, 50)
end
