local ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('tester_menu:addItem')
AddEventHandler('tester_menu:addItem', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if ESX.Items[itemName] then
            xPlayer.addInventoryItem(itemName, amount or 1)
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Item Error',
                description = 'This item does not exist.',
                type = 'error'
            })
        end
    end
end)

RegisterServerEvent('tester_menu:addMoney')
AddEventHandler('tester_menu:addMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addAccountMoney('money', amount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Money Added',
            description = 'You have received $' .. amount,
            type = 'success'
        })
    end
end)

RegisterServerEvent('tester_menu:getJobs')
AddEventHandler('tester_menu:getJobs', function()
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
        TriggerClientEvent('tester_menu:showJobs', src, jobs)
    end)
end)

RegisterServerEvent('tester_menu:setJob')
AddEventHandler('tester_menu:setJob', function(jobName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.setJob(jobName, 0)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Job Updated',
            description = 'Your job has been set to ' .. jobName,
            type = 'success'
        })
    end
end)

RegisterServerEvent('tester_menu:spawnCar')
AddEventHandler('tester_menu:spawnCar', function(carModel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        TriggerClientEvent('tester_menu:spawnCar', src, carModel)
    end
end)

RegisterServerEvent('tester_menu:deleteCar')
AddEventHandler('tester_menu:deleteCar', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(xPlayer.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if DoesEntityExist(pedVehicle) then
        DeleteEntity(pedVehicle)
    end

    local coords = GetEntityCoords(ped)
    local Vehicles = ESX.OneSync.GetVehiclesInArea(coords, 2.0) 
    for i = 1, #Vehicles do
        local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
        if DoesEntityExist(Vehicle) then
            DeleteEntity(Vehicle)
        end
    end
end)

RegisterServerEvent('tester_menu:clearInventory')
AddEventHandler('tester_menu:clearInventory', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local inventory = xPlayer.inventory
        for _, item in ipairs(inventory) do
            if item.count > 0 then
                xPlayer.removeInventoryItem(item.name, item.count)
            end
        end
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Inventory Cleared',
            description = 'Your inventory has been cleared.',
            type = 'success'
        })
    end
end)

