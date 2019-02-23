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
  CrownPointerThing.SavedVars.CrownPointer.Size = ProvinatusConfig.CrownPointer.Size
  CrownPointerThing.SavedVars.CrownPointer.Alpha = ProvinatusConfig.CrownPointer.Alpha
  CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize = ProvinatusConfig.HUD.PlayerWaypointIconSize
  CrownPointerThing.SavedVars.HUD.PlayerWaypointIconAlpha = ProvinatusConfig.HUD.PlayerWaypointIconAlpha
  CrownPointerThing.SavedVars.HUD.RallyPointIconSize = ProvinatusConfig.HUD.RallyPointIconSize
  CrownPointerThing.SavedVars.HUD.RallyPointIconAlpha = ProvinatusConfig.HUD.RallyPointIconAlpha
  CrownPointerThing.SavedVars.HUD.ShowQuestMarker = ProvinatusConfig.HUD.ShowQuestMarker
  CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize = ProvinatusConfig.HUD.QuestMarkerIconSize
  CrownPointerThing.SavedVars.HUD.QuestMarkerIconAlpha = ProvinatusConfig.HUD.QuestMarkerIconAlpha
  CrownPointerThing.SavedVars.HUD.Skyshards.Enabled = ProvinatusConfig.HUD.Skyshards.Enabled
  CrownPointerThing.SavedVars.HUD.Skyshards.KnownSize = ProvinatusConfig.HUD.Skyshards.KnownSize
  CrownPointerThing.SavedVars.HUD.Skyshards.KnownAlpha = ProvinatusConfig.HUD.Skyshards.KnownAlpha
  CrownPointerThing.SavedVars.HUD.Skyshards.UnknownSize = ProvinatusConfig.HUD.Skyshards.UnknownSize
  CrownPointerThing.SavedVars.HUD.Skyshards.UnknownAlpha = ProvinatusConfig.HUD.Skyshards.UnknownAlpha
end

local function GetWarning()
  if (ProvTF ~= nil) then
    return {
      type = "description",
      title = PROVINATUS_DETECTED_TF,
      text = PROVINATUS_DETECTED_TF_TEXT,
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

local function GetPointerIconSettings()
  local Menu =
    GetIconSettingsMenu(
    PROVINATUS_INDICATOR_SETTINGS,
    function()
      return CrownPointerThing.SavedVars.CrownPointer.Size
    end,
    function(value)
      CrownPointerThing.SavedVars.CrownPointer.Size = value
    end,
    function()
      return CrownPointerThing.SavedVars.CrownPointer.Alpha * 100
    end,
    function(value)
      CrownPointerThing.SavedVars.CrownPointer.Alpha = value / 100
    end
  )
  local Button = {
    type = "button",
    name = PROVINATUS_RESET_CUSTOM_TARGET,
    func = function()
      CrownPointerThing.CustomTarget = nil
    end,
    tooltip = function()
      if CrownPointerThing.CustomTarget == nil then
        return "'/settarget <group number>' " .. GetString(PROVINATUS_TO_SET_CUSTOM_TARGET)
      else
        return GetString(PROVINATUS_CLEARS_CUSTOM_TARGET)
      end
    end,
    width = "full"
  }

  table.insert(Menu, Button)
  return Menu
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
              type = "checkbox",
              name = PROVINATUS_SHOW_ROLE_ICONS,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.ShowRoleIcons
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.ShowRoleIcons = value
              end,
              tooltip = PROVINATUS_SHOW_ROLE_ICONS_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.ShowRoleIcons
            },
            [2] = {
              type = "slider",
              name = PROVINATUS_HUD_SIZE,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Size
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Size = value
                if CrownPointerThing.SavedVars.HUD.Compass.LockToHUD then
                  CrownPointerThing.SavedVars.HUD.Compass.Size = value
                end
              end,
              -- TODO set min max in config
              min = 25,
              max = 500,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Compass.Size
            },
            [3] = {
              type = "slider",
              name = PROVINATUS_REFRESH_RATE,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.RefreshRate
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.RefreshRate = value
              end,
              -- TODO set min max in config
              min = 24,
              max = 60,
              step = 1,
              clampInput = true,
              decimals = 0,
              requiresReload = true,
              autoSelect = true,
              inputLocation = "below",
              width = "full"
            },
            [4] = {
              type = "slider",
              name = PROVINATUS_HORIZONTAL_POSITION,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.PositionX
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.PositionX = value
              end,
              min = -GuiRoot:GetWidth() / 2,
              max = GuiRoot:GetWidth() / 2,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              width = "half",
              default = ProvinatusConfig.HUD.PositionX
            },
            [5] = {
              type = "slider",
              name = PROVINATUS_VERTICAL_POSITION,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.PositionY
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.PositionY = value
              end,
              min = -GuiRoot:GetHeight() / 2,
              max = GuiRoot:GetHeight() / 2,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              width = "half",
              default = ProvinatusConfig.HUD.PositionY
            },
            [6] = {
              type = "checkbox",
              name = PROVINATUS_OFFSET_CENTER,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Offset
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Offset = value
              end,
              tooltip = PROVINATUS_OFFSET_CENTER_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Offset
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
          name = PROVINATUS_WAYPOINT_ICON,
          controls = GetIconSettingsMenu(
            PROVINATUS_WAYPOINT_SETTINGS,
            function()
              return CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.PlayerWaypointIconSize = value
            end,
            function()
              return CrownPointerThing.SavedVars.HUD.PlayerWaypointIconAlpha * 100
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.PlayerWaypointIconAlpha = value / 100
            end
          )
        },
        [5] = {
          type = "submenu",
          name = PROVINATUS_RALLYPOINT,
          controls = GetIconSettingsMenu(
            PROVINATUS_RALLYPOINT_SETTINGS,
            function()
              return CrownPointerThing.SavedVars.HUD.RallyPointIconSize
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.RallyPointIconSize = value
            end,
            function()
              return CrownPointerThing.SavedVars.HUD.RallyPointIconAlpha * 100
            end,
            function(value)
              CrownPointerThing.SavedVars.HUD.RallyPointIconAlpha = value / 100
            end
          )
        },
        [6] = {
          type = "submenu",
          name = PROVINATUS_QUEST_MARKER,
          controls = {
            [1] = {
              type = "checkbox",
              name = PROVINATUS_SHOW_QUEST_MARKER,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.ShowQuestMarker
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.ShowQuestMarker = value
              end,
              tooltip = PROVINATUS_SHOW_QUEST_MARKER_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.ShowQuestMarker
            },
            [2] = {
              type = "submenu",
              name = PROVINATUS_ICON_SETTINGS,
              controls = GetIconSettingsMenu(
                "",
                function()
                  return CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.QuestMarkerIconSize = value
                end,
                function()
                  return CrownPointerThing.SavedVars.HUD.QuestMarkerIconAlpha * 100
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.QuestMarkerIconAlpha = value / 100
                end
              )
            }
          }
        },
        [7] = {
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
              type = "slider",
              name = PROVINATUS_COMPASS_SIZE,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Compass.Size
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Compass.Size = value
              end,
              -- TODO set min max in config
              min = 25,
              max = 500,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              tooltip = PROVINATUS_COMPASS_SIZE_TT,
              width = "full",
              disabled = function()
                return ProvTF ~= nil or CrownPointerThing.SavedVars.HUD.Compass.LockToHUD
              end
            },
            [3] = {
              type = "checkbox",
              name = PROVINATUS_LOCK_TO_HUD,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Compass.LockToHUD
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Compass.LockToHUD = value
                if CrownPointerThing.SavedVars.HUD.Compass.LockToHUD then
                  CrownPointerThing.SavedVars.HUD.Compass.Size = CrownPointerThing.SavedVars.HUD.Size
                end
              end,
              tooltip = PROVINATUS_LOCK_TO_HUD_TT,
              width = "full",
              default = ProvinatusConfig.HUD.Compass.LockToHUD,
              disabled = ProvTF ~= nil
            },
            [4] = {
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
            },
            [5] = {
              type = "colorpicker",
              name = PROVINATUS_COMPASS_COLOR,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Compass.Color.r, CrownPointerThing.SavedVars.HUD.Compass.Color.g, CrownPointerThing.SavedVars.HUD.Compass.Color.b, CrownPointerThing.SavedVars.HUD.Compass.Alpha
              end,
              setFunc = function(Red, Green, Blue, Alpha)
                CrownPointerThing.SavedVars.HUD.Compass.Color.r = Red
                CrownPointerThing.SavedVars.HUD.Compass.Color.g = Green
                CrownPointerThing.SavedVars.HUD.Compass.Color.b = Blue
                CrownPointerThing.SavedVars.HUD.Compass.Alpha = Alpha
              end,
              tooltip = PROVINATUS_COMPASS_COLOR_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Compass.Color
            }
          }
        },
        [8] = {
          type = "submenu",
          name = "Skyshards",
          controls = {
            [1] = {
              type = "checkbox",
              name = PROVINATUS_ENABLE_SKYSHARDS,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.Skyshards.Enabled and SkyShards_GetLocalData ~= nil
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.Skyshards.Enabled = value
              end,
              tooltip = PROVINATUS_ENABLE_SKYSHARDS_TT,
              width = "full",
              default = ProvinatusConfig.HUD.Skyshards.Enabled,
              disabled = SkyShards_GetLocalData == nil
            },
            [2] = {
              type = "submenu",
              name = PROVINATUS_UNDISCOVERED,
              controls = {
                [1] = {
                  type = "slider",
                  name = PROVINATUS_ICON_SIZE,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.Skyshards.UnknownSize
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.Skyshards.UnknownSize = value
                  end,
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
                  disabled = function()
                    return SkyShards_GetLocalData == nil or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
                  end
                },
                [2] = {
                  type = "slider",
                  name = PROVINATUS_TRANSPARENCY,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.Skyshards.UnknownAlpha * 100
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.Skyshards.UnknownAlpha = value / 100
                  end,
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
                  disabled = function()
                    return SkyShards_GetLocalData == nil or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
                  end
                }
              }
            },
            [3] = {
              type = "submenu",
              name = PROVINATUS_DISCOVERED,
              controls = {
                [1] = {
                  type = "checkbox",
                  name = PROVINATUS_SHOW_DISCOVERED,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards = value
                  end,
                  tooltip = PROVINATUS_SHOW_DISCOVERED_TT,
                  width = "full",
                  default = ProvinatusConfig.HUD.Skyshards.ShowKnownSkyshards,
                  disabled = function()
                    return SkyShards_GetLocalData == nil or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
                  end
                },
                [2] = {
                  type = "slider",
                  name = PROVINATUS_ICON_SIZE,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.Skyshards.KnownSize
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.Skyshards.KnownSize = value
                  end,
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
                  disabled = function()
                    return SkyShards_GetLocalData == nil or not CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
                  end
                },
                [3] = {
                  type = "slider",
                  name = PROVINATUS_TRANSPARENCY,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.Skyshards.KnownAlpha * 100
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.Skyshards.KnownAlpha = value / 100
                  end,
                  min = 0,
                  max = 100,
                  step = 1,
                  clampInput = true,
                  decimals = 0,
                  autoSelect = true,
                  inputLocation = "below",
                  tooltip = PROVINATUS_TRANSPARENCY_TT,
                  width = "half",
                  disabled = function()
                    return SkyShards_GetLocalData == nil or not CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
                  end
                }
              }
            }
          }
        },
        [9] = {
          type = "submenu",
          name = "Lost Treasure",
          controls = {
            [1] = {
              type = "checkbox",
              name = PROVINATUS_ENABLE_LOSTTREASURE,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.LostTreasure.Enabled
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.LostTreasure.Enabled = value
              end,
              tooltip = PROVINATUS_ENABLE_LOSTTREASURE_TT,
              width = "full",
              default = ProvinatusConfig.HUD.LostTreasure.Enabled,
              disabled = function()
                return LOST_TREASURE_DATA == nil
              end
            },
            [2] = {
              type = "submenu",
              name = PROVINATUS_ICON_SETTINGS,
              controls = {
                [1] = {
                  type = "slider",
                  name = PROVINATUS_ICON_SIZE,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.LostTreasure.Size
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.LostTreasure.Size = value
                  end,
                  min = 20,
                  max = 150,
                  step = 1,
                  clampInput = true,
                  decimals = 0,
                  autoSelect = true,
                  inputLocation = "below",
                  tooltip = PROVINATUS_ICON_SIZE_TT,
                  width = "half",
                  default = ProvinatusConfig.HUD.LostTreasure.Size,
                  disabled = function()
                    return LOST_TREASURE_DATA == nil
                  end
                },
                [2] = {
                  type = "slider",
                  name = PROVINATUS_TRANSPARENCY,
                  getFunc = function()
                    return CrownPointerThing.SavedVars.HUD.LostTreasure.Alpha * 100
                  end,
                  setFunc = function(value)
                    CrownPointerThing.SavedVars.HUD.LostTreasure.Alpha = value / 100
                  end,
                  min = 0,
                  max = 100,
                  step = 1,
                  clampInput = true,
                  decimals = 0,
                  autoSelect = true,
                  inputLocation = "below",
                  tooltip = PROVINATUS_TRANSPARENCY_TT,
                  width = "half",
                  default = ProvinatusConfig.HUD.LostTreasure.Alpha,
                  disabled = function()
                    return LOST_TREASURE_DATA == nil
                  end
                }
              }
            }
          }
        }
      }
    },
    [2] = {
      type = "submenu",
      name = CROWN_POINTER_THING,
      controls = {
        [1] = {
          type = "submenu",
          name = PROVINATUS_TARGET_INDICATOR,
          controls = GetPointerIconSettings()
        },
        [2] = {
          type = "submenu",
          name = PROVINATUS_DEBUG,
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
              type = "checkbox",
              name = PROVINATUS_SET_CROWN_POSITION,
              tooltip = PROVINATUS_SET_CROWN_POSITION_TT,
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
              name = PROVINATUS_SNAP_TO_ME,
              func = function()
                local PlayerX, PlayerY, PlayerHeading = GetMapPlayerPosition("player")
                CrownPointerThing.SavedVars.DebugSettings.TargetX = PlayerX
                CrownPointerThing.SavedVars.DebugSettings.TargetY = PlayerY
              end,
              tooltip = PROVINATUS_SNAP_TO_ME_TT,
              width = "half",
              disabled = function()
                return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug or not CrownPointerThing.SavedVars.DebugSettings.CrownPositionOverride
              end
            },
            [5] = {
              type = "slider",
              name = PROVINATUS_SET_X,
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
              name = PROVINATUS_SET_Y,
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
