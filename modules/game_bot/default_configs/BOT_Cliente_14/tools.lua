-- tools tab
setDefaultTab("Tools")

UI.Button("Ingame macro editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros or "", {title="Macro editor", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros = text
    reload()
  end)
end)
UI.Button("Ingame hotkey editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_macros, storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end

UI.Separator()

UI.Button("Zoom In map [ctrl + =]", function() zoomIn() end)
UI.Button("Zoom Out map [ctrl + -]", function() zoomOut() end)

UI.Separator()

local moneyIds = {3031, 3035} -- gold coin, platinium coin
macro(1000, "Exchange money", function()
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

macro(1000, "Stack items", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)

UI.Separator()
UI.Label("Drop items:")
if type(storage.dropItems) ~= "table" then
  storage.dropItems = {283, 284, 285}
end

local foodContainer = UI.Container(function(widget, items)
  storage.dropItems = items
end, true)
foodContainer:setHeight(35)
foodContainer:setItems(storage.dropItems)

macro(5000, "drop items", function()
  if not storage.dropItems[1] then return end
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  for _, container in pairs(g_game.getContainers()) do
    for __, item in ipairs(container:getItems()) do
      for i, dropItem in ipairs(storage.dropItems) do
        if item:getId() == dropItem.id then
          if item:isStackable() then
            return g_game.move(item, player:getPosition(), item:getCount())
          else
            return g_game.move(item, player:getPosition(), dropItem.count) -- count is also subtype
          end
        end
      end
    end
  end
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

macro(3600000, "Send message on help", function()
  local trade = getChannelId("help")
  if not trade then
    trade = getChannelId("9")
  end
  if trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "(Mensagem automatica) Entrem no Discord do Demolidores la podemos lhe ajudar melhor! https://discord.gg/Fq5pEVgMMG", function(widget, text)    
  storage.autoTradeMessage = text
end)

UI.Separator()









function AddScrolls(panelName, parent)
  if not parent then
    parent = panel
  end
 
  local ui = setupUI([[
Panel
  height: 50
  margin-top: 2

  BotItem
    id: bpId
    anchors.left: parent.left
    anchors.top: parent.top

  BotLabel
    id: title
    anchors.left: bpId.right
    anchors.right: parent.right
    anchors.top: bpId.verticalCenter
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: bpId.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1
    
  HorizontalScrollBar
    id: scroll2
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 0
    maximum: 100
    step: 1    
  ]], parent)
  ui:setId(panelName)
  if not storage[panelName] or not storage[panelName].bpId then
    storage[panelName] = {
      min = 60,
      max = 90,
      bpId = 2854
    }
  end
  
  local updateText = function()
    ui.title:setText("" .. storage[panelName].min .. "% <= hp >= " .. storage[panelName].max .. "%")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
  ui.scroll2.onValueChange = function(scroll, value)
    storage[panelName].max = value
    updateText()
  end
  ui.bpId.onItemChange = function(widget)
    storage[panelName].bpId = widget:getItemId()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
  ui.scroll2:setValue(storage[panelName].max)
  ui.bpId:setItemId(storage[panelName].bpId)
end

local defaultAmulet = nil
macro(100, "Demolisher SSA", function()
  if hppercent() <= storage["ssa"].min and (getNeck() == nil or getNeck():getId() ~= 11868) then
    if getNeck() ~= nil and defaultAmulet == nil then
      defaultAmulet = getNeck():getId()
    end
    for _, container in pairs(getContainers()) do
      for _, item in ipairs(container:getItems()) do
        containerItem = container:getContainerItem():getId()
        if containerItem == storage["ssa"].bpId then
          if item:getId() == 11868 then
            moveToSlot(item, SlotNeck)
            delay(200)
            return
          end
        end
      end
    end
    if defaultAmulet ~= nil or (getNeck() ~= nil and getNeck():getId() ~= defaultAmulet) then
      amulet = findItem(defaultAmulet)
      if amulet then
        moveToSlot(amulet, SlotNeck)
      end
    end
    isAlreadyOpen = false
    for i, container in pairs(getContainers()) do
      containerItem = container:getContainerItem():getId()
      if containerItem == storage["ssa"].bpId then
        isAlreadyOpen = true
        for _, item in ipairs(container:getItems()) do
          if item:isContainer() and item:getId() == storage["ssa"].bpId then
            g_game.open(item, container)
            delay(200)
            return
          end
        end
      end
    end
    if not isAlreadyOpen then
      for i, container in pairs(getContainers()) do
        for _, item in ipairs(container:getItems()) do
          if item:isContainer() and item:getId() == storage["ssa"].bpId then
            g_game.open(item)
            delay(400)
            return
          end
        end
      end
    end
  elseif hppercent() >= storage["ssa"].max and defaultAmulet ~= nil then
    if getNeck() == nil or (getNeck() ~= nil and getNeck():getId() ~= defaultAmulet) then
      amulet = findItem(defaultAmulet)
      if amulet then
        moveToSlot(amulet, SlotNeck)
      end
    end
  end
end, toolsTab)
AddScrolls("ssa", toolsTab)
addSeparator("sep", toolsTab)

local defaultRing = nil
macro(100, "Equip E-Ring", function()
  if hppercent() <= storage["ering"].min and (getFinger() == nil or (getFinger():getId() ~= 3051 and getFinger():getId() ~= 3088)) then
    if getFinger() ~= nil and defaultRing == nil then
      defaultRing = getFinger()
    end
    ring = findItem(3051)
    findRing = false
    if ring then
      moveToSlot(ring, SlotFinger)
      delay(20)
    end

    if ring == nil then
      if defaultRing ~= nil or (getFinger() ~= nil and getFinger():getId() ~= defaultRing:getId()) then
        ring = findItem(defaultRing:getId())
        if ring then
          moveToSlot(ring, SlotFinger)
        end
      end
      findRing = true
    end

    if findRing then
      isAlreadyOpen = false
      for i, container in pairs(getContainers()) do
        containerItem = container:getContainerItem():getId()
        if containerItem == storage["ering"].bpId then
          isAlreadyOpen = true
          for _, item in ipairs(container:getItems()) do
            if item:isContainer() and item:getId() == storage["ering"].bpId then
              g_game.open(item, container)
              delay(30)
              return
            end
          end
        end
      end
      if not isAlreadyOpen then
        for i, container in pairs(getContainers()) do
          for _, item in ipairs(container:getItems()) do
            if item:isContainer() and item:getId() == storage["ering"].bpId then
              g_game.open(item)
              delay(40)
              return
            end
          end
        end
      end
    end
  elseif hppercent() >= storage["ering"].max and defaultRing ~= nil then
    if getFinger() == nil or (getFinger():getId() ~= defaultRing:getId()) then
      ring = findItem(defaultRing:getId())
      if ring then
        moveToSlot(ring, SlotFinger)
      end
    end
  end
end, toolsTab)
AddScrolls("ering", toolsTab)
addSeparator("sep", toolsTab)

function conjuringScript(parent)
  local panelName = "conjureScript"
 
  local ui = setupUI([[
Panel
  height: 60
  margin-top: 2

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: title.left
    anchors.right: title.right
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1

  BotTextEdit
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: scroll1.bottom
    margin-top: 3 
  
  ]], parent)
  ui:setId(panelName)
 
  if not storage[panelName] then
    storage[panelName] = {
      min = 5,
      text = "adori dodge"
    }
  end
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  ui.text.onTextChange = function(widget, text)
    storage[panelName].text = text
  end
  ui.text:setText(storage[panelName].text or "adori dodge")
 
  local updateText = function()
    ui.title:setText("Conjure Spell Soul > " .. storage[panelName].min)  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
 
  macro(25, function()
    if storage[panelName].enabled and storage[panelName].text:len() > 0 and soul() >= storage[panelName].min then
      if saySpell(storage[panelName].text, 500) then
        delay(200)
      end
    end
  end)
end
conjuringScript(toolsTab)
addSeparator("sep", toolsTab)

function comboScript(parent)
  if not parent then
    parent = panel
  end
 
  local panelName = "comboScriptPanel"
 
  local ui = setupUI([[
SixRowsItems < Panel
  height: 220
  margin-top: 2
  
  BotItem
    id: item1
    anchors.top: parent.top
    anchors.left: parent.left

  BotItem
    id: item2
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item3
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item4
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item5
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item6
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2

  BotItem
    id: item7
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item8
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item9
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item10
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item11
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2
    
  BotItem
    id: item12
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item13
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item14
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item15
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item16
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2
    
  BotItem
    id: item17
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item18
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item19
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item20
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item21
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2
    
  BotItem
    id: item22
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item23
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item24
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item25
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item26
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2
    
  BotItem
    id: item27
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item28
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item29
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item30
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

Panel
  height: 240

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: title.left
    anchors.right: title.right
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 1
    maximum: 60
    step: 1

  SixRowsItems
    id: items
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom  
  ]], parent)
  ui:setId(panelName)
 
  if not storage[panelName] then
    storage[panelName] = {
      time = 31
    }
  end
 
  local updateText = function()
    ui.title:setText("Use every " .. storage[panelName].time .. " minutes")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].time = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].time)
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  if type(storage[panelName].items) ~= 'table' then
    storage[panelName].items = { 11455, 10316, 10306, 10293, 9650, 11454, 3726, 9642, 3215, 13202, 13203, 13204, 9641, 13435, 13436, 13437, 13273, 13274, 13275, 13513, 13220, 13507, 13508 }
  end
 
  for i=1,30 do
    ui.items:getChildByIndex(i).onItemChange = function(widget)
      storage[panelName].items[i] = widget:getItemId()
    end
    ui.items:getChildByIndex(i):setItemId(storage[panelName].items[i])    
  end
 
  macro(1000, function()
    if not storage[panelName].enabled then
      return
    end
    CaveBot.setOff()
    TargetBot.setOff()
    if #storage[panelName].items > 0 then
      timeOut = 5000
      for _, itemToUse in pairs(storage[panelName].items) do
        schedule(timeOut, function()
          use(itemToUse)
        end)
        timeOut = timeOut + 500
      end
    end
    schedule(timeOut + 5000, function()
      CaveBot.setOn()
      TargetBot.setOn()
    end)
    delay((storage[panelName].time * 60000) - 1000)
  end)
end
comboScript(toolsTab)
addSeparator("sep", toolsTab)

function staminaItems(parent)
  if not parent then
    parent = panel
  end
  local panelName = "staminaItemsUser"
  local ui = setupUI([[
Panel
  height: 65
  margin-top: 2

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 42
    step: 1
    
  HorizontalScrollBar
    id: scroll2
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 0
    maximum: 42
    step: 1    

  ItemsRow
    id: items
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
  ]], parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {
      min = 25,
      max = 40,
    }
  end

  local updateText = function()
    ui.title:setText("" .. storage[panelName].min .. " <= stamina >= " .. storage[panelName].max .. "")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
  ui.scroll2.onValueChange = function(scroll, value)
    storage[panelName].max = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
  ui.scroll2:setValue(storage[panelName].max)
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  if type(storage[panelName].items) ~= 'table' then
    storage[panelName].items = { 11588 }
  end
 
  for i=1,5 do
    ui.items:getChildByIndex(i).onItemChange = function(widget)
      storage[panelName].items[i] = widget:getItemId()
    end
    ui.items:getChildByIndex(i):setItemId(storage[panelName].items[i])    
  end
 
  macro(500, function()
    if not storage[panelName].enabled or stamina() / 60 < storage[panelName].min or stamina() / 60 > storage[panelName].max then
      return
    end
    local candidates = {}
    for i, item in pairs(storage[panelName].items) do
      if item >= 100 then
        table.insert(candidates, item)
      end
    end
    if #candidates == 0 then
      return
    end    
    use(candidates[math.random(1, #candidates)])
  end)
end
staminaItems(toolsTab)
addSeparator("sep", toolsTab)

-- open Backpacks when reconnect
containers = getContainers()
if #containers < 1 and containers[0] == nil then
  bpItem = getBack()
  if bpItem ~= nil then
    g_game.open(bpItem)
  end
  say("!bless")
end

macro(10000, "Anti Idle",  function()
  local oldDir = direction()
  turn((oldDir + 1) % 4)
  schedule(1000, function() -- Schedule a function after 1000 milliseconds.
    turn(oldDir)
  end)
end)

local mineableIds = {5636,5635,5632,3635,5732,7989,7996,8169,7994,8136,7994,5753,3661,3608,3662,8135,7995,7989,8168,5747,354,355,4475,4472,4473,4476,4470,4471,4474,4485,4473,4478,4477,3339,5623,5708,12840,11821,5622,4469}
local mineThing = nil
macro(10, "Mine", function()
  if mineThing == nil then
    tiles = g_map.getTiles(posz())
    randomTile = tiles[math.random(1,#tiles)]
    if not autoWalk(randomTile:getPosition(), 10, {ignoreNonPathable=true, marginMin=1, marginMax=2}) or getDistanceBetween(pos(), randomTile:getPosition()) > 4 then
      return
    end
    for _, thing in ipairs(randomTile:getThings()) do
      for _,mineableId in ipairs(mineableIds) do
        if thing:getId() == mineableId then
          mineThing = thing
          return
        end
      end
    end
  else
    useWith(3456,   mineThing)
	useWith(13832,  mineThing)
	useWith(13833,  mineThing)
  end
end)