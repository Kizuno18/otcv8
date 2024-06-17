local bixos = macro(1, "Atacar Mobs", function() 
    local battlelist = getSpectators();
    local closest = 12
    local lowesthpc = 101
    for key, val in pairs(battlelist) do
      if val:isMonster() then
        if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
          closest = getDistanceBetween(player:getPosition(), val:getPosition())
          if val:getHealthPercent() < lowesthpc then
            lowesthpc = val:getHealthPercent()
          end
        end
      end
    end
    for key, val in pairs(battlelist) do
      if val:isMonster() then
        if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
          if g_game.getAttackingCreature() ~= val and val:getHealthPercent() <= lowesthpc then 
            g_game.attack(val)
      delay(100)
            break
          end
        end
      end
    end
  end)