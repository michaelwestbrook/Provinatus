ArrowReticle = {}

local Arrow
function ArrowReticle.Initialize()
  Arrow = Arrow or WINDOW_MANAGER:CreateControl("Arrow", CrownPointerThingIndicator, CT_TEXTURE)
  Arrow:SetDimensions(ProvinatusConfig.CrownPointer.Width, ProvinatusConfig.CrownPointer.Height)
  Arrow:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, 0, ProvinatusConfig.CrownPointer.Height / 2)
  Arrow:SetTexture(ProvinatusConfig.CrownPointer.Texture)
  Arrow:SetAlpha(ProvinatusConfig.CrownPointer.Alpha)
end

function ArrowReticle.UpdateTexture(DistanceToTarget, DX, DY, AngleToTarget, Linear, AbsoluteLinear)
  if not Arrow then
    return
  elseif IsUnitSoloOrGroupLeader("player") or ZO_ReticleContainer:IsHidden() then
    Arrow:SetAlpha(0)
    return
  end
  -- Why didn't I write a comment here?
  local AbsAngleToTarget = math.abs(AngleToTarget)
  local R = AbsAngleToTarget / 2
  local G = math.pi - AbsAngleToTarget
  local B = 0
  Arrow:SetTextureRotation(math.pi - AngleToTarget)
  Arrow:SetColor(R, G, B)
  Arrow:SetAlpha(ProvinatusConfig.CrownPointer.Alpha)
end
