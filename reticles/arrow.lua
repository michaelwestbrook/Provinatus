ArrowReticle = {}

local Arrow
function ArrowReticle.Initialize()
  Arrow = Arrow or WINDOW_MANAGER:CreateControl("Arrow", CrownPointerThingIndicator, CT_TEXTURE)
  Arrow:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, 0, CrownPointerThing.SavedVars.CrownPointer.Size / 2)
  Arrow:SetTexture(CrownPointerThing.SavedVars.CrownPointer.Texture)
end

function ArrowReticle.UpdateTexture(DistanceToTarget, DX, DY, AngleToTarget, Linear, AbsoluteLinear)
  if not Arrow then
    return
  end

  if not CrownPointerThing.SavedVars.CrownPointer.Enabled then
    Arrow:SetAlpha(0)
    return
  end
  
  if IsUnitSoloOrGroupLeader("player") or ZO_ReticleContainer:IsHidden() or IsActiveWorldBattleground() then
    Arrow:SetAlpha(0)
    if not CrownPointerThing.SavedVars.Debug then
      return
    end
  end

  if CrownPointerThing.SavedVars.Debug then
    AngleToTarget = CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget
  end
  
  -- Why didn't I write a comment here?
  local AbsAngleToTarget = math.abs(AngleToTarget)
  local R = AbsAngleToTarget / 2
  local G = math.pi - AbsAngleToTarget
  local B = 0
  Arrow:SetTextureRotation(math.pi - AngleToTarget)
  Arrow:SetColor(R, G, B)
  Arrow:SetAlpha(CrownPointerThing.SavedVars.CrownPointer.Alpha)
  Arrow:SetDimensions(CrownPointerThing.SavedVars.CrownPointer.Size, CrownPointerThing.SavedVars.CrownPointer.Size)
end
