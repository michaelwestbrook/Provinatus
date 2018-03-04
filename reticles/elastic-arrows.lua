ElasticArrowsReticle = {}

local texture = "esoui/art/miscellaneous/transform_arrow.dds"
local Left, Right
function ElasticArrowsReticle.Initialize()
  Left = InitializeArrow("LeftArrow", math.pi, -20, 0)
  Left = InitializeArrow("RightArrow", -math.pi, 20, 0)
end

function ElasticArrowsReticle.UpdateTexture(DistanceToTarget, AngleToTarget, AbsoluteLinear)
  if not Arrow then
    return
  end
  local R = 1
  local G = 1 - AbsoluteLinear
  local B = 1 - math.min(AbsoluteLinear, 0.05) * 20
  
  Arrow:SetColor(R, G, B)
end

function InitializeArrow(name, rotationAngle, x, y)
  local Arrow = WINDOW_MANAGER:CreateControl(name, CrownPointerThingIndicator, CT_TEXTURE)
  Arrow:SetDimensions(80, 80)
  Arrow:SetAnchor(CENTER, CrownPointerThingIndicator, CENTER, 0, 0)
  Arrow:SetTexture(texture)
  Arrow:SetAlpha(1)
  Arrow:SetTextureRotation(rotationAngle)
  return Arrow
end
