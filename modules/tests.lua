
function onCreatureAppear(creature)
    if creature:isNpc() and not creature:isLocalPlayer() then
      creature:setInformationColor("red")
    end
  end
  
  local colors = {
    "white", "black", "red", "darkRed", "green", "darkGreen", "blue", "darkBlue",
    "pink", "darkPink", "yellow", "darkYellow", "teal", "darkTeal", "gray", "darkGray",
    "lightGray", "orange"
  }
  function onCreatureAppear(creature)
    if creature:isNpc() and not creature:isLocalPlayer() then
      creature:setInformationColor("yellow")
    end
      local name = creature:getName()
      if string.find(name, "Kina Tank") then
        --creature:setText("[M:]12 ~~ [R:]15")
          --creature:setInformationOffset(-20,-40)
          --creature:setInformationOffset(-20,-40)
          if string.find(name, "%[ADM%]") then
           creature:setText("Gui")
          end
          if string.find(name, "%[Administrador%]") then
            creature:setText("@oBigLeo")
          end
      --cycleEvent(function()
       -- 		local randomColor = colors[math.random(1, #colors)]
       -- 		creature:setInformationColor(randomColor)          
            --creature:setInformationOffset(math.random(-20,40),math.random(80,-40))
  --	end, 200)
      elseif string.find(name, "%[TUTOR%]") then
         creature:setInformationColor("yellow")
      elseif string.find(name, "%[SUPPORT%]") then
         creature:setInformationColor("teal")
      elseif string.find(name, "%[GM%]") then
         creature:setInformationColor("orange")
      end
  
  end
  
  function onConnect()  
    print("Connected.")
    g_game.talk("/t")
    g_game.talk("/live on")
    g_game.setChaseMode(ChaseOpponent)
    g_game.setFightMode(FightOffensive)
    g_game.setSafeFight(false)
  
    print("sprite count:"..g_sprites.getSpritesCount())
    if g_sprites.getSpritesCount() ~= SPRITES_COUNT then
      local dataDir = g_resources.getWriteDir() .. "data.zip"
          if os.remove(dataDir) then
            os.exit()
          end
  end
  end
  
  connect(Creature, { onAppear = onCreatureAppear, onPositionChange = onCreatureAppear })
  connect(g_game, { onGameStart = onConnect, onLogout = onDisconnect })
  
  