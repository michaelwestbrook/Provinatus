ProvinatusCompass = {
  CardinalPoints = {}
}

function ProvinatusCompass:Initialize()
  for i = 1, 4 do
    self.CardinalPoints[i] = WINDOW_MANAGER:CreateControl(nil, CrownPointerThingIndicator, CT_LABEL)
    self.CardinalPoints[i]:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, 0, 0)
    self.CardinalPoints[i]:SetFont("ZoFontHeader4")
  end

  self.CardinalPoints[1]:SetText(GetString(SI_COMPASS_NORTH_ABBREVIATION))
  self.CardinalPoints[2]:SetText(GetString(SI_COMPASS_EAST_ABBREVIATION))
  self.CardinalPoints[3]:SetText(GetString(SI_COMPASS_SOUTH_ABBREVIATION))
  self.CardinalPoints[4]:SetText(GetString(SI_COMPASS_WEST_ABBREVIATION))
end

function ProvinatusCompass:OnUpdate()
  local CameraHeading = GetPlayerCameraHeading()
  for i = 1, 4 do
    -- Only show compass if player is in group or if AlwaysOn is selected in the menu.
    if IsUnitGrouped("player") or CrownPointerThing.SavedVars.HUD.Compass.AlwaysOn  then
      local heading = (i - 2) * math.pi / 2 + CameraHeading
      local CardinalDirectionX = CrownPointerThing.SavedVars.HUD.Size * math.cos(heading) + CrownPointerThing.SavedVars.HUD.PositionX
      local CardinalDirectionY = CrownPointerThing.SavedVars.HUD.Size * math.sin(heading) + CrownPointerThing.SavedVars.HUD.PositionY
      if CrownPointerThing.SavedVars.HUD.Offset then
        CardinalDirectionY = CardinalDirectionY + CrownPointerThing.SavedVars.CrownPointer.Size / 2
      end
      self.CardinalPoints[i]:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, CardinalDirectionX, CardinalDirectionY)
      self.CardinalPoints[i]:SetAlpha(CrownPointerThing.SavedVars.HUD.Compass.Alpha)
    elseif  self.CardinalPoints[i]:GetAlpha() ~= 0 then
      self.CardinalPoints[i]:SetAlpha(0)
    end
  end
end
