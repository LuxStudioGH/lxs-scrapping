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
        GiveItem(src, itemName, itemAmount, pCoords)
    end

    local rollCount = math.random(Config.MinimumItems, Config.MaximumItems)
    for i = 1, rollCount do
        local totalchance = 0
        for _, v in ipairs(Config.ScrappingItems) do totalchance = totalchance + v.chance end

        local roll = math.random(1, totalchance)
        local counter = 0

        for _, loot in ipairs(Config.ScrappingItems) do
            counter = counter + loot.chance
            if roll <= counter then
                giveItem(loot.item, math.random(loot.min, loot.max))
                break 
            end
        end
    end

    if Config.RareItemEnabled and math.random(1, 100) <= Config.RareItemChance then
        local rarechance = 0
        for _, v in ipairs(Config.RareItems) do rarechance = rarechance + v.chance end

        local rareRoll = math.random(1, rarechance)
        local rareCounter = 0

        for _, rareLoot in ipairs(Config.RareItems) do
            rareCounter = rareCounter + rareLoot.chance
            if rareRoll <= rareCounter then
                giveItem(rareLoot.item, math.random(rareLoot.min, rareLoot.max))
                break 
            end
        end
    end
end)