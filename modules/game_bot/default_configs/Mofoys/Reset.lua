setDefaultTab("RR")

UI.Separator()

local messageReset = '!resetar'
local minLevelReset = 900001
local maxLevelReset = 911008

macro(100, "Reset", function()
    local level = player:getLevel()
    if level >= minLevelReset and level <= maxLevelReset and isInProtectionZone() then
        say(messageReset)
    end
end)

-- Função para verificar se o jogador está em uma "protection zone"
local function isInProtectionZone()
    local tile = g_map.getTile(player:getPosition())
    return tile and tile:hasFlag(TileFlags.ProtectionZone)
end
