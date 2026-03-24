local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("lxs-scrapping:openSellMenu", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local pCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pCoords - Config.NPCLocs.Seller.coords.xyz) > 10.0 then return end

    local sellableItems = {}
    for _, data in ipairs(Config.ScrappingItems) do
        local item = exports.ox_inventory:GetItem(src, data.item, nil, false)
        local count = item and item.count or 0

        if count > 0 then
            table.insert(sellableItems, {
                label = data.item:gsub("^%l", string.upper),
                name = data.item,
                count = count,
                price = data.price 
            })
        end
    end
    TriggerClientEvent("lxs-scrapping:openSellMenu", src, sellableItems)
end)

RegisterNetEvent("lxs-scrapping:sellVehiclePart", function(args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not args then return end

    local pCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pCoords - Config.NPCLocs.Seller.coords.xyz) > 10.0 then return end

    local itemData = nil
    for _, v in ipairs(Config.ScrappingItems) do
        if v.item == args.name then 
            itemData = v
            break 
        end
    end

    if itemData then
        local countToSell = tonumber(args.trySellCount) or 0
        
        if countToSell > 0 and exports.ox_inventory:RemoveItem(src, args.name, countToSell) then
            local payoutAmount = math.floor(itemData.price * countToSell)

            if itemData.reward == "money" then
                Player.Functions.AddMoney('cash', payoutAmount, "scrapping-sell")
            else
                exports.ox_inventory:AddItem(src, itemData.reward, payoutAmount)
            end
            
            TriggerEvent("lxs-scrapping:openSellMenu", src) 
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'Missing items!', type = 'error' })
        end
    end
end)

RegisterNetEvent("lxs-scrapping:sellAllParts", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemsRemoved = false

    for _, data in ipairs(Config.ScrappingItems) do
        local count = exports.ox_inventory:GetItemCount(src, data.item)
        
        if count > 0 then
            if exports.ox_inventory:RemoveItem(src, data.item, count) then
                local totalValue = (data.price * count)
                
                if data.reward == "money" then
                    Player.Functions.AddMoney('cash', totalValue, "scrapping-sell-all")
                else
                    exports.ox_inventory:AddItem(src, data.reward, totalValue)
                end
                itemsRemoved = true
            end
        end
    end

    if itemsRemoved then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Shady Bob', description = 'Pleasure doin\' business.', type = 'success' })
        TriggerEvent("lxs-scrapping:openSellMenu", src) 
    end
end)

RegisterNetEvent("lxs-scrapping:openExchangeMenu", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local pCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pCoords - Config.NPCLocs.Exchanger.coords.xyz) > 10.0 then return end

    local exchangeableItems = {}
    for _, data in ipairs(Config.ScrappingItems) do
        local count = exports.ox_inventory:GetItemCount(src, data.item)

        if count > 0 then
            table.insert(exchangeableItems, {
                label = data.item:gsub("^%l", string.upper),
                name = data.item,
                count = count
            })
        end
    end
    TriggerClientEvent("lxs-scrapping:openExchangeMenu", src, exchangeableItems)
end)

RegisterNetEvent("lxs-scrapping:exchangePart", function(args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not args then return end

    local pCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pCoords - Config.NPCLocs.Exchanger.coords.xyz) > 10.0 then return end

    local rewardData = Config.ExchangeRewards[args.name]
    local countToExchange = tonumber(args.amount) or 0

    if rewardData and countToExchange > 0 then
        if exports.ox_inventory:RemoveItem(src, args.name, countToExchange) then
            
            for i = 1, countToExchange do
                for _, reward in ipairs(rewardData.returnItems) do
                    if math.random(1, 100) <= reward.chance then
                        local amount = math.random(reward.min, reward.max)
                        exports.ox_inventory:AddItem(src, reward.item, amount)
                    end
                end

                if rewardData.rareItemsExchange then
                    if math.random(1, 100) <= rewardData.rareItemsExchange.chance then
                        exports.ox_inventory:AddItem(src, rewardData.rareItemsExchange.item, rewardData.rareItemsExchange.amount)
                    end
                end
            end

            TriggerClientEvent('ox_lib:notify', src, { title = 'Scrap Yard', description = 'Parts scrapped into materials.', type = 'success' })
            TriggerEvent("lxs-scrapping:openExchangeMenu", src) 
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'Item mismatch.', type = 'error' })
        end
    end
end)

RegisterNetEvent("lxs-scrapping:exchangeAllParts", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemsExchanged = false

    for _, data in ipairs(Config.ScrappingItems) do
        local count = exports.ox_inventory:GetItemCount(src, data.item)
        local rewardData = Config.ExchangeRewards[data.item]
        
        if count > 0 and rewardData then
            if exports.ox_inventory:RemoveItem(src, data.item, count) then
                itemsExchanged = true
                for i = 1, count do
                    for _, reward in ipairs(rewardData.returnItems) do
                        if math.random(1, 100) <= reward.chance then
                            exports.ox_inventory:AddItem(src, reward.item, math.random(reward.min, reward.max))
                        end
                    end
                    if rewardData.rareItemsExchange and math.random(1, 100) <= rewardData.rareItemsExchange.chance then
                        exports.ox_inventory:AddItem(src, rewardData.rareItemsExchange.item, rewardData.rareItemsExchange.amount)
                    end
                end
            end
        end
    end

    if itemsExchanged then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Scrap Yard', description = 'All parts processed.', type = 'success' })
        TriggerEvent("lxs-scrapping:openExchangeMenu", src) 
    end
end)