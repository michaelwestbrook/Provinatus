-- Note ALL settings are overridden by saved variables.
ProvinatusConfig = {
  CrownPointer = {
    -- Controls transparency of the central crown pointer thing.
    Enabled = true,
    Alpha = 1,
    Size = 50,
    Texture = "esoui/art/floatingmarkers/quest_icon_assisted.dds"
  },
  PlayerIconSettings = {
    CrownAlpha = 1.0,
    CrownDeadAlpha = 1.0,
    NonCrownAlpha = 1.0,
    NonCrownDeadAlpha = 1.0
  },
  PlayerIcons = {
    Dead = "/esoui/art/icons/poi/poi_groupboss_incomplete.dds",
    ResurrectionPending = "/esoui/art/icons/poi/poi_groupboss_complete.dds",
    Crown = {
      Alive = "EsoUI/Art/Compass/groupLeader.dds",
    },
    dps = {
      Alive = "/esoui/art/lfg/lfg_dps_up.dds",
    },
    tank = {
      Alive = "/esoui/art/lfg/lfg_tank_up.dds",
    },
    healer = {
      Alive = "/esoui/art/lfg/lfg_healer_up.dds",
    }
  },
  Debug = false,
  DebugSettings = {
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
