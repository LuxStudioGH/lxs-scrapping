-- Only ox_inventory was tested, so here's hoping everything else works. 🙏🙏
-- PS: Feel free to PR any fixes/new support to this, It's greatly appreciated and I will love you <3
local InventorySystem = Config.InventorySystem

function GiveItem(source, itemName, itemAmount, coords, metadata)
    if InventorySystem == "ox" then 
        local success = exports.ox_inventory:AddItem(source, itemName, itemAmount, metadata)
        
        if not success and coords then
            exports.ox_inventory:CustomDrop("Salvaged Parts", {
                {itemName, itemAmount}
            }, coords)

            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Inventory Full',
                description = ('You dropped %s x%s on the ground.'):format(itemName, itemAmount),
                type = 'error',
                position = 'top'
            })
        end
        return success

    elseif InventorySystem == "qs" then
        return exports['qs-inventory']:AddItem(source, itemName, itemAmount, nil, metadata)

    elseif InventorySystem == "qb" or InventorySystem == "ps" then
        local Player = exports['qb-core']:GetPlayer(source)
        if Player then
            return Player.Functions.AddItem(itemName, itemAmount, false, metadata)
        end
    
    elseif InventorySystem == "custom" then
        -- Add your logic here
        return false
    end

    return false
end

function RemoveItem(source, itemName, itemAmount, metadata)
    if InventorySystem == "ox" then
        return exports.ox_inventory:RemoveItem(source, itemName, itemAmount, metadata)

    elseif InventorySystem == "qs" then
        return exports['qs-inventory']:RemoveItem(source, itemName, itemAmount, nil, metadata)

    elseif InventorySystem == "qb" or InventorySystem == "ps" then
        local Player = exports['qb-core']:GetPlayer(source)
        if Player then
            return Player.Functions.RemoveItem(itemName, itemAmount)
        end

    elseif InventorySystem == "custom" then
        -- Add your logic here
        return false
    end

    return false
end

function GetItemCount(source, itemName)
    if InventorySystem == "ox" then
        return exports.ox_inventory:GetItemCount(source, itemName)
    elseif InventorySystem == "qs" then
        return exports['qs-inventory']:GetItemTotalAmount(source, itemName)
    elseif InventorySystem == "qb" or InventorySystem == "ps" then
        local Player = exports['qb-core']:GetPlayer(source)
        if Player then
            local item = Player.Functions.GetItemByName(itemName)
            return item and item.amount or 0
        end
    elseif InventorySystem == "custom" then
        -- Add your logic here
        return 0
    end
    return 0
end