local Provinatus = {}

Provinatus.UpdateFunctions = {}

function Provinatus.OnUpdate()
  for key, UpdateFunction in pairs(Provinatus.UpdateFunctions) do
    UpdateFunction()
  end
end

function Provinatus.EVENT_ADD_ON_LOADED(eventCode, addonName)
  if addonName == ProvinatusConfig.Name then
    local TLW = CreateTopLevelWindow("CrownPointerThingIndicator")
    InitializeCrownPointer()
    TLW:SetAnchor(CENTER, nil, CENTER, CrownPointerThing.SavedVars.HUD.PositionX, CrownPointerThing.SavedVars.HUD.PositionY) -- TODO init saved var here
    ProvinatusMenu:Initialize()
    table.insert(
      Provinatus.UpdateFunctions,
      function()
        CrownPointerThing.OnUpdate()
      end
    )
    -- Check if Provision's Team Formation enabled.
    -- If it is, disable HUD and inform player.
    if (ProvTF == nil) then
      ProvinatusHud:Initialize()
      table.insert(
        Provinatus.UpdateFunctions,
        function()
          ProvinatusHud:OnUpdate()
        end
      )

      if (YACS == nil) then
        ProvinatusCompass:Initialize()
        table.insert(
          Provinatus.UpdateFunctions,
          function()
            ProvinatusCompass:OnUpdate()
          end
        )
      else
        d(GetString(PROVINATUS_DETECTED_YAC))
      end
    else
      d(GetString(PROVINATUS_DISABLE))
    end

    local fragment = ZO_SimpleSceneFragment:New(CrownPointerThingIndicator)
    HUD_SCENE:AddFragment(fragment)
    HUD_UI_SCENE:AddFragment(fragment)
    SIEGE_BAR_SCENE:AddFragment(fragment)
    EVENT_MANAGER:RegisterForUpdate(ProvinatusConfig.Name .. "Update", 1000 / CrownPointerThing.SavedVars.HUD.RefreshRate, Provinatus.OnUpdate)
    EVENT_MANAGER:UnregisterForEvent(ProvinatusConfig.Name, EVENT_ADD_ON_LOADED)
  elseif addonName == "ProvinatusBeta" then
    d("It appears you have Provinatus and ProvinatusBeta installed at the same time. Beta version is disabled.")
    EVENT_MANAGER:UnregisterForEvent(ProvinatusConfig.Name, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(ProvinatusConfig.Name, EVENT_ADD_ON_LOADED, Provinatus.EVENT_ADD_ON_LOADED)
