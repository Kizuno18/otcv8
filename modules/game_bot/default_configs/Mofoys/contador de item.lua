    -- Defina o ID do item que você deseja contar
    local itemID = 11683 -- ID do item "0.75x Egg"

    -- Função para contar a quantidade do item no inventário
    function countItemInInventory(itemID)
    local itemCount = 0
    for _, container in pairs(getContainers()) do
        for _, item in pairs(container:getItems()) do
        if item:getId() == itemID then
            itemCount = itemCount + item:getCount()
        end
        end
    end
    return itemCount
    end

    -- Função para exibir a quantidade do item
    function displayItemCount(itemID)
    local count = countItemInInventory(itemID)
    print("Quantidade do item:", count)
    end

    -- Chame a função para exibir a quantidade do item
    displayItemCount(itemID)
