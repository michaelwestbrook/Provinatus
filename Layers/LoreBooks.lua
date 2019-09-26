ProvinatusLoreBooks = {}
local LOREBOOKS_ADDON_LOADED = LoreBooks_GetLocalData ~= nil

function ProvinatusLoreBooks.Update()
  local Elements = {}
  local LoreBooks
  if LOREBOOKS_ADDON_LOADED then
    LoreBooks = LoreBooks_GetLocalData(Provinatus.Zone, Provinatus.Subzone)
  else
    LoreBooks = ProvinatusLoreBooksData[Provinatus.Subzone]
  end
  if LoreBooks and Provinatus.SavedVars.LoreBooks.Enabled then
    for _, pinData in pairs(LoreBooks) do
      local _, Texture, Known = GetLoreBookInfo(1, pinData[3], pinData[4])
      if not Known or Provinatus.SavedVars.LoreBooks.ShowCollected then
        table.insert(
          Elements,
          {
            X = pinData[1],
            Y = pinData[2],
            Texture = Texture,
            Alpha = Provinatus.SavedVars.LoreBooks.Alpha,
            Height = Provinatus.SavedVars.LoreBooks.Size,
            Width = Provinatus.SavedVars.LoreBooks.Size
          }
        )
      end
    end
  end

  Provinatus.DrawElements(ProvinatusLoreBooks, Elements)
end

function ProvinatusLoreBooks.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_LORE_BOOKS,
    reference = "ProvinatusLoreBooksMenu",
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_LORE_BOOKS_ENABLED,
        getFunc = function()
          return Provinatus.SavedVars.LoreBooks.Enabled
        end,
        setFunc = function(value)
          Provinatus.SavedVars.LoreBooks.Enabled = value
        end,
        tooltip = function()
          if LOREBOOKS_ADDON_LOADED then
            return PROVINATUS_LORE_BOOKS_ENABLED_TT
          else
            return PROVINATUS_LORE_BOOKS_ENABLED_NO_LB_TT
          end
        end,
        width = "full",
        default = ProvinatusConfig.LoreBooks.Enabled
      },
      [2] = {
        type = "checkbox",
        name = PROVINATUS_LORE_BOOKS_SHOW_KNOWN,
        getFunc = function()
          return Provinatus.SavedVars.LoreBooks.ShowCollected
        end,
        setFunc = function(value)
          Provinatus.SavedVars.LoreBooks.ShowCollected = value
        end,
        tooltip = "",
        width = "full",
        default = ProvinatusConfig.LoreBooks.ShowCollected,
        disabled = function()
          return not Provinatus.SavedVars.LoreBooks.Enabled
        end
      },
      [3] = {
        type = "submenu",
        name = PROVINATUS_ICON_SETTINGS,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.LoreBooks.Size
          end,
          function(value)
            Provinatus.SavedVars.LoreBooks.Size = value
          end,
          function()
            return Provinatus.SavedVars.LoreBooks.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.LoreBooks.Alpha = value / 100
          end,
          ProvinatusConfig.LoreBooks.Size,
          ProvinatusConfig.LoreBooks.Alpha * 100,
          function()
            return not Provinatus.SavedVars.LoreBooks.Enabled
          end
        )
      }
    }
  }
end

function ProvinatusLoreBooks.SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(ProvinatusLoreBooksMenu.arrow, "/esoui/art/icons/magickalore_book1.dds")
end
