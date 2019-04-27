ProvinatusWaypoint = {}

local Texture = "esoui/art/compass/compass_waypoint.dds"
function ProvinatusWaypoint.Update()
  local Elements = {}
  local WaypointX, WaypointY = GetMapPlayerWaypoint()
  if WaypointX ~= 0 and WaypointY ~= 0 then
    table.insert(
      Elements,
      {
        X = WaypointX,
        Y = WaypointY,
        Alpha = 1,
        Texture = Texture,
        Width = 24,
        Height = 24
      }
    )
  end
  
  Provinatus.DrawElements(ProvinatusWaypoint, Elements)
end

function ProvinatusWaypoint.GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_WAYPOINT,
    reference = "ProvinatusWaypointMenu",
    controls = ProvinatusMenu.GetIconSettingsMenu(
      PROVINATUS_WAYPOINT_SETTINGS,
      function()
        return Provinatus.SavedVars.Waypoint.Size
      end,
      function(value)
        Provinatus.SavedVars.Waypoint.Size = value
      end,
      function()
        return Provinatus.SavedVars.Waypoint.Alpha * 100
      end,
      function(value)
        Provinatus.SavedVars.Waypoint.Alpha = value / 100
      end,
      ProvinatusConfig.Waypoint.Size,
      ProvinatusConfig.Waypoint.Alpha * 100,
      false
    )
  }
end

function ProvinatusWaypoint.SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(ProvinatusWaypointMenu.arrow, Texture)
end