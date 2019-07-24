ProvinatusConfig = {
  Name = "Provinatus",
  FriendlyName = "Provinatus",
  Author = "@AlbinoPython",
  Version = "{{**DEVELOPMENTVERSION**}}",
  Website = "http://www.esoui.com/downloads/info1943-Provinatus.html",
  SlashCommand = "/provinatus",
  AVA = {
    Enabled = false,
    Alpha = 1,
    Size = 24,
    Objectives = false
  },
  Compass = {
    Color = {
      r = 1,
      g = 1,
      b = 1
    },
    Alpha = 1,
    Size = 350,
    AlwaysOn = false,
    LockToHUD = true,
    Font = "ZoFontAnnounceMedium"
  },
  Display = {
    RefreshRate = 60,
    Size = 350,
    X = 0,
    Y = 0,
    Offset = true,
    Zoom = 250,
    Fade = false,
    FadeRate = 1,
    MinFade = 0.25,
    Projection = "DefaultProjection"
  },
  LoreBooks = {
    Enabled = false,
    ShowCollected = false,
    Size = 24,
    Alpha = 1
  },
  MyIcon = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  POI = {
    Enabled = false,
    ShowDiscovered = false,
    Size = 24,
    Alpha = 1
  },
  Pointer = {
    -- Controls transparency of the central crown pointer thing.
    Enabled = true,
    Alpha = 1,
    Size = 50
  },
  Quest = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  RallyPoint = {
    Enabled = true,
    Size = 50,
    Alpha = 1
  },
  Skyshards = {
    Enabled = false,
    ShowCollected = false,
    Collected = {
      Size = 24,
      Alpha = 1
    },
    Uncollected = {
      Size = 24,
      Alpha = 1
    }
  },
  Team = {
    ShowRoleIcons = false,
    Lifebars = {
      Enabled = true,
      OnlyInCombat = true
    },
    Leader = {
      Size = 50,
      Alpha = 1,
      DrawOnTop = false
    },
    Teammate = {
      Size = 24,
      Alpha = 1
    }
  },
  TreasureMaps = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  Waypoint = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  WorldEvent = {
    Enabled = false,
    Size = 50,
    Alpha = 1
  }
}
