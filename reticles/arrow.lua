ArrowReticle = {}
ArrowReticle.size = 50

local texture = "esoui/art/floatingmarkers/quest_icon_assisted.dds"
local Arrow
function ArrowReticle.Initialize()
  Arrow = Arrow or WINDOW_MANAGER:CreateControl("Arrow", CrownPointerThingIndicator, CT_TEXTURE)
  Arrow:SetDimensions(ArrowReticle.size, ArrowReticle.size)
  Arrow:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, 0, ArrowReticle.size / 2)
  Arrow:SetTexture(texture)
  Arrow:SetAlpha(1)
end

function ArrowReticle.UpdateTexture(DistanceToTarget, DX, DY, AngleToTarget, Linear, AbsoluteLinear)
  if not Arrow then
    return
  elseif IsUnitGroupLeader("player") then
    Arrow:SetAlpha(0)
    return
  end
  -- From Exterminatus
  local R = 1
  local G = 1 - AbsoluteLinear
  local B = 1 - math.min(AbsoluteLinear, 0.05) * 20
  Arrow:SetTextureRotation(math.pi - AngleToTarget)
  Arrow:SetColor(R, G, B)
end
