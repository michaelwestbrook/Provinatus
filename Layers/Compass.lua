ProvinatusCompass = {}

local function CreateMenuIconCardinalPoint(Anchor, Text)
  local ArrowWidth, ArrowHeight = ProvinatusCompassMenu.arrow:GetDimensions()
  local Icon = WINDOW_MANAGER:CreateControl(nil, ProvinatusCompassMenu.arrow, CT_LABEL)
  Icon:SetAnchor(CENTER, ProvinatusCompassMenu.arrow, Anchor, -ArrowWidth, 3)
  Icon:SetText(Text)
  Icon:SetFont("ZoFontChat")
  Icon:SetVerticalAlignment(Anchor)
  Icon:SetColor(Provinatus.SavedVars.Compass.Color.r, Provinatus.SavedVars.Compass.Color.g, Provinatus.SavedVars.Compass.Color.b, 1)
  return Icon
end

function ProvinatusCompass.Initialize()
  ProvinatusCompass.CardinalPoints = {}
  for i = 1, 4 do
    ProvinatusCompass.CardinalPoints[i] = WINDOW_MANAGER:CreateControl(nil, Provinatus.TopLevelWindow, CT_LABEL)
    ProvinatusCompass.CardinalPoints[i]:SetFont("ZoFontHeader4")
  end

  ProvinatusCompass.CardinalPoints[1]:SetText(GetString(SI_COMPASS_NORTH_ABBREVIATION))
  ProvinatusCompass.CardinalPoints[2]:SetText(GetString(SI_COMPASS_EAST_ABBREVIATION))
  ProvinatusCompass.CardinalPoints[3]:SetText(GetString(SI_COMPASS_SOUTH_ABBREVIATION))
  ProvinatusCompass.CardinalPoints[4]:SetText(GetString(SI_COMPASS_WEST_ABBREVIATION))
end

function ProvinatusCompass.Update()
  local CameraHeading = GetPlayerCameraHeading()
  for i = 1, 4 do
    -- Only show compass if player is in group or if AlwaysOn is selected in the menu.
    if IsUnitGrouped("player") or Provinatus.SavedVars.Compass.AlwaysOn then
      local Size
      if Provinatus.SavedVars.Compass.LockToHUD then
        Size = Provinatus.SavedVars.Display.Size
      else
        Size = Provinatus.SavedVars.Compass.Size
      end
      
      local Heading = (i - 2) * math.pi / 2 + Provinatus.CameraHeading
      local CardinalDirectionX = Size * math.cos(Heading) + Provinatus.SavedVars.Display.X
      local CardinalDirectionY = Size * math.sin(Heading) + Provinatus.SavedVars.Display.Y
      if Provinatus.SavedVars.Display.Offset then
        CardinalDirectionY = CardinalDirectionY + Provinatus.SavedVars.Pointer.Size
      end
      
      ProvinatusCompass.CardinalPoints[i]:SetAnchor(CENTER, Provinatus.TopLevelWindow, CENTER, CardinalDirectionX, CardinalDirectionY)
      ProvinatusCompass.CardinalPoints[i]:SetColor(Provinatus.SavedVars.Compass.Color.r, Provinatus.SavedVars.Compass.Color.g, Provinatus.SavedVars.Compass.Color.b, Provinatus.SavedVars.Compass.Alpha)
    elseif ProvinatusCompass.CardinalPoints[i]:GetAlpha() ~= 0 then
      ProvinatusCompass.CardinalPoints[i]:SetAlpha(0)
    end
  end
end

function ProvinatusCompass.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_COMPASS,
    reference = "ProvinatusCompassMenu",
    controls = {
      [1] = {
        type = "slider",
        name = PROVINATUS_TRANSPARENCY,
        getFunc = function()
          return Provinatus.SavedVars.Compass.Alpha * 100
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Compass.Alpha = value / 100
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
        default = ProvinatusConfig.Compass.Alpha * 100
      },
      [2] = {
        type = "checkbox",
        name = PROVINATUS_LOCK_TO_HUD,
        getFunc = function()
          return Provinatus.SavedVars.Compass.LockToHUD
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Compass.LockToHUD = value
        end,
        tooltip = PROVINATUS_LOCK_TO_HUD_TT,
        width = "full",
        default = ProvinatusConfig.Compass.LockToHUD
      },
      [3] = {
        type = "slider",
        name = PROVINATUS_COMPASS_SIZE,
        getFunc = function()
          if Provinatus.SavedVars.Compass.LockToHUD then
            return Provinatus.SavedVars.Display.Size
          else
            return Provinatus.SavedVars.Compass.Size
          end
        end,
        setFunc = function(value)
          if Provinatus.SavedVars.Compass.LockToHUD then
            Provinatus.SavedVars.Display.Size = value
          else
            Provinatus.SavedVars.Compass.Size = value
          end
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
        default = ProvinatusConfig.Compass.Size,
        disabled = function ()
          return Provinatus.SavedVars.Compass.LockToHUD
        end
      },
      [4] = {
        type = "checkbox",
        name = PROVINATUS_COMPASS_ALWAYS_ON,
        getFunc = function()
          return Provinatus.SavedVars.Compass.AlwaysOn
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Compass.AlwaysOn = value
        end,
        tooltip = PROVINATUS_COMPASS_ALWAYS_ON_TT,
        width = "full",
        default = ProvinatusConfig.Compass.AlwaysOn
      },
      [5] = {
        type = "colorpicker",
        name = PROVINATUS_COMPASS_COLOR,
        getFunc = function()
          return Provinatus.SavedVars.Compass.Color.r, Provinatus.SavedVars.Compass.Color.g, Provinatus.SavedVars.Compass.Color.b, Provinatus.SavedVars.Compass.Alpha
        end,
        setFunc = function(Red, Green, Blue, Alpha)
          Provinatus.SavedVars.Compass.Color.r = Red
          Provinatus.SavedVars.Compass.Color.g = Green
          Provinatus.SavedVars.Compass.Color.b = Blue
          Provinatus.SavedVars.Compass.Alpha = Alpha
          ProvinatusCompass.UpdateMenuIconColors()
        end,
        tooltip = PROVINATUS_COMPASS_COLOR_TT,
        width = "full",
        default = {r = ProvinatusConfig.Compass.Color.r, g = ProvinatusConfig.Compass.Color.g, b = ProvinatusConfig.Compass.Color.b, a = ProvinatusConfig.Compass.Alpha}
      }
    }
  }
end

function ProvinatusCompass.SetMenuIcon()
  ProvinatusCompass.MenuIcons = {}
  ProvinatusCompass.MenuIcons.North = CreateMenuIconCardinalPoint(TOP, GetString(SI_COMPASS_NORTH_ABBREVIATION))
  ProvinatusCompass.MenuIcons.East = CreateMenuIconCardinalPoint(RIGHT, GetString(SI_COMPASS_EAST_ABBREVIATION))
  ProvinatusCompass.MenuIcons.South = CreateMenuIconCardinalPoint(BOTTOM, GetString(SI_COMPASS_SOUTH_ABBREVIATION))
  ProvinatusCompass.MenuIcons.West = CreateMenuIconCardinalPoint(LEFT, GetString(SI_COMPASS_WEST_ABBREVIATION))
end

function ProvinatusCompass.UpdateMenuIconColors()
  for _, Icon in pairs(ProvinatusCompass.MenuIcons) do
    Icon:SetColor(Provinatus.SavedVars.Compass.Color.r, Provinatus.SavedVars.Compass.Color.g, Provinatus.SavedVars.Compass.Color.b, 1)
  end
end
