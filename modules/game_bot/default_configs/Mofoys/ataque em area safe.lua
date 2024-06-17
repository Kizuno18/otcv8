-- Configurações
if not storage.settings then
    storage.settings = {
      ExevoGranMasVisSpell = "Exevo Gran Mas Vis",
      ExevoGranMasFlamSpell = "Exevo Gran Mas Flam"
    }
  end
  
  local settings = storage.settings
  


UI.Label("Magias seguras para farmar,"):setColor("green")
UI.Label("usado se estiver atacando"):setColor("green")
UI.Label("E sem player na tela"):setColor("green")

addTextEdit("ExevoGranMasVisSpell", settings.ExevoGranMasVisSpell, function(widget, text)
    settings.ExevoGranMasVisSpell = text
    saveConfig()
end)

-- Lógica para Exevo Gran Mas Vis
macro(500, "Magia Target", function()
    local creatures = g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)
    local playersCount = 0

    for i, creature in ipairs(creatures) do
        if creature:isPlayer() and creature ~= g_game.getLocalPlayer() then
            playersCount = playersCount + 1
            break
        end
    end

    if playersCount == 0 and g_game.isAttacking() and not isInPz() then
        local spell = settings.ExevoGranMasVisSpell or "Exevo Gran Mas Vis"
        say(spell)
    end
end)

addTextEdit("ExevoGranMasFlamSpell", settings.ExevoGranMasFlamSpell, function(widget, text)
    settings.ExevoGranMasFlamSpell = text
    saveConfig()
end)

-- Lógica para Safe Gran Mas Flam
macro(500, "Magia Area", function()
    local creatures = g_map.getSpectators(g_game.getLocalPlayer():getPosition(), false)
    local playersCount = 0

    for i, creature in ipairs(creatures) do
        if creature:isPlayer() and creature ~= g_game.getLocalPlayer() then
            playersCount = playersCount + 1
            break
        end
    end

    if playersCount == 0 and g_game.isAttacking() then
        local spell = settings.ExevoGranMasFlamSpell or "Exevo Gran Mas Flam"
        say(spell)
    end
end)


-- Função para salvar as configurações
function saveConfig()
    storage.settings = settings
end

saveConfig() -- Salvar as configurações ao carregar o script