-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
  Provinatus = {}

  -- This isn't strictly necessary, but we'll use this string later when registering events.
  -- Better to define it in a single place rather than retyping the same string.
  Provinatus.name = "Provinatus"
  
  -- Next we create a function that will initialize our addon
  function Provinatus:Initialize()
    self.inCombat = IsUnitInCombat("player")
    self.savedVariables = ZO_SavedVars:New(string.format("%sSavedVariables", Provinatus.name) , 1, nil, {})
    ProvinatusIndicator:SetHidden(not self.inCombat)
    EVENT_MANAGER:RegisterForEvent(Provinatus.name, EVENT_PLAYER_ACTIVATED, Provinatus.EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:RegisterForEvent(Provinatus.name, EVENT_PLAYER_COMBAT_STATE, Provinatus.EVENT_PLAYER_COMBAT_STATE)
  end
  
  function Provinatus.OnIndicatorMoveStop()
    Provinatus.savedVariables.left = ProvinatusIndicator:GetLeft()
    Provinatus.savedVariables.top = ProvinatusIndicator:GetTop()
  end
  
  function Provinatus:RestorePosition()
    local left = self.savedVariables.left
    local top = self.savedVariables.top
   
    ProvinatusIndicator:ClearAnchors()
    ProvinatusIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
  end
  
  -- Event Handlers
  function Provinatus.EVENT_PLAYER_ACTIVATED(eventCode, initial)
    d(Provinatus.name)
    Provinatus:RestorePosition()
  end
  
  -- Then we create an event handler function which will be called when the "addon loaded" event
  -- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
  function Provinatus.EVENT_ADD_ON_LOADED(event, addonName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addonName == Provinatus.name then
      Provinatus:Initialize()
    end
  end
  
  function Provinatus.EVENT_PLAYER_COMBAT_STATE(event, inCombat)
    -- -- The ~= operator is "not equal to" in Lua.
    if inCombat ~= Provinatus.inCombat then
      -- The player's state has changed. Update the stored state...
      Provinatus.inCombat = inCombat
  
      -- ...and then update the control.
      ProvinatusIndicator:SetHidden(not inCombat)
    end
  end
  
  -- Finally, we'll register our event handler function to be called when the proper event occurs.
  EVENT_MANAGER:RegisterForEvent(Provinatus.name, EVENT_ADD_ON_LOADED, Provinatus.EVENT_ADD_ON_LOADED)
  