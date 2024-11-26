local ESX = exports["es_extended"]:getSharedObject()

lib.registerContext({
    id = 'tester_menu',
    title = 'Tester Menu',
    options = {
        {
            title = 'Add Item',
            icon = 'box',
            onSelect = function()
                local input = lib.inputDialog('Add Item', {'Item Name', 'Amount'})
                if not input then return end

                local itemName = input[1]
                local amount = tonumber(input[2]) or 1  

                TriggerServerEvent('tester_menu:addItem', itemName, amount)
            end
        },
        {
            title = 'Clear Inventory',
            icon = 'box-archive',
            onSelect = function()
                TriggerServerEvent('tester_menu:clearInventory')
            end
        },
        {
            title = 'Add Money',
            icon = 'wallet',
            onSelect = function()
                local input = lib.inputDialog('Add Money', {'Amount'})
                if not input then return end

                local amount = tonumber(input[1])
                if amount and amount > 0 then
                    TriggerServerEvent('tester_menu:addMoney', amount)
                else
                    lib.notify({
                        title = 'Invalid Amount',
                        description = 'Please enter a valid amount.',
                        type = 'error'
                    })
                end
            end
        },
        {
            title = 'Set Job',
            icon = 'building',
            onSelect = function()
                TriggerServerEvent('tester_menu:getJobs')
            end
        },
        {
            title = 'Spawn Car',
            icon = 'car',
            onSelect = function()
                local input = lib.inputDialog('Spawn Car', {'Car Model'})
                if not input then return end

                TriggerServerEvent('tester_menu:spawnCar', input[1])
            end
        },
        {
            title = 'Delete Car',
            icon = 'toolbox',
            onSelect = function()
                TriggerServerEvent('tester_menu:deleteCar')
                lib.notify({
                    title = 'Delete Car',
                    description = 'Vehicles within a 2-meter radius have been deleted.',
                    type = 'success'
                })
            end
        },
    }
})

RegisterNetEvent('tester_menu:showJobs')
AddEventHandler('tester_menu:showJobs', function(jobs)
    local jobOptions = {}
    for _, job in ipairs(jobs) do
        table.insert(jobOptions, {
            title = job.name,
            description = 'Set your job to ' .. job.label,
            onSelect = function()
                TriggerServerEvent('tester_menu:setJob', job.name)
            end
        })
    end

    lib.registerContext({
        id = 'job_menu',
        title = 'Select a Job',
        options = jobOptions
    })

    lib.showContext('job_menu')
end)

RegisterNetEvent('tester_menu:spawnCar')
AddEventHandler('tester_menu:spawnCar', function(carModel)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicleHash = GetHashKey(carModel)

    if IsModelInCdimage(vehicleHash) and IsModelAVehicle(vehicleHash) then
        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(10)
        end

        local vehicle = CreateVehicle(vehicleHash, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        SetModelAsNoLongerNeeded(vehicleHash)
    else
        lib.notify({
            title = 'Spawn Error',
            description = 'Invalid vehicle model.',
            type = 'error'
        })
    end
end)

RegisterCommand('testermenu', function()
    lib.showContext('tester_menu')
end)