-- CONFIG
APP_NAME = "BigOTC"  -- important, change it, it's name for config dir and files in appdata
APP_VERSION = 1535      -- client version for updater and login to identify outdated client
DEFAULT_LAYOUT = "retro" -- on android it's forced to "mobile", check code bellow
SPRITES_COUNT = 328155

-- If you don't use updater or other service, set it to updater = ""
Services = {
  website = "",updater = "http://bkin.hopto.org/otclient/updater_advanced.php", stats = "", crash = "",feedback = "",status = ""
}

Servers = {
  BigOT = "sv.bigot.com.br:7171:860"
}

ALLOW_CUSTOM_SERVERS = false -- if true it shows option ANOTHER on server list
g_app.setName(APP_NAME)

-- CONFIG END

-- print first terminal message
g_logger.info(os.date("== application started at %b %d %Y %X"))

if not g_resources.directoryExists("/data") then
  g_logger.fatal("Data dir doesn't exist.")
end

if not g_resources.directoryExists("/modules") then
  g_logger.fatal("Modules dir doesn't exist.")
end

-- settings
g_configs.loadSettings("/config.otml")

-- set layout
local settings = g_configs.getSettings()
local layout = DEFAULT_LAYOUT
if g_app.isMobile() then
  layout = "mobile"
elseif settings:exists('layout') then
  layout = settings:getValue('layout')
end
g_resources.setLayout(layout)

-- load mods
g_modules.discoverModules()
g_modules.ensureModuleLoaded("corelib")
  
local function loadModules()
  -- libraries modules 0-99
  g_modules.autoLoadModules(99)
  g_modules.ensureModuleLoaded("gamelib")

  -- client modules 100-499
  g_modules.autoLoadModules(499)
  g_modules.ensureModuleLoaded("client")

  -- game modules 500-999
  g_modules.autoLoadModules(999)
  g_modules.ensureModuleLoaded("game_interface")

  -- mods 1000-9999
  g_modules.autoLoadModules(9999)
end
g_window.setIcon('/images/clienticon')

dofile('modules/tests.lua')

-- report crash
if type(Services.crash) == 'string' and Services.crash:len() > 4 and g_modules.getModule("crash_reporter") then
  g_modules.ensureModuleLoaded("crash_reporter")
end

-- run updater, must use data.zip
if type(Services.updater) == 'string' and Services.updater:len() > 4 
  and g_resources.isLoadedFromArchive() and g_modules.getModule("updater") then
  g_modules.ensureModuleLoaded("updater")
  return Updater.init(loadModules)
end
loadModules()
