setDefaultTab("RR")
UI.Label("Ligue todos para combar"):setColor("green")
UI.Label("so usa com cavebot LIGADO"):setColor("green")

local minLevelEGG = 20000
local maxLevelegg = 901008

local config = {
  ["0.75x Egg"] = {interval = 3000, text = "0.75x", id = 11683, count = 5},
  ["2x Egg"] = {interval = 3000, text = "2x", id = 3606, count = 5},
  ["2.5x Egg"] = {interval = 5000, text = "2.5x", id = 6541, count = 5},
  ["3x Egg"] = {interval = 7000, text = "3x", id = 6542, count = 5},
  ["4x Egg"] = {interval = 17000, text = "4x", id = 6543, count = 5},
  ["5x Egg"] = {interval = 11000, text = "5x", id = 6544, count = 5},
  ["6x Egg"] = {interval = 13000, text = "6x", id = 6545, count = 5},
  ["7x Egg"] = {interval = 15000, text = "7x", id = 3215, count = 5},
}

for macroName, param in pairs(config) do
  param.macro = macro(param.interval,macroName,function()
    if g_game.isAttacking() and not isInPz() then
      useWith(param.id, player)
    end
  end)
  -- addIcon(macroName..'fire', {item = 7465, text = ''}, param.macro) -- icon fire ?
  addIcon(macroName..'icon', {item = {id = param.id, count = param.count}, text = param.text}, param.macro)
end

local function ativarTodasMacros(enabled)
  for macroName, param in pairs(config) do
    if param.macro then
      param.macro.setOn(enabled)
    end
  end
end

macro(100, "ativarEgg", function()
  local level = player:getLevel()
  if level >= minLevelEGG and level <= maxLevelegg then
      ativarTodasMacros(true)
  else
      ativarTodasMacros(false)
  end
end)