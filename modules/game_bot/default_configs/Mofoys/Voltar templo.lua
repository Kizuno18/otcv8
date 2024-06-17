flag = 0
UI.Label("10 segundos parado: "):setColor("green")
macro(500, "Fly Templo", function()
    if not player:isWalking() then
     flag = flag + 1
    end

    if player:isWalking() then
        flag = 0
    end

    if flag >= 20 then
        say('!fly templo')
    end

    if flag >= 20 then
      flag = 0
    end
end)
UI.Separator()
