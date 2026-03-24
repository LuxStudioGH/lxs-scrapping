local QBCore = exports['qb-core']:GetCoreObject()
playerCooldowns = {}
activeSessions = {} 

function GetRandomLocations()
    local locations = {}
    local tempLocs = {}
    for k, v in ipairs(Config.VehicleLocs) do tempLocs[k] = v end
    
    for i = 1, 3 do
        if #tempLocs > 0 then
            local index = math.random(1, #tempLocs)
            table.insert(locations, tempLocs[index])
            table.remove(tempLocs, index)
        end
    end
    return locations
end