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

local function GetOptionsData()
  local OptionsData = {}
  for _, Layer in pairs(Provinatus.Layers) do
    if Layer.GetMenu then
      table.insert(OptionsData, Layer.GetMenu())
    end
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
