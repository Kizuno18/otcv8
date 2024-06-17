setDefaultTab("HP")
UI.Separator()

-- Configurações
if not storage.settings then
  storage.settings = {
    healing_hp = {on=false, title="HP%", text="Spell", min=0, max=99},
    healing_mp = {on=true, title="MP%", text="Spell", min=0, max=99},
    ExevoGranMasVisSpell = "Exevo Gran Mas Vis",
    ExevoGranMasFlamSpell = "Exevo Gran Mas Flam"
  }
end

local settings = storage.settings

-- Magias de Cura

UI.Label("Magias de Cura"):setColor("green")

UI.Separator()

UI.Label("Healing - HP")
local healingInfo_hp = settings.healing_hp -- Obtenha as configurações para o HP
local healingmacro_hp = macro(20, function()
  local hp = player:getHealthPercent()
  if healingInfo_hp.max >= hp and hp >= healingInfo_hp.min then
    say(healingInfo_hp.text)
  end
end)
healingmacro_hp.setOn(healingInfo_hp.on)

UI.DualScrollPanel(healingInfo_hp, function(widget, newParams) 
  settings.healing_hp = newParams
  healingmacro_hp.setOn(newParams.on)
  saveConfig()
end)

UI.Separator()

UI.Label("Healing - MP")
local healingInfo_mp = settings.healing_mp -- Obtenha as configurações para o MP
local healingmacro_mp = macro(20, function()
  local mp = player:getMana()
  if healingInfo_mp.max >= mp and mp >= healingInfo_mp.min then
    say(healingInfo_mp.text)
  end
end)
healingmacro_mp.setOn(healingInfo_mp.on)

UI.DualScrollPanel(healingInfo_mp, function(widget, newParams) 
  settings.healing_mp = newParams
  healingmacro_mp.setOn(newParams.on)
  saveConfig()
end)

UI.Separator()
