Provinatus = {}

local function OnUpdate()
  if not ZO_WorldMap_IsWorldMapShowing() and not DoesCurrentMapMatchMapForPlayerLocation() and SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
    CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
  end

  Provinatus:SetPlayerData()
  for _, Layer in pairs(Provinatus.Layers) do
    if Layer.Update then
      Layer.Update()
    end
  end
end

local function OnPlayerActivated(EventCode, Initial)
  for _, Layer in pairs(Provinatus.Layers) do
    if Layer.Initialize then
      Layer.Initialize()
    end
  end

  ProvinatusMenu.Initialize()
  local Fragment = ZO_SimpleSceneFragment:New(Provinatus.TopLevelWindow)
  HUD_SCENE:AddFragment(Fragment)
  HUD_UI_SCENE:AddFragment(Fragment)
  SIEGE_BAR_SCENE:AddFragment(Fragment)

  EVENT_MANAGER:UnregisterForEvent("Provinatus", EventCode)
  EVENT_MANAGER:RegisterForUpdate("ProvinatusUpdate", 1000 / Provinatus.SavedVars.Display.RefreshRate, OnUpdate)
end

local function AddonLoaded(EventCode, AddonName)
  if AddonName == "Provinatus" then
    local ProvinatusLayers = {
      ProvinatusDisplay,
      ProvinatusCompass,
      ProvinatusPointer,
      ProvinatusTeam,
      ProvinatusAVA,
      ProvinatusQuests,
      ProvinatusWaypoint,
      ProvinatusSkyshards,
      ProvinatusTreasureMaps,
      ProvinatusPOI,
      ProvinatusLoreBooks,
      ProvinatusRallyPoint,
      ProvinatusPlayerOrientation,
      ProvinatusWorldEvents
    }
    Provinatus.Layers = {}
    Provinatus.Icons = {}
    Provinatus.SavedVars = ZO_SavedVars:NewAccountWide("ProvinatusVariables", 1, nil, ProvinatusConfig)
    Provinatus.TopLevelWindow = CreateTopLevelWindow("ProvinatusHUD")
    Provinatus.TopLevelWindow:SetAnchor(CENTER, nil, CENTER, Provinatus.SavedVars.Display.X, Provinatus.SavedVars.Display.Y)
    for _, Layer in pairs(ProvinatusLayers) do
      table.insert(Provinatus.Layers, Layer)
    end

    EVENT_MANAGER:RegisterForEvent("Provinatus", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    EVENT_MANAGER:UnregisterForEvent("Provinatus", EventCode)
  end
end

local function Fade(Alpha, Distance)
  return math.max(math.pow(Alpha * (1 - Distance), Provinatus.SavedVars.Display.FadeRate), Provinatus.SavedVars.Display.MinFade)
end

function Provinatus:SetPlayerData()
  local X, Y, Heading = GetMapPlayerPosition("player")
  self.X = X
  self.Y = Y
  self.Heading = Heading
  self.CameraHeading = GetPlayerCameraHeading()
  self.Zone = string.match(string.gsub(GetMapTileTexture(), "UI_Map_", ""), "%w+/%w+/%w+/(%w+_%w+)")
  self.GroupSize = GetGroupSize()
end

function Provinatus.DrawElements(Layer, Elements)
  if not Provinatus.Icons[Layer] and Elements ~= nil then
    Provinatus.Icons[Layer] = {}
  end

  local RenderedElements = {}

  if Elements ~= nil and #Elements > 0 then
    for Index, Element in pairs(Elements) do
      if not Provinatus.Icons[Layer][Index] then
        Provinatus.Icons[Layer][Index] = WINDOW_MANAGER:CreateControl(nil, Provinatus.TopLevelWindow, CT_TEXTURE)
      end

      Element.Projection = ProvinatusProjection.Project(Element.X, Element.Y)
      if Provinatus.SavedVars.Display.Fade then
        Provinatus.Icons[Layer][Index]:SetAlpha(Fade(Element.Alpha, Element.Projection.Distance))
      else
        Provinatus.Icons[Layer][Index]:SetAlpha(Element.Alpha)
      end

      Provinatus.Icons[Layer][Index]:SetAnchor(CENTER, Provinatus.TopLevelWindow, CENTER, Element.Projection.XProjected, Element.Projection.YProjected)
      Provinatus.Icons[Layer][Index]:SetDimensions(Element.Width, Element.Height)
      Provinatus.Icons[Layer][Index]:SetTexture(Element.Texture)

      -- Map the icon to the element in case the caller wants to modify it
      RenderedElements[Element] = Provinatus.Icons[Layer][Index]
    end
  end

  for Index, Icon in pairs(Provinatus.Icons[Layer]) do
    if Elements == nil or Index > #Elements then
      Icon:SetAlpha(0)
    end
  end

  return RenderedElements
end

function Provinatus.SetRefreshRate()
  EVENT_MANAGER:UnregisterForUpdate("ProvinatusUpdate")
  EVENT_MANAGER:RegisterForUpdate("ProvinatusUpdate", 1000 / Provinatus.SavedVars.Display.RefreshRate, OnUpdate)
end

EVENT_MANAGER:RegisterForEvent("Provinatus", EVENT_ADD_ON_LOADED, AddonLoaded)
