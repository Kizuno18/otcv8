setDefaultTab("Cave")

g_ui.loadUIFromString([[
CaveBotControlPanel < Panel
  margin-top: 5
  layout:
    type: verticalBox
    fit-children: true

  HorizontalSeparator
  
  Label
    text-align: center
    text: CaveBot Control Panel
    font: verdana-11px-rounded
    margin-top: 3

  HorizontalSeparator
    
  Panel
    id: buttons
    margin-top: 2
    layout:
      type: grid
      cell-size: 86 20
      cell-spacing: 1
      flow: true
      fit-children: true

  HorizontalSeparator
    margin-top: 3
]])

g_ui.loadUIFromString([[
RefillMPandHP < Panel
  height: 65
  margin-top: 2

  Label
    id: title
    text-align: center
    text: Refill HP & MP before next WP
    anchors.top: parent.top
    font: verdana-11px-rounded
    margin-top: 3

  Label
    id: refillHPLabel
    text: HP > 90%
    text-align: center
    font: verdana-11px-rounded
    anchors.top: title.bottom
    anchors.left: parent.left
    margin-top: 3

  HorizontalScrollBar
    id: refillHPScroll
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1

  Label
    id: refillMPLabel
    text: MP > 90%
    text-align: center
    font: verdana-11px-rounded
    anchors.top: title.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 3

  HorizontalScrollBar
    id: refillMPScroll
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: refillHPScroll.top
    margin-left: 2
    minimum: 0
    maximum: 100
    step: 1

  SmallBotSwitch
    id: switchRefill
    text: Force HP & MP Refill
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    text-align: center
    margin-top: 3
]])

local panel = UI.createWidget("CaveBotControlPanel")
local refillPanel = UI.createWidget("RefillMPandHP")

storage.caveBot = {
  forceRefill = false,
  backStop = false,
  backTrainers = false,
  backOffline = false
}

-- [[ B U T T O N S ]] --

local forceRefill = UI.Button("Force Refill", function(widget)
    storage.caveBot.forceRefill = true
    print("[CaveBot] Going back on refill on next supply check.")
end, panel.buttons)

local backStop = UI.Button("Back & Stop", function(widget)
    storage.caveBot.backStop = true
    print("[CaveBot] Going back to city on next supply check and turning off CaveBot on depositer action.")
end, panel.buttons)

local backTrainers = UI.Button("To Trainers", function(widget)
    storage.caveBot.backTrainers = true
    print("[CaveBot] Going back to city on next supply check and going to label 'toTrainers' on depositer action.")
end, panel.buttons)

local backOffline = UI.Button("Offline", function(widget)
    storage.caveBot.backOffline = true
    print("[CaveBot] Going back to city on next supply check and going to label 'toOfflineTraining' on depositer action.")
end, panel.buttons)

if not storage.caveBot.forceHPandMPRefill then
  storage.caveBot.forceHPandMPRefill = {
    enabled = true,
    hp = 90,
    mp = 90
  }
end

refillPanel.switchRefill:setOn(storage.caveBot.forceHPandMPRefill.enabled)
refillPanel.switchRefill.onClick = function(widget)
  storage.caveBot.forceHPandMPRefill.enabled = not storage.caveBot.forceHPandMPRefill.enabled
  widget:setOn(storage.caveBot.forceHPandMPRefill.enabled)
end

refillPanel.refillHPScroll:setValue(storage.caveBot.forceHPandMPRefill.hp)
refillPanel.refillHPScroll.onValueChange = function(scroll, value)
  storage.caveBot.forceHPandMPRefill.hp = value
  refillPanel.refillHPLabel:setText("HP > " .. value .. "%") 
end

refillPanel.refillMPScroll:setValue(storage.caveBot.forceHPandMPRefill.mp)
refillPanel.refillMPScroll.onValueChange = function(scroll, value)
  storage.caveBot.forceHPandMPRefill.mp = value
  refillPanel.refillMPLabel:setText("HP > " .. value .. "%") 
end