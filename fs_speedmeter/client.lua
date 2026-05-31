local ESX = exports["es_extended"]:getSharedObject()
local hunger, thirst = 100, 100 -- Standaard waarden

-- 1. LOOP OM STATUS OP TE HALEN (Eten & Drinken)
-- Dit doen we elke seconde, dat is rustiger voor de server
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = math.floor(status.val / 10000)
        end)
        
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = math.floor(status.val / 10000)
        end)
    end
end)

-- 2. MAIN HUD LOOP (Snelheid, Health, Fuel)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200) -- Snellere update voor de snelheidsmeter
        
        local ped = PlayerPedId()
        local playerExists = DoesEntityExist(ped)
        
        if playerExists then
            local health = (GetEntityHealth(ped) - 100)
            local inVehicle = IsPedInAnyVehicle(ped, false)

            -- Stuur Status Data (Altijd)
            SendNUIMessage({
                type = "updateStatus",
                health = health,
                hunger = hunger,
                thirst = thirst
            })

            -- Stuur Voertuig Data
            if inVehicle then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
                local fuel = GetVehicleFuelLevel(vehicle)
                local gear = GetVehicleCurrentGear(vehicle)

                -- Check voor achteruitrijden (R)
                if gear == 0 and speed > 0 then gear = "R" end
                if gear == 0 and speed == 0 then gear = "N" end

                SendNUIMessage({
                    type = "updateVehicle",
                    inVehicle = true,
                    speed = string.format("%03d", speed),
                    gear = gear,
                    fuel = fuel,
                    belt = false -- Als je een gordelscript hebt, koppel die hier
                })
            else
                -- Verberg voertuig HUD als je niet rijdt
                SendNUIMessage({
                    type = "updateVehicle",
                    inVehicle = false
                })
            end
        end
    end
end)