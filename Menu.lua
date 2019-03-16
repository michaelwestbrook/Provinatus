ProvinatusMenu = {}

local SettingsMenu

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

local function GetIconSettingsMenu(DescriptionText, GetSizeFunction, SetSizeFunction, GetAlphaFunction, SetAlphaFunction, defaultSizeFunction, defaultAlphaFunction, disabledFunction)
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
      min = 20,
      max = 150,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_ICON_SIZE_TT,
      width = "half",
      disabled = disabledFunction,
      default = defaultSizeFunction
    },
    [3] = {
      type = "slider",
      name = PROVINATUS_TRANSPARENCY,
      getFunc = GetAlphaFunction,
      setFunc = SetAlphaFunction,
      min = 0,
      max = 100,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_TRANSPARENCY_TT,
      width = "half",
      disabled = disabledFunction,
      default = defaultAlphaFunction
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
    end,
    ProvinatusConfig.CrownPointer.Size,
    ProvinatusConfig.CrownPointer.Alpha * 100,
    function()
      return not CrownPointerThing.SavedVars.CrownPointer.Enabled
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

local function GetPOICheckBox(Name, Property, Tooltip, DontDisable)
  local CheckBox = {
    type = "checkbox",
    name = Name,
    reference = "Provinatus_" .. (Property or Name), -- Prepending avoid reference collisions
    getFunc = function()
      return CrownPointerThing.SavedVars.HUD.POI[Property or Name]
    end,
    setFunc = function(value)
      CrownPointerThing.SavedVars.HUD.POI[Property or Name] = value
    end,
    tooltip = Tooltip or "",
    width = "full",
    default = false
  }

  if not DontDisable then
    CheckBox.disabled = function()
      return not CrownPointerThing.SavedVars.HUD.POI.Enabled
    end
  end

  return CheckBox
end

local function GetPOIMenu()
  local Menu = {
    type = "submenu",
    name = PROVINATUS_POI,
    controls = {
      GetPOICheckBox(GetString(PROVINATUS_POINTS_OF_INTEREST), "Enabled", "", true),
      GetPOICheckBox(GetString(PROVINATUS_SHOW_COMPLETED_POI), "ShowKnownPOI"),
      {
        type = "slider",
        name = PROVINATUS_ICON_SIZE,
        getFunc = function()
          return CrownPointerThing.SavedVars.HUD.POI.Size
        end,
        setFunc = function(value)
          CrownPointerThing.SavedVars.HUD.POI.Size = value
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
        disabled = function()
          return not CrownPointerThing.SavedVars.HUD.POI.Enabled
        end,
        default = ProvinatusConfig.HUD.POI.Size
      },
      {
        type = "slider",
        name = PROVINATUS_TRANSPARENCY,
        getFunc = function()
          return CrownPointerThing.SavedVars.HUD.POI.Alpha * 100
        end,
        setFunc = function(value)
          CrownPointerThing.SavedVars.HUD.POI.Alpha = value / 100
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
          return not CrownPointerThing.SavedVars.HUD.POI.Enabled
        end,
        default = ProvinatusConfig.HUD.POI.Alpha * 100
      },
      {
        type = "divider",
        width = "full"
      },
      GetPOICheckBox(GetString(PROVINATUS_AREA_OF_INTEREST), "AreaOfInterest"),
      GetPOICheckBox(GetString(PROVINATUS_AYLEID_RUIN), "AyleidRuin"),
      GetPOICheckBox(GetString(PROVINATUS_BATTLEFIELD), "Battlefield"),
      GetPOICheckBox(GetString(PROVINATUS_CAMP), "Camp"),
      GetPOICheckBox(GetString(PROVINATUS_CAVE), "Cave"),
      GetPOICheckBox(GetString(PROVINATUS_CEMETARY), "Cemetary"),
      GetPOICheckBox(GetString(PROVINATUS_CITY), "City"),
      GetPOICheckBox(GetString(PROVINATUS_CRAFTING), "Crafting"),
      GetPOICheckBox(GetString(PROVINATUS_CRYPT), "Crypt"),
      GetPOICheckBox(GetString(PROVINATUS_PORTAL), "Portal"),
      GetPOICheckBox(GetString(PROVINATUS_DAEDRIC_RUIN), "DaedricRuin"),
      GetPOICheckBox(GetString(PROVINATUS_DARK_BROTHERHOOK), "DarkBrotherhood"),
      GetPOICheckBox(GetString(PROVINATUS_DELVE), "Delve"),
      GetPOICheckBox(GetString(PROVINATUS_DOCK), "Dock"),
      GetPOICheckBox(GetString(PROVINATUS_DUNGEON), "Dungeon"),
      GetPOICheckBox(GetString(PROVINATUS_DWEMER_RUIN), "DwemerRuin"),
      GetPOICheckBox(GetString(PROVINATUS_ESTATE), "Estate"),
      GetPOICheckBox(GetString(PROVINATUS_EXPLORABLE), "Explorable"),
      GetPOICheckBox(GetString(PROVINATUS_FARM), "Farm"),
      GetPOICheckBox(GetString(PROVINATUS_GATE), "Gate"),
      GetPOICheckBox(GetString(PROVINATUS_GROVE), "Grove"),
      -- GetPOICheckBox(GetString(PROVINATUS_HORSE_RACE), "HorseRace"), -- Is horse racing even a thing in ESO?
      GetPOICheckBox(GetString(PROVINATUS_KEEP), "Keep"),
      GetPOICheckBox(GetString(PROVINATUS_LIGHTHOUSE), "Lighthouse"),
      GetPOICheckBox(GetString(PROVINATUS_MINE), "Mine"),
      GetPOICheckBox(GetString(PROVINATUS_MUNDUS_STONE), "Mundus"),
      GetPOICheckBox(GetString(PROVINATUS_RUIN), "Ruin"),
      GetPOICheckBox(GetString(PROVINATUS_SEWER), "Sewer"),
      GetPOICheckBox(GetString(PROVINATUS_SOLO_INSTANCE), "SoloInstance"),
      GetPOICheckBox(GetString(PROVINATUS_SOLO_TRIAL), "SoloTrial"),
      GetPOICheckBox(GetString(PROVINATUS_TOWER), "Tower"),
      GetPOICheckBox(GetString(PROVINATUS_TOWN), "Town"),
      GetPOICheckBox(GetString(PROVINATUS_WAYSHRINE), "Wayshrine"),
      {
        type = "submenu",
        name = PROVINATUS_GROUP_POI,
        controls = {
          GetPOICheckBox(GetString(PROVINATUS_GROUP_AREA_OF_INTEREST), "GroupAreaOfInterest"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_AYLEID_RUIN), "GroupAyliedRuin"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_BATTLEGROUND), "GroupBattleground"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_BOSS), "GroupBoss"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_CAMP), "GroupCamp"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_CAVE), "GroupCave"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_CEMETARY), "GroupCemetery"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_CRYPT), "GroupCrypt"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_DELVE), "GroupDelve"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_DWEMER_RUIN), "GroupDwemerRuin"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_ESTATE), "GroupEstate"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_GATE), "GroupGate"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_HOUSE), "GroupHouse"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_KEEP), "GroupKeep"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_INSTANCE), "GroupInstance"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_LIGHTHOUSE), "GroupLighthouse"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_MINE), "GroupMine"),
          GetPOICheckBox(GetString(PROVINATUS_GROUP_RUIN), "GroupRuin"),
          GetPOICheckBox(GetString(PROVINATUS_RAID_DUNGEON), "RaidDungeon")
        }
      },
      {
        type = "submenu",
        name = PROVINATUS_IMPERIAL_CITY,
        controls = {
          GetPOICheckBox(GetString(PROVINATUS_IC_SEWER), "ICSewer"),
          GetPOICheckBox(GetString(PROVINATUS_BONESHARD), "BoneShard"),
          GetPOICheckBox(GetString(PROVINATUS_DAEDRIC_EMBERS), "DaedricEmbers"),
          GetPOICheckBox(GetString(PROVINATUS_DAEDRIC_SHACKLES), "DaedricShackles"),
          GetPOICheckBox(GetString(PROVINATUS_DARK_ETHER), "DarkEther"),
          GetPOICheckBox(GetString(PROVINATUS_MARK_LEGION), "MarkLegion"),
          GetPOICheckBox(GetString(PROVINATUS_MONSTROUS_TEETH), "MonstrousTeeth"),
          GetPOICheckBox(GetString(PROVINATUS_PLANAR_ARMOR), "PlanarArmor"),
          GetPOICheckBox(GetString(PROVINATUS_TINY_CLAW), "TinyClaw")
        }
      }
    }
  }

  return Menu
end

local function DrawPOIMenuIcon(Control, Texture)
  local POIIcon = WINDOW_MANAGER:CreateControl(nil, Control, CT_TEXTURE)
  POIIcon:SetAnchor(CENTER, Control, CENTER, 0, 0)
  POIIcon:SetTexture(Texture)
  POIIcon:SetDimensions(30, 30)
  POIIcon:SetAlpha(1)
end

local function GetLoreBooksMenu()
  return {
    type = "submenu",
    name = "LoreBooks",
    controls = {
      [1] = {
        type = "checkbox",
        name = "LoreBooks",
        getFunc = function()
          return CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled and LoreBooks_GetLocalData ~= nil
        end,
        setFunc = function(value)
          CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled = value
        end,
        tooltip = PROVINATUS_LOREBOOKS_ENABLED_TT,
        width = "full",
        default = ProvinatusConfig.HUD.LoreBooks.Enabled,
        disabled = LoreBooks_GetLocalData == nil
      },
      [2] = {
        type = "checkbox",
        name = PROVINATUS_KNOWN_LOREBOOKS,
        getFunc = function()
          return CrownPointerThing.SavedVars.HUD.LoreBooks.ShowKnownLoreBooks
        end,
        setFunc = function(value)
          CrownPointerThing.SavedVars.HUD.LoreBooks.ShowKnownLoreBooks = value
        end,
        tooltip = "",
        width = "full",
        default = ProvinatusConfig.HUD.LoreBooks.ShowKnownLoreBooks,
        disabled = function()
          return not CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled or LoreBooks_GetLocalData == nil
        end
      },
      [3] = {
        type = "submenu",
        name = PROVINATUS_ICON_SETTINGS,
        controls = GetIconSettingsMenu(
          "",
          function()
            return CrownPointerThing.SavedVars.HUD.LoreBooks.Size
          end,
          function(value)
            CrownPointerThing.SavedVars.HUD.LoreBooks.Size = value
          end,
          function()
            return CrownPointerThing.SavedVars.HUD.LoreBooks.Alpha * 100
          end,
          function(value)
            CrownPointerThing.SavedVars.HUD.LoreBooks.Alpha = value / 100
          end,
          ProvinatusConfig.HUD.LoreBooks.Size,
          ProvinatusConfig.HUD.LoreBooks.Alpha * 100,
          function()
            return not CrownPointerThing.SavedVars.HUD.LoreBooks.Enabled or LoreBooks_GetLocalData == nil
          end
        )
      }
    }
  }
end

local function GetSkyshardMenu()
  return {
    type = "submenu",
    name = "Skyshards",
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_ENABLE_SKYSHARDS,
        getFunc = function()
          return CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
        end,
        setFunc = function(value)
          CrownPointerThing.SavedVars.HUD.Skyshards.Enabled = value
        end,
        tooltip = PROVINATUS_ENABLE_SKYSHARDS_TT,
        width = "full",
        default = ProvinatusConfig.HUD.Skyshards.Enabled
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
              return not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
            end,
            default = ProvinatusConfig.HUD.Skyshards.UnknownSize
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
              return not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
            end,
            default = ProvinatusConfig.HUD.Skyshards.UnknownAlpha * 100
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
              return not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
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
              return not CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
            end,
            default = ProvinatusConfig.HUD.Skyshards.KnownSize
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
              return not CrownPointerThing.SavedVars.HUD.Skyshards.ShowKnownSkyshards or not CrownPointerThing.SavedVars.HUD.Skyshards.Enabled
            end,
            default = ProvinatusConfig.HUD.Skyshards.KnownAlpha * 100
          }
        }
      }
    }
  }
end

local function ControlsCreated(Panel)
  if Panel == SettingsMenu then
    DrawPOIMenuIcon(Provinatus_AreaOfInterest, "/esoui/art/icons/poi/poi_areaofinterest_complete.dds")
    DrawPOIMenuIcon(Provinatus_AyleidRuin, "/esoui/art/icons/poi/poi_ayleidruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_Battlefield, "/esoui/art/icons/poi/poi_battlefield_complete.dds")
    DrawPOIMenuIcon(Provinatus_BoneShard, "/esoui/art/icons/poi/poi_ic_boneshard_complete.dds")
    DrawPOIMenuIcon(Provinatus_Camp, "/esoui/art/icons/poi/poi_camp_complete.dds")
    DrawPOIMenuIcon(Provinatus_Cave, "/esoui/art/icons/poi/poi_cave_complete.dds")
    DrawPOIMenuIcon(Provinatus_Cemetary, "/esoui/art/icons/poi/poi_cemetery_complete.dds")
    DrawPOIMenuIcon(Provinatus_City, "/esoui/art/icons/poi/poi_city_complete.dds")
    DrawPOIMenuIcon(Provinatus_Crafting, "/esoui/art/icons/poi/poi_crafting_complete.dds")
    DrawPOIMenuIcon(Provinatus_Crypt, "/esoui/art/icons/poi/poi_crypt_complete.dds")
    DrawPOIMenuIcon(Provinatus_DaedricEmbers, "/esoui/art/icons/poi/poi_ic_daedricembers_complete.dds")
    DrawPOIMenuIcon(Provinatus_DaedricRuin, "/esoui/art/icons/poi/poi_daedricruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_DaedricShackles, "/esoui/art/icons/poi/poi_ic_daedricshackles_complete.dds")
    DrawPOIMenuIcon(Provinatus_DarkBrotherhood, "/esoui/art/icons/poi/poi_darkbrotherhood_complete.dds")
    DrawPOIMenuIcon(Provinatus_DarkEther, "/esoui/art/icons/poi/poi_ic_darkether_complete.dds")
    DrawPOIMenuIcon(Provinatus_Delve, "/esoui/art/icons/poi/poi_delve_complete.dds")
    DrawPOIMenuIcon(Provinatus_Dock, "/esoui/art/icons/poi/poi_dock_complete.dds")
    DrawPOIMenuIcon(Provinatus_Dungeon, "/esoui/art/icons/poi/poi_dungeon_complete.dds")
    DrawPOIMenuIcon(Provinatus_DwemerRuin, "/esoui/art/icons/poi/poi_dwemerruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_Estate, "/esoui/art/icons/poi/poi_estate_complete.dds")
    DrawPOIMenuIcon(Provinatus_Explorable, "/esoui/art/icons/poi/poi_explorable_complete.dds")
    DrawPOIMenuIcon(Provinatus_Farm, "/esoui/art/icons/poi/poi_farm_complete.dds")
    DrawPOIMenuIcon(Provinatus_Gate, "/esoui/art/icons/poi/poi_gate_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupBoss, "/esoui/art/icons/poi/poi_groupboss_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupDelve, "/esoui/art/icons/poi/poi_groupdelve_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupInstance, "/esoui/art/icons/poi/poi_groupinstance_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupAreaOfInterest, "/esoui/art/icons/poi/poi_group_areaofinterest_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupAyliedRuin, "/esoui/art/icons/poi/poi_group_ayliedruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupBattleground, "/esoui/art/icons/poi/poi_group_battleground_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupCamp, "/esoui/art/icons/poi/poi_group_camp_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupCave, "/esoui/art/icons/poi/poi_group_cave_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupCemetery, "/esoui/art/icons/poi/poi_group_cemetery_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupCrypt, "/esoui/art/icons/poi/poi_group_crypt_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupDwemerRuin, "/esoui/art/icons/poi/poi_group_dwemerruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupEstate, "/esoui/art/icons/poi/poi_group_estate_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupGate, "/esoui/art/icons/poi/poi_group_gate_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupHouse, "/esoui/art/icons/poi/poi_group_house_owned.dds")
    DrawPOIMenuIcon(Provinatus_GroupKeep, "/esoui/art/icons/poi/poi_group_keep_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupLighthouse, "/esoui/art/icons/poi/poi_group_lighthouse_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupMine, "/esoui/art/icons/poi/poi_group_mine_complete.dds")
    DrawPOIMenuIcon(Provinatus_GroupRuin, "/esoui/art/icons/poi/poi_group_ruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_Grove, "/esoui/art/icons/poi/poi_grove_complete.dds")
    -- DrawPOIMenuIcon(Provinatus_HorseRace, "/esoui/art/icons/poi/poi_horserace_complete.dds") -- Don't think this is a thing.
    DrawPOIMenuIcon(Provinatus_ICSewer, "/esoui/art/icons/poi/poi_icsewer_complete.dds")
    DrawPOIMenuIcon(Provinatus_Keep, "/esoui/art/icons/poi/poi_keep_complete.dds")
    DrawPOIMenuIcon(Provinatus_Lighthouse, "/esoui/art/icons/poi/poi_lighthouse_complete.dds")
    DrawPOIMenuIcon(Provinatus_MarkLegion, "/esoui/art/icons/poi/poi_ic_marklegion_complete.dds")
    DrawPOIMenuIcon(Provinatus_Mine, "/esoui/art/icons/poi/poi_mine_complete.dds")
    DrawPOIMenuIcon(Provinatus_MonstrousTeeth, "/esoui/art/icons/poi/poi_ic_monstrousteeth_complete.dds")
    DrawPOIMenuIcon(Provinatus_Mundus, "/esoui/art/icons/poi/poi_mundus_complete.dds")
    DrawPOIMenuIcon(Provinatus_PlanarArmor, "/esoui/art/icons/poi/poi_ic_planararmorscraps_complete.dds")
    DrawPOIMenuIcon(Provinatus_Portal, "/esoui/art/icons/poi/poi_portal_complete.dds")
    DrawPOIMenuIcon(Provinatus_RaidDungeon, "/esoui/art/icons/poi/poi_raiddungeon_complete.dds")
    DrawPOIMenuIcon(Provinatus_Ruin, "/esoui/art/icons/poi/poi_ruin_complete.dds")
    DrawPOIMenuIcon(Provinatus_Sewer, "/esoui/art/icons/poi/poi_sewer_complete.dds")
    DrawPOIMenuIcon(Provinatus_SoloInstance, "/esoui/art/icons/poi/poi_soloinstance_complete.dds")
    DrawPOIMenuIcon(Provinatus_SoloTrial, "/esoui/art/icons/poi/poi_solotrial_complete.dds")
    DrawPOIMenuIcon(Provinatus_TinyClaw, "/esoui/art/icons/poi/poi_ic_tinyclaw_complete.dds")
    DrawPOIMenuIcon(Provinatus_Tower, "/esoui/art/icons/poi/poi_tower_complete.dds")
    DrawPOIMenuIcon(Provinatus_Town, "/esoui/art/icons/poi/poi_town_complete.dds")
    DrawPOIMenuIcon(Provinatus_Wayshrine, "/esoui/art/icons/poi/poi_wayshrine_complete.dds")
  end
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
    registerForDefaults = true
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
              min = 24,
              max = 60,
              step = 1,
              clampInput = true,
              decimals = 0,
              requiresReload = true,
              autoSelect = true,
              inputLocation = "below",
              width = "full",
              default = ProvinatusConfig.HUD.RefreshRate
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
              min = 0,
              max = 100,
              step = 1,
              clampInput = true,
              decimals = 0,
              autoSelect = true,
              inputLocation = "below",
              tooltip = PROVINATUS_ICON_SIZE_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Compass.Alpha * 100
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
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.Compass.AlwaysOn
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
              default = {r = ProvinatusConfig.HUD.Compass.Color.r, g = ProvinatusConfig.HUD.Compass.Color.g, b = ProvinatusConfig.HUD.Compass.Color.b, a = ProvinatusConfig.HUD.Compass.Alpha}
            }
          }
        },
        [3] = {
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
            end,
            ProvinatusConfig.HUD.PlayerIconSize,
            ProvinatusConfig.HUD.PlayerIconAlpha * 100,
            ProvTF ~= nil
          )
        },
        [4] = {
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
            end,
            ProvinatusConfig.HUD.TargetIconSize,
            ProvinatusConfig.HUD.TargetIconAlpha * 100,
            ProvTF ~= nil
          )
        },
        [5] = {
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
            end,
            ProvinatusConfig.HUD.PlayerWaypointIconSize,
            ProvinatusConfig.HUD.PlayerWaypointIconAlpha * 100,
            false
          )
        },
        [6] = {
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
            end,
            ProvinatusConfig.HUD.RallyPointIconSize,
            ProvinatusConfig.HUD.RallyPointIconAlpha * 100,
            false
          )
        },
        [7] = {
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
                end,
                ProvinatusConfig.HUD.QuestMarkerIconSize,
                ProvinatusConfig.HUD.QuestMarkerIconAlpha * 100,
                function()
                  return not CrownPointerThing.SavedVars.HUD.ShowQuestMarker
                end
              )
            }
          }
        },
        [8] = {
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
              controls = GetIconSettingsMenu(
                "",
                function()
                  return CrownPointerThing.SavedVars.HUD.LostTreasure.Size
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.LostTreasure.Size = value
                end,
                function()
                  return CrownPointerThing.SavedVars.HUD.LostTreasure.Alpha * 100
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.LostTreasure.Alpha = value / 100
                end,
                ProvinatusConfig.HUD.LostTreasure.Size,
                ProvinatusConfig.HUD.LostTreasure.Alpha * 100,
                function()
                  return LOST_TREASURE_DATA == nil or not CrownPointerThing.SavedVars.HUD.LostTreasure.Enabled
                end
              )
            }
          }
        },
        [9] = {
          type = "submenu",
          name = PROVINATUS_MY_ICON,
          controls = {
            [1] = {
              type = "checkbox",
              name = PROVINATUS_SHOW_YOUR_ICON,
              getFunc = function()
                return CrownPointerThing.SavedVars.HUD.MyIcon.Enabled
              end,
              setFunc = function(value)
                CrownPointerThing.SavedVars.HUD.MyIcon.Enabled = value
              end,
              tooltip = PROVINATUS_SHOW_YOUR_ICON_TT,
              width = "full",
              disabled = ProvTF ~= nil,
              default = ProvinatusConfig.HUD.MyIcon.Enabled
            },
            [2] = {
              type = "submenu",
              name = PROVINATUS_ICON_SETTINGS,
              controls = GetIconSettingsMenu(
                "",
                function()
                  return CrownPointerThing.SavedVars.HUD.MyIcon.Size
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.MyIcon.Size = value
                end,
                function()
                  return CrownPointerThing.SavedVars.HUD.MyIcon.Alpha * 100
                end,
                function(value)
                  CrownPointerThing.SavedVars.HUD.MyIcon.Alpha = value / 100
                end,
                ProvinatusConfig.HUD.MyIcon.Size,
                ProvinatusConfig.HUD.MyIcon.Alpha * 100,
                function()
                  return not CrownPointerThing.SavedVars.HUD.MyIcon.Enabled
                end
              )
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
              default = ProvinatusConfig.Debug,
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
    [3] = GetPOIMenu(),
    [4] = GetSkyshardMenu(),
    [5] = GetLoreBooksMenu(),
    [6] = GetWarning()
  }

  local LAM2 = LibStub("LibAddonMenu-2.0")
  SettingsMenu = LAM2:RegisterAddonPanel(CrownPointerThing.name .. "Options", panelData)
  LAM2:RegisterOptionControls(CrownPointerThing.name .. "Options", optionsData)
  CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", ControlsCreated)
end
