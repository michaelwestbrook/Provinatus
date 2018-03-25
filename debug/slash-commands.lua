DebugSlashCommands = {}

function DebugSlashCommands:AddSlashCommand(command, action)
  SLASH_COMMANDS[command] = action
  d(command .. ' slash command added by Provinatus')
end

function DebugSlashCommands.SetDebugAngle(angle)
  if (angle == nil or angle == "") then
    d("Throw me a float from -pi to pi")
  else
    local castedAngle = tonumber(angle)
    if type(castedAngle) ~= "number" then
      error("number expected")
      return
    end
    CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget = castedAngle
  end
end

-- TODO WTH is up with colons and dots?
function DebugSlashCommands:AddDebugSlashCommands()
  DebugSlashCommands:AddSlashCommand("/pangle", DebugSlashCommands.SetDebugAngle)
end

function DebugSlashCommands.SetDebug(arg)
  CrownPointerThing.SavedVars.Debug = arg
  if CrownPointerThing.SavedVars.Debug then
    d("Enabled Provinatus debug")
    DebugSlashCommands.AddDebugSlashCommands()
  else
    d("Disabled debug (/reloadui to disable Provinatus debug slash commands.")
  end
end
