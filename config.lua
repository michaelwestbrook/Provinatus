-- Note ALL settings are overridden by saved variables.
ProvinatusConfig = {
  Name = "Provinatus",
  CrownPointer = {
    -- Controls transparency of the central crown pointer thing.
    Enabled = true,
    Alpha = 1,
    Size = 50,
    DrawLevel = 1,
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
    Offset = true,
    ShowRoleIcons = false,
    TargetIconAlpha = 1,
    TargetIconSize = 48,
    TargetIconDrawLevel = 3,
    PlayerIconAlpha = 0.75,
    PlayerIconSize = 24,
    PlayerIconDrawLevel = 0,
    PositionX = 0,
    PositionY = 0,
    Compass = {
      AlwaysOn = false,
      Alpha = 1,
      Size = 350,
      LockToHUD = true,
      DrawLevel = 2
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
