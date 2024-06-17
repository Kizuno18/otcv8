revide = macro(100, "Matador de cuzao", nil, function()
  if attacker then 
    if attacker:getPosition() and attacker:getPosition().z == posz() then
      if g_game.isAttacking() then
        if g_game.getAttackingCreature():getName() ~= attacker:getName() then
          g_game.attack(attacker)
        end
      else
        g_game.attack(attacker)
      end
    end
  else
    if not g_game.isAttacking() then
    end
  end
  if targetTime then
    if now - targetTime > 250 then
      attacker = nil
    end
  end
end)
addIcon("Matador de cuzao", {outfit={mount=849,feet=10,legs=10,body=178,type=15,auxType=0,addons=3,head=48}, text="R.Pvp"},revide)

onMissle(function(missle)
  if revide.isOn() then
    local src = missle:getSource()
    if src.z ~= posz() then
      return
    end
    local shooterTile = g_map.getTile(src)
    if shooterTile then
      local creatures = shooterTile:getCreatures()
      if creatures[1] then
        if creatures[1]:isPlayer() then
          local destination = missle:getDestination()
          if posx() == destination.x and posy() == destination.y then
            if player:getName() ~= creatures[1]:getName() then
              if attacker ~= creatures[1] then
                attacker = creatures[1]
                targetTime = now
              end
            end
          end
        end
      end
    end
  end
end)