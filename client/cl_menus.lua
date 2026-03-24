AddEventHandler("lxs-scrapping:tryOpenSellMenu", function()
    TriggerServerEvent("lxs-scrapping:openSellMenu")
end)

AddEventHandler("lxs-scrapping:tryOpenExchangeMenu", function()
    TriggerServerEvent("lxs-scrapping:openExchangeMenu")
end)

RegisterNetEvent("lxs-scrapping:openSellMenu", function(items)
    local options = {}
    local grandTotal = 0

    for _, v in pairs(items) do
        grandTotal = grandTotal + (v.price * v.count)
    end

    if #items > 1 then
        table.insert(options, {
            label = "Sell All",
            icon = "fa-solid fa-hand-holding-dollar",
            description = ("Total Earnings: $%s"):format(grandTotal),
            args = { type = "all", items = items }
        })
    end

    for _, v in pairs(items) do
        local values = {}
        for i = 1, v.count do table.insert(values, "Sell " .. i) end
        
        local stackValue = v.price * v.count

        table.insert(options, {
            label = v.label,
            description = ("$%s each | Stack Value: $%s"):format(v.price, stackValue), 
            args = { type = "single", data = v },
            values = values
        })
    end

    if #options == 0 then
        return lib.notify({ title = 'No Items', description = 'You have no vehicle parts to sell!', type = 'warning' })
    end

    lib.registerMenu({
        id = 'sell',
        title = 'Shady Bob',
        position = 'bottom-right',
        options = options,
    }, function(selected, scrollIndex, args)
        if args.type == "all" then
            TriggerServerEvent("lxs-scrapping:sellAllParts")
        else
            args.data.trySellCount = scrollIndex
            TriggerServerEvent("lxs-scrapping:sellVehiclePart", args.data)
        end
    end)
    lib.showMenu('sell')
end)

RegisterNetEvent("lxs-scrapping:openExchangeMenu", function(items)
    local options = {}

    if #items > 1 then
        table.insert(options, {
            label = "Exchange All",
            icon = "fa-solid fa-recycle",
            description = "Scrap everything in your pockets for materials",
            args = { type = "all", items = items }
        })
    end

    for _, v in pairs(items) do
        local values = {}
        for i = 1, v.count do table.insert(values, "Scrap " .. i) end
        
        table.insert(options, {
            label = v.label,
            icon = "fa-solid fa-gears",
            description = ("Scrap for materials"), 
            args = { type = "single", data = v },
            values = values
        })
    end

    if #options == 0 then
        return lib.notify({ title = 'Nothing to Scrap', description = 'You have no vehicle parts to exchange!', type = 'warning' })
    end

    lib.registerMenu({
        id = 'exchange_menu',
        title = 'Scrap Yard Exchange',
        position = 'bottom-right',
        options = options,
    }, function(selected, scrollIndex, args)
        if args.type == "all" then
            TriggerServerEvent("lxs-scrapping:exchangeAllParts")
        else
            args.data.amount = scrollIndex
            TriggerServerEvent("lxs-scrapping:exchangePart", args.data)
        end
    end)
    lib.showMenu('exchange_menu')
end)