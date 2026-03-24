local QBCore = exports['qb-core']:GetCoreObject()

local function isItemValid(itemName) -- Does item exist in our config
    for _, item in ipairs(Config.ScrappingItems) do -- Scrapping items
        if item.item == itemName then return true end
    end
    for _, item in ipairs(Config.RareItems) do -- Rare "bonus" items
        if item.item == itemName then return true end
    end
    return false
end

RegisterNetEvent("lxs-scrapping:getJob", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local pCoords = GetEntityCoords(GetPlayerPed(src))
    if #(pCoords - Config.NPCLocs.MissionStart.coords.xyz) > 10.0 then return end

    local citizenid = Player.PlayerData.citizenid
    local currentTime = os.time()

    if playerCooldowns[citizenid] then
        local timePassed = currentTime - playerCooldowns[citizenid]
        if timePassed < Config.GetJobCooldown then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Hillbilly is Busy',
                description = ("Come back in %s seconds!"):format(Config.GetJobCooldown - timePassed),
                type = 'error'
            })
        end
    end

    local randomSpots = GetRandomLocations()
    playerCooldowns[citizenid] = currentTime
    activeSessions[citizenid] = randomSpots

    TriggerClientEvent("lxs-scrapping:receiveJob", src, {
        Positions = randomSpots,
        JobStartTime = currentTime
    })
end)

RegisterNetEvent("lxs-scrapping:finishScrapping", function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not coords then return end

    local citizenid = Player.PlayerData.citizenid
    local session = activeSessions[citizenid]

    if not session then 
        -- TODO: Add log here?
        return 
    end
    
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local isNearWreck = false

    for k, v in pairs(activeSessions[citizenid]) do
        if #(pCoords - v) < 10.0 then
            isNearWreck = true
            activeSessions[citizenid][k] = nil
            break
        end
    end

    if not isNearWreck then return end

        local function giveItem(itemName, itemAmount)
        if not isItemValid(itemName) then
            -- TODO: Add log here?
            return 
        end
        if exports.ox_inventory then
            local success = exports.ox_inventory:AddItem(src, itemName, itemAmount)
            
            if not success then
                exports.ox_inventory:CustomDrop("Salvaged Parts", {
                    {itemName, itemAmount}
                }, pCoords)

                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Inventory Full',
                    description = ('You dropped %s x%s on the ground.'):format(itemName, itemAmount),
                    type = 'error',
                    position = 'top'
                })
            end
        end
    end

    local rollCount = math.random(Config.MinimumItems, Config.MaximumItems)
    for i = 1, rollCount do
        local totalWeight = 0
        for _, v in ipairs(Config.ScrappingItems) do totalWeight = totalWeight + v.weight end

        local roll = math.random(1, totalWeight)
        local counter = 0

        for _, loot in ipairs(Config.ScrappingItems) do
            counter = counter + loot.weight
            if roll <= counter then
                giveItem(loot.item, math.random(loot.min, loot.max))
                break 
            end
        end
    end

    if Config.RareItemEnabled and math.random(1, 100) <= Config.RareItemChance then
        local rareWeight = 0
        for _, v in ipairs(Config.RareItems) do rareWeight = rareWeight + v.weight end

        local rareRoll = math.random(1, rareWeight)
        local rareCounter = 0

        for _, rareLoot in ipairs(Config.RareItems) do
            rareCounter = rareCounter + rareLoot.weight
            if rareRoll <= rareCounter then
                giveItem(rareLoot.item, math.random(rareLoot.min, rareLoot.max))
                break 
            end
        end
    end
end)