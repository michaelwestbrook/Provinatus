ProvinatusRallyPoint = {}

function ProvinatusRallyPoint.Update()
  local RallyX, RallyY = GetMapRallyPoint()
  if (RallyX ~= 0 or RallyY ~= 0) and Provinatus.SavedVars.RallyPoint.Enabled then
    local XProjected, YProjected = Provinatus:ProjectCoordinates(RallyX, RallyY)
    if ProvinatusRallyPoint.RallyPoint == nil then
      ProvinatusRallyPoint.RallyPoint = {}
      ProvinatusRallyPoint.RallyPoint.Icon = WINDOW_MANAGER:CreateControl(nil, Provinatus.TopLevelWindow, CT_TEXTURE)
      ProvinatusRallyPoint.RallyPoint.Icon:SetTexture("esoui/art/mappins/maprallypoint.dds")
      local animation, timeline = CreateSimpleAnimation(ANIMATION_TEXTURE, ProvinatusRallyPoint.RallyPoint.Icon)
      animation:SetImageData(32, 1)
      animation:SetFramerate(60)
      timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
      timeline:PlayFromStart()
    end

    ProvinatusRallyPoint.RallyPoint.Icon:SetAnchor(CENTER, Provinatus.TopLevelWindow, CENTER, XProjected, YProjected)
    ProvinatusRallyPoint.RallyPoint.Icon:SetAlpha(Provinatus.SavedVars.RallyPoint.Alpha)
    ProvinatusRallyPoint.RallyPoint.Icon:SetDimensions(Provinatus.SavedVars.RallyPoint.Size, Provinatus.SavedVars.RallyPoint.Size)
  elseif ProvinatusRallyPoint.RallyPoint ~= nil and ProvinatusRallyPoint.RallyPoint.Icon ~= nil and ProvinatusRallyPoint.RallyPoint.Icon:GetAlpha() ~= 0 then
    ProvinatusRallyPoint.RallyPoint.Icon:SetAlpha(0)
  end
end

function ProvinatusRallyPoint.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_RALLYPOINT,
    reference = "ProvinatusRallyPointMenu",
    controls = ProvinatusMenu.GetIconSettingsMenu(
      PROVINATUS_RALLYPOINT_SETTINGS,
      function()
        return Provinatus.SavedVars.RallyPoint.Size
      end,
      function(value)
        Provinatus.SavedVars.RallyPoint.Size = value
      end,
      function()
        return Provinatus.SavedVars.RallyPoint.Alpha * 100
      end,
      function(value)
        Provinatus.SavedVars.RallyPoint.Alpha = value / 100
      end,
      ProvinatusConfig.RallyPoint.Size,
      ProvinatusConfig.RallyPoint.Alpha * 100,
      false
    )
  }
end

function ProvinatusRallyPoint.SetMenuIcon()
  local Icon = ProvinatusMenu.DrawMenuIcon(ProvinatusRallyPointMenu.arrow, "esoui/art/mappins/maprallypoint.dds")
  local animation, timeline = CreateSimpleAnimation(ANIMATION_TEXTURE, Icon)
  animation:SetImageData(32, 1)
  animation:SetFramerate(60)
  timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
  timeline:PlayFromStart()
end
