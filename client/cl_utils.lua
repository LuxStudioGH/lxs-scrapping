hasScrappingJob = false
currentScrappingJobLocations = {}
jobBlips = {}
lastJobGetTime = 0
isPlayerScrapping = false

-- Helper for waypoint jazz.. I'm fairly sure it does something still....
function WaypointHelper()
    local pCoords = GetEntityCoords(cache.ped or PlayerPedId())
    local closestIndex = nil
    local minDistance = 999999.0

    for k, v in pairs(currentScrappingJobLocations) do
        if v ~= nil then
            local dist = #(pCoords - v)
            if dist < minDistance then
                minDistance = dist
                closestIndex = k
            end
        end
    end

    if closestIndex and jobBlips[closestIndex] then
        ClearAllBlipRoutes()
        SetBlipRoute(jobBlips[closestIndex], true)
    end
end

-- Clear all jobs
function clearScrappingJobs()
    ClearAllBlipRoutes()
    for k, v in pairs(jobBlips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end
    jobBlips = {}
    currentScrappingJobLocations = {}
    hasScrappingJob = false
    isPlayerScrapping = false
end

-- Clears a specific job spot
function clearSpecificJob(coords)
    local _jobIndex = nil
    
    for k, v in pairs(currentScrappingJobLocations) do
        if v ~= nil and #(v - coords) < 5.0 then
            _jobIndex = k
            break
        end
    end

    if _jobIndex then
        if jobBlips[_jobIndex] then
            RemoveBlip(jobBlips[_jobIndex])
            jobBlips[_jobIndex] = nil 
        end
        
        currentScrappingJobLocations[_jobIndex] = nil 
    end

    local remainingJobs = 0
    for k, v in pairs(currentScrappingJobLocations) do
        if v ~= nil then remainingJobs = remainingJobs + 1 end
    end

    if remainingJobs == 0 then
        hasScrappingJob = false
        clearScrappingJobs()
    else
        WaypointHelper()
    end
    
    isPlayerScrapping = false
end

-- Can you actually scrap a vehicle?
-- TODO: Make an option for an item requirement? 🤔
function canScrapVehicle()
    if not hasScrappingJob or isPlayerScrapping then return false end
    local pCoords = GetEntityCoords(cache.ped or PlayerPedId())
    
    for k, v in pairs(currentScrappingJobLocations) do
        if v ~= nil and #(pCoords - v) <= 5.0 then 
            return true 
        end
    end
    return false
end