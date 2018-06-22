-- Note ALL settings are overridden by saved variables.
ProvinatusConfig = {
  Name = "Provinatus",
  CrownPointer = {
    -- Controls transparency of the central crown pointer thing.
    Enabled = true,
    Alpha = 1,
    Size = 50,
    Texture = "esoui/art/floatingmarkers/quest_icon_assisted.dds"
  },
  PlayerIcons = {
    Dead = "/esoui/art/icons/poi/poi_groupboss_incomplete.dds",
    ResurrectionPending = "/esoui/art/icons/poi/poi_groupboss_complete.dds",
    Crown = {
      Alive = "EsoUI/Art/Compass/groupLeader.dds",
    }
  },
  HUD = {
    Size = 350,
    -- TODO enable role icons
    ShowRoleIcons = false,
    TargetIconAlpha = 1,
    TargetIconSize = 48,
    PlayerIconAlpha = 0.75,
    PlayerIconSize = 24,
    Compass = {
      AlwaysOn = false,
      Alpha = 1
    },
    RefreshRate = 60
  },
  Debug = false,
  DebugSettings = {
    CrownPositionOverride = false,
    TargetX = 0,
    TargetY = 0,
    Reticle = {
      DistanceToTarget = 0,
      DX = 0,
      DY = 0,
      AngleToTarget = 0.0,
      Linear = 0,
      AbsoluteLinear = 0
    }
  }
}
