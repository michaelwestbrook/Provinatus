ProvinatusTreasureMaps = {}

local Texture = "Provinatus/Icons/X.dds"

local function CreateElement(TreasureMap)
  local Element = {}
  Element.X = TreasureMap[1]
  Element.Y = TreasureMap[2]
  Element.Alpha = Provinatus.SavedVars.TreasureMaps.Alpha
  Element.Width = Provinatus.SavedVars.TreasureMaps.Size
  Element.Height = Provinatus.SavedVars.TreasureMaps.Size
  Element.Texture = Texture
  return Element
end

function ProvinatusTreasureMaps.Update()
  local Maps = ProvinatusTreasureMapsData[Provinatus.Zone]
  local Elements = {}
  if Provinatus.SavedVars.TreasureMaps.Enabled and Maps then
    for _, itemData in pairs(SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)) do
      if itemData and itemData.itemType == ITEMTYPE_TROPHY then
        for _, pinData in pairs(Maps) do
          if GetItemId(BAG_BACKPACK, itemData.slotIndex) == pinData[3] then
            table.insert(Elements, CreateElement(pinData))
          end
        end
      end
    end
  end

  Provinatus.DrawElements(ProvinatusTreasureMaps, Elements)
end

function ProvinatusTreasureMaps.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_TREASURE_MAPS,
    reference = "ProvinatusTreasureMaps",
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_TREASURE_MAPS_ENABLE,
        getFunc = function()
          return Provinatus.SavedVars.TreasureMaps.Enabled
        end,
        setFunc = function(value)
          Provinatus.SavedVars.TreasureMaps.Enabled = value
        end,
        width = "full",
        default = ProvinatusConfig.TreasureMaps.Enabled
      },
      [2] = {
        type = "submenu",
        name = PROVINATUS_ICON_SETTINGS,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.TreasureMaps.Size
          end,
          function(value)
            Provinatus.SavedVars.TreasureMaps.Size = value
          end,
          function()
            return Provinatus.SavedVars.TreasureMaps.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.TreasureMaps.Alpha = value / 100
          end,
          ProvinatusConfig.TreasureMaps.Size,
          ProvinatusConfig.TreasureMaps.Alpha * 100
        )
      }
    }
  }
end

function ProvinatusTreasureMaps.SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(ProvinatusTreasureMaps.arrow, Texture)
end
