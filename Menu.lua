ProvinatusMenu = {}

local function GetPanelData()
  return {
    type = "panel",
    name = ProvinatusConfig.Name,
    displayName = ProvinatusConfig.FriendlyName,
    author = ProvinatusConfig.Author,
    version = ProvinatusConfig.Version,
    website = ProvinatusConfig.Website,
    slashCommand = ProvinatusConfig.SlashCommand,
    registerForRefresh = true,
    registerForDefaults = true
  }
end

local function GetDisplayMenu()
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
        end,
        tooltip = PROVINATUS_OFFSET_CENTER_TT,
        width = "full",
        default = ProvinatusConfig.Display.Offset
      }
    }
  }
end

local function GetOptionsData()
  local OptionsData = {}
  table.insert(OptionsData, GetDisplayMenu())
  for _, Layer in pairs(Provinatus.Layers) do
    table.insert(OptionsData, Layer.GetMenu())
  end
  return OptionsData
end

function ProvinatusMenu.DrawMenuIcon(Anchor, Texture)
  local Icon = WINDOW_MANAGER:CreateControl(nil, Anchor, CT_TEXTURE)
  Icon:SetAnchor(CENTER, Anchor, LEFT, -10, 0)
  Icon:SetTexture(Texture)
  Icon:SetDimensions(30, 30)
  Icon:SetAlpha(1)
  return Icon
end

local function PanelCreated(Panel)
  if Panel == ProvinatusMenu.SettingMenu then
    for _, Layer in pairs(Provinatus.Layers) do
      if Layer.SetMenuIcon then
        Layer.SetMenuIcon(Panel)
      end
    end
  end
end

function ProvinatusMenu.Initialize()
  local LAM2 = LibStub("LibAddonMenu-2.0")
  ProvinatusMenu.SettingMenu = LAM2:RegisterAddonPanel(ProvinatusConfig.Name .. "Options", GetPanelData())
  LAM2:RegisterOptionControls(ProvinatusConfig.Name .. "Options", GetOptionsData())
  CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", PanelCreated)
end

function ProvinatusMenu.GetIconSettingsMenu(DescriptionText, GetSizeFunction, SetSizeFunction, GetAlphaFunction, SetAlphaFunction, defaultSizeFunction, defaultAlphaFunction, disabledFunction)
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
