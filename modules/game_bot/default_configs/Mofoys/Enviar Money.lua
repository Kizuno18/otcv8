-- Configurações
if not storage.settings then
    storage.settings = {
        enviarMoneyCharacterName = "Enviar money",
        enviarPepitasCharacterName = "Enviar pepitas"
    }
end

local settings = storage.settings

function saveConfig()
    storage.settings = settings
end

setDefaultTab("Enviar")

-- Adicione o text edit para enviarMoneyCharacterName
addTextEdit("enviarMoneyCharacterName", settings.enviarMoneyCharacterName, function(widget, text)
    settings.enviarMoneyCharacterName = text
    saveConfig()
end)

-- Função para enviar a mensagem de transferência de dinheiro
local function sendTransferMoneyMessage(characterName)
    say("!transferall " .. characterName)
end

-- Função para iniciar a macro de transferência de dinheiro
local function startTransferMoneyMacro()
    -- Envia a mensagem de transferência
    sendTransferMoneyMessage(settings.enviarMoneyCharacterName)
end

-- Iniciar a macro de transferência de dinheiro
macro(300000, "Enviar Money", startTransferMoneyMacro)

UI.Separator()

-- Adicione o text edit para enviarPepitasCharacterName
addTextEdit("enviarPepitasCharacterName", settings.enviarPepitasCharacterName, function(widget, text)
    settings.enviarPepitasCharacterName = text
    saveConfig()
end)

-- Função para enviar a mensagem de transferência de pepitas
local function sendTransferPepitasMessage(characterName)
    say("!peptransferall " .. characterName)
end

-- Função para iniciar a macro de transferência de pepitas
local function startTransferPepitasMacro()
    -- Envia a mensagem de transferência
    sendTransferPepitasMessage(settings.enviarPepitasCharacterName)
end

-- Iniciar a macro de transferência de pepitas
macro(300000, "Enviar Pepitas", startTransferPepitasMacro)
