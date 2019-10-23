function initConfig(versionNumber, addOnVersion) {
  const config = {};
  config.name = 'Provinatus';
  config.friendlyName = config.name;
  config.author = '@AlbinoPython (NA Server)';
  config.apiVersion = 100029;
  config.compatibility = '5.2.0';
  config.version = versionNumber;
  config.addOnVersion = addOnVersion;
  config.filesNeedingVersion = ['Config.lua'];
  config.sourceFiles = ['**/*.lua', 'bindings.xml', `${config.name}.txt`, 'Icons/**'];
  config.luaFilesToLint = [`./${config.name}/**/*.lua`];
  config.manifest = {
    Title: `|cFF69B4${config.friendlyName}|r ${config.version}`,
    Description: 'Heads up display that shows: group members\' locations, quest markers, rally points, and more',
    Author: `|cFF69B4${config.author}|r`,
    SavedVariables: 'ProvinatusVariables',
    DependsOn: 'LibAddonMenu-2.0',
    OptionalDependsOn: 'pChat LibGPS DungeonChampions SkyShards LoreBooks LostTreasure',
    APIVersion: config.apiVersion,
    AddOnVersion: config.addOnVersion,
    Version: config.version
  };
  config.manifestFiles = [
    // Order matters!
    'bindings.xml',
    'Lang/$(language).lua',
    'Config.lua',
    'Provinatus.lua',
    'Data/LoreBooks.lua',
    'Data/POITextures.lua',
    'Data/Skyshards.lua',
    'Data/TreasureMaps.lua',
    'Layers/AVA.lua',
    'Layers/Compass.lua',
    'Layers/Display.lua',
    'Layers/DungeonChampions.lua',
    'Layers/LoreBooks.lua',
    'Layers/PlayerOrientation.lua',
    'Layers/POI.lua',
    'Layers/Pointer.lua',
    'Layers/RallyPoint.lua',
    'Layers/Quests.lua',
    'Layers/ServicePins.lua',
    'Layers/Skyshards.lua',
    'Layers/Team.lua',
    'Layers/TreasureMaps.lua',
    'Layers/Waypoint.lua',
    'Layers/WorldEvents.lua',
    'Menu.lua',
    'Projection.lua'
  ];
  config.readme = 'esoui-readme.txt';
  config.changelog = 'esoui-changelog.txt';
  config.stringsDir = 'Build/strings';

  return config;
}

module.exports = initConfig;