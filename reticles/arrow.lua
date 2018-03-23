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
  if ProvinatusConfig.Debug then
    DistanceToTarget = ProvinatusConfig.DebugSettings.Reticle.DistanceToTarget
    DX = ProvinatusConfig.DebugSettings.Reticle.DX
    DY = ProvinatusConfig.DebugSettings.Reticle.DY
    AngleToTarget = ProvinatusConfig.DebugSettings.Reticle.AngleToTarget
    Linear = ProvinatusConfig.DebugSettings.Reticle.Linear
    AbsoluteLinear = ProvinatusConfig.DebugSettings.Reticle.AbsoluteLinear
  end

  if not Arrow then
    return
  elseif ProvinatusConfig.Debug then
    Arrow:SetAlpha(1)
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
