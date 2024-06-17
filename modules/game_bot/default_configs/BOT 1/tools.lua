-- tools tab
setDefaultTab("Tools")

if type(storage.moneyItems) ~= "table" then
  storage.moneyItems = {3031, 3035}
end
macro(1000, "Exchange money", function()
  if not storage.moneyItems[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(storage.moneyItems) do
            if item:getId() == moneyId.id then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  storage.moneyItems = items
end, true)
moneyContainer:setHeight(35)
moneyContainer:setItems(storage.moneyItems)

UI.Separator()

macro(60000, "Send message on trade", function()
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "I'm using Cliente 14!", function(widget, text)    
  storage.autoTradeMessage = text
end)

UI.Separator()

UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)

UI.Separator()

    UI.Label("Items")

setDefaultTab("Tools")

UI.Separator()

if type(storage.pickUp) ~= "table" then
  storage.pickUp = {3725, 3723}
end

if type(storage.containerpickUp) ~= "table" then
  storage.containerpickUp = {5926}
end

local pickUpContainer = UI.Container(function(widget, items)
  storage.pickUp = items
end, true)
pickUpContainer:setHeight(35)
pickUpContainer:setItems(storage.pickUp)

local CheckPOS = 3 -- a quantidade de SQM em volta do char que vai checar.. eu deixo 1.

UI.Label("Containers Catar")
local containerpickUpContainer = UI.Container(function(widget, items)
  storage.containerpickUp = items
end, true)
containerpickUpContainer:setHeight(35)
containerpickUpContainer:setItems(storage.containerpickUp)
Catar = addIcon("Catar", {item =13205, text = "Catar", hotkey = "F5"}, 
macro(20, "Catar no chao", "", function()
  if not storage.pickUp[1] then return end
  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
    local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
      local things = tile:getThings()
        for a , item in pairs(things) do
          for c, catar in pairs(storage.pickUp) do
            if table.find(catar, item:getId()) then
            local containers = getContainers()
              for _, container in pairs(containers) do            
                for g, guardar in pairs(storage.containerpickUp) do
                  if table.find(guardar, container:getContainerItem():getId()) then
                    g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())                
                  end  
                end
              end
            end
          end
        end
      end
    end
  end
end) )
Catar:breakAnchors()
Catar:move(X, Y) --ira mover os icons, caso seja pc utilize o ctrl + botao esquerdo pra mover. ex (300, 500)
UI.Separator()