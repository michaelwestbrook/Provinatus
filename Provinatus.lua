Provinatus = {}

local function OnUpdate()
  if not ZO_WorldMap_IsWorldMapShowing() and not DoesCurrentMapMatchMapForPlayerLocation() and SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
    CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
  end

  Provinatus:SetPlayerData()
  for _, Layer in pairs(Provinatus.Layers) do
    Layer.Update()
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
      ProvinatusCompass,
      ProvinatusPointer,
      ProvinatusQuests,
      ProvinatusWaypoint,
      ProvinatusSkyshards,
      ProvinatusTreasureMaps,
      ProvinatusPOI,
      ProvinatusLoreBooks,
      ProvinatusTeam,
      ProvinatusRallyPoint,
      ProvinatusPlayerOrientation
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

function Provinatus:SetPlayerData()
  local X, Y, Heading = GetMapPlayerPosition("player")
  self.X = X
  self.Y = Y
  self.Heading = Heading
  self.CameraHeading = GetPlayerCameraHeading()
  self.Zone = string.match(string.gsub(GetMapTileTexture(), "UI_Map_", ""), "%w+/%w+/%w+/(%w+_%w+)")
  self.GroupSize = GetGroupSize()
end

function Provinatus:ProjectCoordinates(X, Y)
  -- Horizontal distance to target
  local DistanceX = self.X - X
  -- Vertical distance to target
  local DistanceY = self.Y - Y
  -- Angle to target.
  local Phi = -1 * self.CameraHeading - math.atan2(DistanceY, DistanceX) -- TODO try minusing heading
  -- The closer the target the more exaggerated the movement becomes. See 3d chart here https://www.wolframalpha.com/input/?i=min(atan(sqrt(x%5E2%2By%5E2)%2F(sqrt(2)*tan(1))),+1)
  -- Magic number is approximation of sqrt(2) * tan(1). This value projects the distance to a value between 0 and  1ish.
  local DistanceProjected = math.min(math.atan(math.sqrt((DistanceX * DistanceX) + (DistanceY * DistanceY)) / 2.2025071263 * 250), 1) * Provinatus.SavedVars.Display.Size
  -- Calculates where to draw on the screen.
  local XProjected = -DistanceProjected * math.cos(Phi) + Provinatus.SavedVars.Display.X
  local YProjected = DistanceProjected * math.sin(Phi) + Provinatus.SavedVars.Display.Y

  if Provinatus.SavedVars.Display.Offset then
    YProjected = YProjected + Provinatus.SavedVars.Pointer.Size
  end

  return XProjected, YProjected
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

      local X, Y = Provinatus:ProjectCoordinates(Element.X, Element.Y)
      Provinatus.Icons[Layer][Index]:SetAlpha(Element.Alpha)
      Provinatus.Icons[Layer][Index]:SetAnchor(CENTER, Provinatus.TopLevelWindow, CENTER, X, Y)
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
