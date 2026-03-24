-- Prevents users from spam starting/stopping jobs for better locations
Config.GetJobCooldown = 180 -- Default: 5 Minutes
-- Set this between 0 and 100 (e.g., 5 = 5% chance)
Config.NotifyChance = 5
-- Amount of turns of the minigame until completation
Config.MinigameRequiredSuccesses = 3 -- Default: 3 
-- Minimum amount of vehicle parts you can gain
Config.MinimumItems = 2 -- Default: 2
-- Maximum amount of vehicle parts you can gain
Config.MaximumItems = 3 -- Default: 3
-- Dispatch system to use
Config.DispatchSystem = "ps-dispatch" -- Default: ps-dispatch
-- Dispatch set up
Config.Dispatch = {
    ["scrapping"] = {
        code = '10-31',
        title = 'Suspicious Activity', 
        message = 'A witness reported suspicious activity', 
        jobs = {'police'}, 
        flash = 0,
        blip = {
            sprite = 66,      
            scale = 1.0, 
            color = 5,       
            flashing = false, 
            text = '10-31 | Reported Suspicious Activity', 
        }
    }
}
-- Vehicle Blip Config
Config.Blip = {
    Sprite = 402, -- Change the blip sprite (https://docs.fivem.net/docs/game-references/blips/)
    Color = 3, -- Change the colour (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
    Scale = 0.8, -- Change the scale (Do I have to put a link here?)
    ShortRange = false, -- Make blip only appear when nearby 
    Label = "Vehicle Scrap", -- Vehicle label displayed on blip
    Route = true -- Whether or not a mission line should be drawn to the blip
}

Config.InteractableModels = {
    "prop_rub_carwreck_10",
    "prop_rub_carwreck_11",
    "prop_rub_carwreck_12",
    "prop_rub_carwreck_13",
    "prop_rub_carwreck_14",
    "prop_rub_carwreck_15",
    "prop_rub_carwreck_16",
    "prop_rub_carwreck_17",
    "prop_rub_carwreck_2",
    "prop_rub_carwreck_3",
    "prop_rub_carwreck_5",
    "prop_rub_carwreck_7",
    "prop_rub_carwreck_8",
    "prop_rub_carwreck_9"
}

-- Items alongside main ScrappingItems
Config.RareItemEnabled = true -- Use rare items (bonus items), Default: True 
Config.RareItemChance = 5 -- 5% chance to give rare items
Config.RareItems = {
    { item = "electronickit", min = 1, max = 1, weight = 5 },
    { item = "fakeplate", min = 1, max = 2, weight = 1 },
    { item = "metalscrap", min = 28, max = 32, weight = 50 },
    { item = "metalscrap", min = 12, max = 33, weight = 50 },
}

-- Main item pool
Config.ScrappingItems = { -- Reward accepts "money", anything else is treated as an item. (E.G: black_money)
    { item = "tyre",          price = 400,  reward = "money",        weight = 80, min = 1, max = 4 }, 
    { item = "brakes",        price = 400,  reward = "money",        weight = 70, min = 1, max = 4 }, 
    { item = "headlights",    price = 500,  reward = "black_money",  weight = 60, min = 1, max = 2 },
    { item = "battery",       price = 500,  reward = "black_money",  weight = 60, min = 1, max = 1 },
    { item = "windscreen",    price = 600,  reward = "black_money",  weight = 50, min = 1, max = 1 },
    { item = "radiator",      price = 600,  reward = "black_money",  weight = 45, min = 1, max = 1 },
    { item = "alternator",    price = 700,  reward = "black_money",  weight = 40, min = 1, max = 1 },
    { item = "steeringwheel", price = 600,  reward = "black_money",  weight = 35, min = 1, max = 1 },
    { item = "fueltank",      price = 800,  reward = "black_money",  weight = 30, min = 1, max = 1 },
    { item = "foglights",     price = 400,  reward = "black_money",  weight = 30, min = 1, max = 2 }, 
    { item = "suspension",    price = 1200, reward = "black_money",  weight = 25, min = 1, max = 2 },
    { item = "transmission",  price = 3000, reward = "black_money",  weight = 15, min = 1, max = 1 },
    { item = "engine",        price = 5500, reward = "black_money",  weight = 8,  min = 1, max = 1 }, 
}

-- Exchanger rewards
Config.ExchangeRewards = {
    ["alternator"] = { 
        returnItems = {
            { item = "metalscrap", chance = 100, min = 12, max = 24 },
            { item = "copperwire", chance = 40, min = 5, max = 10 },
        },
        rareItemsExchange = { item = "electronickit", chance = 5, amount = 1 } 
    },
    ["battery"] = { 
        returnItems = {
            { item = "copperwire", chance = 100, min = 5, max = 10 },
            { item = "plastic",    chance = 50, min = 3, max = 6 },
        },
        rareItemsExchange = { item = "electronickit", chance = 10, amount = 1 }
    },
    ["brakes"] = { 
        returnItems = {
            { item = "steel",      chance = 100, min = 5, max = 10 },
            { item = "metalscrap", chance = 30, min = 3, max = 6 },
        },
        rareItemsExchange = { item = "electronickit", chance = 1, amount = 1 }
    },
    ["engine"] = { 
        returnItems = {
            { item = "metalscrap", chance = 100, min = 45, max = 60 },
            { item = "steel",      chance = 70, min = 12, max = 24 },
            { item = "aluminum",   chance = 40,  min = 7,  max = 14 },
        },
        rareItemsExchange = { item = "electronickit", chance = 15, amount = 1 }
    },
    ["foglights"] = { 
        returnItems = {
            { item = "glass",      chance = 100, min = 2, max = 4 },
            { item = "plastic",    chance = 80, min = 6, max = 12 },
        },
        rareItemsExchange = nil
    },
    ["fueltank"] = { 
        returnItems = {
            { item = "plastic",   chance = 100, min = 12, max = 24 },
            { item = "aluminum",   chance = 80, min = 8, max = 16 },
            { item = "steel",      chance = 50, min = 4, max = 8 },
        },
        rareItemsExchange = { item = "electronickit", chance = 2, amount = 1 }
    },
    ["headlights"] = { 
        returnItems = {
            { item = "glass",      chance = 80, min = 3, max = 6 },
            { item = "plastic",    chance = 40, min = 2, max = 4 },
        },
        rareItemsExchange = nil 
    },
    ["radiator"] = { 
        returnItems = {
            { item = "copperwire", chance = 100, min = 7, max = 14 },
            { item = "aluminum",   chance = 45, min = 6, max = 12 },
        },
        rareItemsExchange = { item = "electronickit", chance = 3, amount = 1 }
    },
    ["steeringwheel"] = { 
        returnItems = {
            { item = "plastic",    chance = 100, min = 8, max = 16 },
            { item = "metalscrap", chance = 70, min = 4, max = 8 },
            { item = "rubber",     chance = 60, min = 2, max = 4 },
        },
        rareItemsExchange = nil 
    },
    ["suspension"] = { 
        returnItems = {
            { item = "metalscrap", chance = 100, min = 12, max = 24 },
            { item = "rubber",     chance = 50, min = 4, max = 8 },
            { item = "steel",      chance = 70, min = 4, max = 8 },
        },
        rareItemsExchange = nil 
    },
    ["transmission"] = { 
        returnItems = {
            { item = "metalscrap", chance = 100, min = 20, max = 30 },
            { item = "plastic",    chance = 100, min = 12, max = 24 },
            { item = "aluminum",   chance = 90, min = 6, max = 12 },
            { item = "steel",      chance = 50, min = 6, max = 12 },
        },
        rareItemsExchange = { item = "electronickit", chance = 8, amount = 1 }
    },
    ["windscreen"] = { 
        returnItems = {
            { item = "glass",      chance = 100, min = 5, max = 10 },
            { item = "plastic",    chance = 60, min = 4, max = 8 },
        },
        rareItemsExchange = nil 
    },
    ["tyre"] = { 
        returnItems = {
            { item = "rubber",     chance = 100, min = 6, max = 12 },
            { item = "steel",      chance = 20,  min = 2, max = 4 },
        },
        rareItemsExchange = nil 
    }
}
