ProvinatusDisplay = {}

function ProvinatusDisplay.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_DISPLAY,
    controls = {
      [1] = {
        type = "slider",
        name = PROVINATUS_HUD_SIZE,
        getFunc = function()
          return Provinatus.SavedVars.Display.Size
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Size = value
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
        default = ProvinatusConfig.Display.Size
      },
      [2] = {
        type = "slider",
        name = PROVINATUS_REFRESH_RATE,
        getFunc = function()
          return Provinatus.SavedVars.Display.RefreshRate
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.RefreshRate = value
          Provinatus.SetRefreshRate()
        end,
        min = 24,
        max = 144,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "full",
        default = ProvinatusConfig.Display.RefreshRate
      },
      [3] = {
        type = "slider",
        name = PROVINATUS_HORIZONTAL_POSITION,
        getFunc = function()
          return Provinatus.SavedVars.Display.X
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.X = value
        end,
        min = -GuiRoot:GetWidth() / 2,
        max = GuiRoot:GetWidth() / 2,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.X
      },
      [4] = {
        type = "slider",
        name = PROVINATUS_VERTICAL_POSITION,
        getFunc = function()
          return Provinatus.SavedVars.Display.Y
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Y = value
        end,
        min = -GuiRoot:GetHeight() / 2,
        max = GuiRoot:GetHeight() / 2,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.Y
      },
      [5] = {
        type = "checkbox",
        name = PROVINATUS_OFFSET_CENTER,
        reference = "ProvinatusOffsetCenterCheckbox",
        getFunc = function()
          return Provinatus.SavedVars.Display.Offset
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Offset = value
          ProvinatusDisplay.SetMenuIcon()
        end,
        tooltip = PROVINATUS_OFFSET_CENTER_TT,
        width = "full",
        default = ProvinatusConfig.Display.Offset
      }
    }
  }
end

function ProvinatusDisplay.SetMenuIcon()
  if not ProvinatusOffsetCenterCheckbox.Reticle then
    ProvinatusOffsetCenterCheckbox.Reticle = WINDOW_MANAGER:CreateControl(nil, ProvinatusOffsetCenterCheckbox, CT_TEXTURE)
    ProvinatusOffsetCenterCheckbox.Reticle:SetTexture("esoui/art/worldmap/map_centerreticle.dds")
    ProvinatusOffsetCenterCheckbox.Reticle:SetAlpha(1)
    ProvinatusOffsetCenterCheckbox.Reticle:SetAnchor(CENTER, ProvinatusOffsetCenterCheckbox, CENTER, 0, 0)
    ProvinatusOffsetCenterCheckbox.Reticle:SetDimensions(24, 24)
    ProvinatusOffsetCenterCheckbox.Reticle:SetTextureRotation(math.pi / 4)

    ProvinatusOffsetCenterCheckbox.Pointer = WINDOW_MANAGER:CreateControl(nil, ProvinatusOffsetCenterCheckbox.Reticle, CT_TEXTURE)
    ProvinatusOffsetCenterCheckbox.Pointer:SetTexture("esoui/art/floatingmarkers/quest_icon_assisted.dds")
    ProvinatusOffsetCenterCheckbox.Pointer:SetDimensions(24, 24)
    ProvinatusOffsetCenterCheckbox.Pointer:SetTextureRotation(math.pi)
    ProvinatusOffsetCenterCheckbox.Pointer:SetColor(0, 1, 0, 1)
  end

  local AnchorPosition
  if Provinatus.SavedVars.Display.Offset then
    AnchorPosition = BOTTOM
  else
    AnchorPosition = CENTER
  end
  ProvinatusOffsetCenterCheckbox.Pointer:SetAnchor(CENTER, ProvinatusOffsetCenterCheckbox, AnchorPosition, 0, 0)
end