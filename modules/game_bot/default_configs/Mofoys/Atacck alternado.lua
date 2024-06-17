local messageAttack = '!attack target'
local minLevelAttack = 1
local maxLevelAttack = 20000

local messageAttackarea = '!attack Area'
local minLevelAttackarea = 20001
local maxLevelAttackarea = 800000

macro(300, "Mode : Arma", function()
    local level = player:getLevel()
    if level >= minLevelAttack and level <= maxLevelAttack then
        say(messageAttack)
    elseif level >= minLevelAttackarea and level <= maxLevelAttackarea then
        say(messageAttackarea)
    end
end)
