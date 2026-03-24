CreateThread(function()
    for name, data in pairs(Config.NPCLocs) do
        local isEnabled = (data.enabled == nil or data.enabled == true) 
        if isEnabled and data.blip and data.blip.enable then
            local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
            SetBlipSprite(blip, data.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, data.blip.scale)
            SetBlipColour(blip, data.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.blip.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent("lxs-scrapping:receiveJob", function(data)
    clearScrappingJobs()
    currentScrappingJobLocations = data.Positions
    lastJobGetTime = data.JobStartTime
    hasScrappingJob = true
    WaypointHelper()

    for _, v in pairs(currentScrappingJobLocations) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, Config.Blip.ShortRange)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Label)
        EndTextCommandSetBlipName(blip)
        table.insert(jobBlips, blip)
    end

    if Config.Blip.Route and jobBlips[1] then 
        SetBlipRoute(jobBlips[1], true) 
    end
    lib.notify({ title = 'Jobs Received', description = 'Drive to the closest car wreck!', type = 'success' })
end)

AddEventHandler("lxs-scrapping:getJob", function()
    if hasScrappingJob then return end
    TriggerServerEvent("lxs-scrapping:getJob", lastJobGetTime)
end)

AddEventHandler("lxs-scrapping:CancelJob", function()
    if not hasScrappingJob then return end
    clearScrappingJobs()
    lib.notify({ title = 'Job Cancelled', description = 'You abandoned the scrapping contracts.', type = 'error' })
end)

AddEventHandler("lxs-scrapping:tryScrapVehicle", function()
    if not canScrapVehicle() or IsPedInAnyVehicle(cache.ped or PlayerPedId()) then return end

    isPlayerScrapping = true
    exports["rpemotes"]:EmoteCommandStart("mechanic2")

    local skillCheckKeys = {'W', 'A', 'S', 'D'}
    local skillStages = {}
    for i=1, (Config.MinigameRequiredSuccesses or 3) do 
        table.insert(skillStages, {areaSize = 50, speedMultiplier = 0.8}) 
    end

    if lib.skillCheck(skillStages, skillCheckKeys) then
        local pCoords = GetEntityCoords(cache.ped or PlayerPedId())
        local targetJob = nil

        for _, v in pairs(currentScrappingJobLocations) do
            if #(v - pCoords) < 5.0 then 
                targetJob = v 
                break
            end
        end

        if targetJob then
            TriggerServerEvent("lxs-scrapping:finishScrapping", targetJob)
            clearSpecificJob(targetJob)
            exports["rpemotes"]:EmoteCancel()

        if math.random(1, 100) <= Config.NotifyChance then 
                local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z))
                TriggerServerEvent("lxs-scrapping:activateAlarm", pCoords, street)
                
                lib.notify({
                    title = 'Uncomfortable Feeling',
                    description = 'You feel eyes on you... maybe it\'s time to leave.',
                    type = 'warning',
                    position = 'top',
                    icon = 'eye',
                    duration = 5000
                })
            end
         end
        else
        isPlayerScrapping = false
        exports["rpemotes"]:EmoteCancel()
        lib.notify({ title = "Failed", description = "You messed up the scrap process!", type = "error" })
    end
end)

-- Many dispatch systems..
-- Only cd & ps are tested 🤞
RegisterNetEvent("lxs-scrapping:client:activateAlarm", function(coords)
    local data = Config.Dispatch["scrapping"]
    if not data then return end

    local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(s1)
    local message = data.message .. " on " .. street

    if Config.DispatchSystem == 'ps-dispatch' then
        exports["ps-dispatch"]:CustomAlert({
            coords = coords,
            message = message,
            dispatchCode = data.code,
            description = data.title,
            radius = 0,
            sprite = data.blip.sprite,
            color = data.blip.color,
            scale = data.blip.scale,
            length = 3
        })

    elseif Config.DispatchSystem == 'cd_dispatch' then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = data.jobs,
            coords = coords,
            title = data.code .. " - " .. data.title,
            message = message,
            flash = data.flash or 0,
            unique_id = tostring(math.random(111111, 999999)),
            sound = 1,
            blip = {
                sprite = data.blip.sprite,
                scale = data.blip.scale,
                colour = data.blip.color,
                flashes = data.blip.flashing,
                text = data.blip.text,
                time = 5,
                radius = 0,
            }
        })

    elseif Config.DispatchSystem == 'qs-dispatch' then
        exports['qs-dispatch']:getSSURL(function(image)
            TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
                job = data.jobs,
                callLocation = coords,
                callCode = { code = data.code, snippet = data.title },
                message = message,
                flashes = false,
                image = image or nil,
                blip = {
                    sprite = data.blip.sprite,
                    scale = data.blip.scale,
                    colour = data.blip.color,
                    flashes = false,
                    text = data.blip.text,
                    time = (30 * 1000),
                }
            })
        end)

    elseif Config.DispatchSystem == 'lb-tablet' then
        exports["lb-tablet"]:AddDispatch({
            priority = 'low',
            code = data.code,
            title = data.title,
            description = message,
            location = { label = 'Suspicious Activity', coords = coords },
            time = 300,
            job = 'police',
        })

    elseif Config.DispatchSystem == 'core_dispatch' then
        local gender = IsPedMale(PlayerPedId()) and 'male' or 'female'
        TriggerServerEvent('core_dispatch:addCall', data.code, data.title,
        {{icon = 'fa-venus-mars', info = gender}},
        {coords.x, coords.y, coords.z},
        'police', 30000, data.blip.sprite, data.blip.color, false)

    elseif Config.DispatchSystem == 'origen_police' then
        TriggerServerEvent("SendAlert:police", {
            coords = coords,
            title = data.code .. " - " .. data.title,
            type = 'GENERAL',
            message = message,
            job = 'police',
        })

    elseif Config.DispatchSystem == 'rcore_dispatch' then
        TriggerServerEvent('rcore_dispatch:server:sendAlert', {
            code = data.code .. " - " .. data.title,
            default_priority = 'low',
            coords = coords,
            job = data.jobs,
            text = message,
            type = 'alerts',
            blip_time = 30,
            blip = {
                sprite = data.blip.sprite,
                colour = data.blip.color,
                scale = data.blip.scale,
                text = data.blip.text,
                flashes = false,
                radius = 0,
            }
        })

    else
        lib.print.error('Dispatch system "' .. tostring(Config.DispatchSystem) .. '" not found.')
    end
end)
