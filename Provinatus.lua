Provinatus = {}

Provinatus.UpdateFunctions = {}
Provinatus.PerformingResurrection = false

function Provinatus.OnUpdate()
  for key, UpdateFunction in pairs(Provinatus.UpdateFunctions) do
    UpdateFunction()
  end
end

function Provinatus.EVENT_ADD_ON_LOADED(eventCode, addonName)
  if addonName == CrownPointerThing.name then
    CrownPointerThing:Initialize()
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

      ProvinatusCompass:Initialize()
      table.insert(
        Provinatus.UpdateFunctions,
        function()
          ProvinatusCompass:OnUpdate()
        end
      )
    else
      d("Disabling Provinatus HUD while Provision's Team Formation active")
    end

    EVENT_MANAGER:RegisterForUpdate(CrownPointerThing.name .. "Update", 1000 / CrownPointerThing.SavedVars.HUD.RefreshRate, Provinatus.OnUpdate)
    EVENT_MANAGER:RegisterForEvent(
      CrownPointerThing.name,
      EVENT_START_SOUL_GEM_RESURRECTION,
      function(eventId, duration)
        Provinatus.PerformingResurrection = true
      end
    )
    EVENT_MANAGER:RegisterForEvent(
      CrownPointerThing.name,
      EVENT_END_SOUL_GEM_RESURRECTION,
      function(eventId, duration)
        Provinatus.PerformingResurrection = false
      end
    )
  end
end

-- TODO load addon more smarter so others can use it
EVENT_MANAGER:RegisterForEvent(CrownPointerThing.name, EVENT_ADD_ON_LOADED, Provinatus.EVENT_ADD_ON_LOADED)
