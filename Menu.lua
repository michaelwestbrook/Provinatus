ProvinatusMenu = {}
local function reset()
  CrownPointerThing.SavedVars.HUD.PlayerIconSize = ProvinatusConfig.HUD.PlayerIconSize
  CrownPointerThing.SavedVars.HUD.PlayerIconAlpha = ProvinatusConfig.HUD.PlayerIconAlpha
  CrownPointerThing.SavedVars.HUD.TargetIconSize = ProvinatusConfig.HUD.TargetIconSize
  CrownPointerThing.SavedVars.HUD.TargetIconAlpha = ProvinatusConfig.HUD.TargetIconAlpha
  CrownPointerThing.SavedVars.HUD.Compass.AlwaysOn = ProvinatusConfig.HUD.Compass.AlwaysOn
  CrownPointerThing.SavedVars.HUD.Compass.Alpha = ProvinatusConfig.HUD.Compass.Alpha
  CrownPointerThing.SavedVars.HUD.RefreshRate = ProvinatusConfig.HUD.RefreshRate
  CrownPointerThing.SavedVars.CrownPointer.Enabled = ProvinatusConfig.CrownPointer.Enabled
  CrownPointerThing.SavedVars.Debug = ProvinatusConfig.Debug
end

local function GetWarning()
  if (ProvTF ~= nil) then
    return {
      type = "description",
      -- TODO Get string from lang file
      title = "Detected Provision's Team Formation",
      text = "Disable Team Formation for the full Provinatus experience!",
      width = "full"
    }
  end
end

local function GetIconSettingsMenu(DescriptionText, GetSizeFunction, SetSizeFunction, GetAlphaFunction, SetAlphaFunction)
  local Settings = {
    [1] = {
      type = "description",
      text = DescriptionText,
      width = "full"
    },
    [2] = {
      type = "slider",
      name = PROVINATUS_ICON_SIZE,
      getFunc = GetSizeFunction,
      setFunc = SetSizeFunction,
      -- TODO set min max in config
      min = 20,
      max = 150,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_ICON_SIZE_TT,
      width = "half",
      disabled = ProvTF ~= nil
    },
    [3] = {
      type = "slider",
      name = PROVINATUS_TRANSPARENCY,
      getFunc = GetAlphaFunction,
      setFunc = SetAlphaFunction,
      -- TODO set min max in config
      min = 0,
      max = 100,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_TRANSPARENCY_TT,
      width = "half",
      disabled = ProvTF ~= nil
    }
  }

  return Settings
end

function ProvinatusMenu:Initialize()
  local panelData = {
    type = "panel",
    name = CrownPointerThing.name,
    displayName = CrownPointerThing.name,
    author = "Albino Python",
    version = "{{**DEVELOPMENTVERSION**}}",
    website = "http://www.esoui.com/downloads/info1943-Provinatus.html",
    keywords = "settings",
    slashCommand = "/provinatus",
    registerForRefresh = true,
    registerForDefaults = true,
    resetFunc = reset
  }

  local optionsData = {
    [1] = {
      type = "submenu",
      name = PROVINATUS_HUD,
      controls = {
        [1] = {
          type = "submenu",
          name = PROVINATUS_DISPLAY,
          controls = {
            [1] = {
              type = "slider",
              name = PROVINATUS_HUD_SIZE,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Size
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Size = value
              end,
              -- TODO set min max in config
              min = 100,
              max = 500,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Size
            }
          }
        },
        [2] = {
          type = "submenu",
          name = PROVINATUS_TEAM_ICON,
          controls = GetIconSettingsMenu(
            TEAMMATE_ICON_SETTINGS,
            function()
              return CrownPointerThing.SavedVars.HUD.PlayerIconSize
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.PlayerIconSize = value
            end,
            function()
              return CrownPointerThing.SavedVars.HUD.PlayerIconAlpha * 100
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.PlayerIconAlpha = value / 100
            end
          )
        },
        [3] = {
          type = "submenu",
          name = PROVINATUS_LEADER_ICON,
          controls = GetIconSettingsMenu(
            LEADER_ICON_SETTINGS,
            function()
              return CrownPointerThing.SavedVars.HUD.TargetIconSize
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.TargetIconSize = value
            end,
            function()
              return CrownPointerThing.SavedVars.HUD.TargetIconAlpha * 100
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.TargetIconAlpha = value / 100
            end
          )
        },
        [4] = {
          type = "submenu",
          name = PROVINATUS_COMPASS_SETTINGS,
          controls = {
            [1] = {
              type = "slider",
              name = PROVINATUS_TRANSPARENCY,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Compass.Alpha * 100
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Compass.Alpha = value / 100
              end,
              -- TODO set min max in config
              min = 0,
              max = 100,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              tooltip = PROVINATUS_ICON_SIZE_TT,
              width = "full",
              disabled = ProvTF ~= nil
            },
            [2] = {
              type = "checkbox",
              name = PROVINATUS_ALWAYS_ON,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Compass.AlwaysOn
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Compass.AlwaysOn = value
              end,
              tooltip = PROVINATUS_ALWAYS_ON_TT,
              width = "full",
              disabled = ProvTF ~= nil
            }
          }
        }
        -- TODO Put refresh rate into a submenu
        -- [4] = {
        --   type = "slider",
        --   name = PROVINATUS_REFRESH_RATE,
        --   getFunc = function()
        --     return CrownPointerThing.SavedVars.HUD.RefreshRate
        --   end,
        --   setFunc = function(value)
        --     CrownPointerThing.SavedVars.HUD.RefreshRate = value
        --   end,
        --   -- TODO set min max in config
        --   min = 24,
        --   max = 144,
        --   step = 1,
        --   clampInput = true,206) 588-1577
        --   decimals = 0,
        --   requiresReload = true,
        --   autoSelect = true,
        --   inputLocation = "below",
        --   width = "full"
        -- }
      }
    },
    [2] = {
      type = "submenu",
      name = CROWN_POINTER_THING,
      controls = {
        [1] = {
          type = "submenu",
          name = "Debug",
          controls = {
            [1] = {
              type = "checkbox",
              name = CROWN_POINTER_ENABLE_DEBUG,
              tooltip = CROWN_POINTER_ENABLE_DEBUG_TOOLTIP,
              getFunc = function()
                return CrownPointerThing.SavedVars.Debug
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.Debug = value
              end,
              width = "full",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled
              end
            },
            [2] = {
              type = "slider",
              name = CROWN_POINTER_DIRECTION,
              tooltip = CROWN_POINTER_DIRECTION_TOOLTIP,
              min = tonumber(string.format("%." .. (2 or 0) .. "f", -math.pi)),
              max = tonumber(string.format("%." .. (2 or 0) .. "f", math.pi)),
              step = math.pi / 16,
              getFunc = function()
                return tonumber(string.format("%." .. (2 or 0) .. "f", CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget))
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget = value
              end,
              width = "full",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug or CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end
            },
            [3] = {
              -- TODO strings file
              type = "checkbox",
              name = "Set Crown Position",
              tooltip = "Overrides 'Crown Pointer direction' setting",
              getFunc = function()
                return CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride = value
              end,
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug
              end,
              width = "half"
            },
            [4] = {
              type = "button",
              name = "Snap to me",
              func = function()
                local PlayerX, PlayerY, PlayerHeading = GetMapPlayerPosition("player")
                CrownPointerThing.SavedVars.DebugSettings.TargetX = PlayerX
                CrownPointerThing.SavedVars.DebugSettings.TargetY = PlayerY
              end,
              tooltip = "Set Crown Pointer to your current location",
              width = "half",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug or not CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end
            },
            [5] = {
              type = "slider",
              name = "Set Crown X",
              -- TODO use zo_round() to
              min = tonumber(string.format("%." .. (2 or 0) .. "f", 0)),
              max = tonumber(string.format("%." .. (2 or 0) .. "f", 1)),
              step = 1 / 100,
              getFunc = function()
                return tonumber(string.format("%." .. (2 or 0) .. "f", CrownPointerThing.SavedVars.DebugSettings.TargetX))
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.DebugSettings.TargetX = value
              end,
              width = "half",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug or not CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end
            },
            [6] = {
              type = "slider",
              name = "Set Crown Y",
              min = tonumber(string.format("%." .. (2 or 0) .. "f", 0)),
              max = tonumber(string.format("%." .. (2 or 0) .. "f", 1)),
              step = 1 / 100,
              getFunc = function()
                return tonumber(string.format("%." .. (2 or 0) .. "f", CrownPointerThing.SavedVars.DebugSettings.TargetY))
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.DebugSettings.TargetY = value
              end,
              width = "half",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug or not CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end
            }
          }
        }
      }
    },
    [3] = GetWarning()
  }

  local LAM2 = LibStub("LibAddonMenu-2.0")
  LAM2:RegisterAddonPanel(CrownPointerThing.name .. "Options", panelData)
  LAM2:RegisterOptionControls(CrownPointerThing.name .. "Options", optionsData)
end
