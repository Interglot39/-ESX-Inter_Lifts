ESX = nil

--  ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)




-- Checking how close you are
Citizen.CreateThread(function()
    local time = 2000
    local inZone = false
	while true do
        Citizen.Wait(time)
        for k,v in pairs(Config.Lifts) do            
            for _, floors in pairs(v) do
                local pId = PlayerPedId()
                local pIdCoords = GetEntityCoords(pId)
                local distance = #(floors.coords - pIdCoords)
                if distance < 4 then
                    inZone = true
                    while inZone do
                        time = 7
                        Citizen.Wait(time)      
                        pId = PlayerPedId()
                        pIdCoords = GetEntityCoords(pId)
                        distance = #(floors.coords - pIdCoords)        
                        inZone = true
                        ESX.ShowHelpNotification("Press [~g~E~w~] to use the lift")
                        if distance < 2 and IsControlPressed(0, 38) then
                            liftMenu(v, k)                            
                        elseif distance > 5 then
                            inZone = false
                            time = 2000
                        end                      
                    end
                else
                    inZone = false
                    time = 2000
                end               
            end
        end
	end
end)

RegisterNetEvent("esx_lifts:teleportPeopleC")
AddEventHandler("esx_lifts:teleportPeopleC", function(coords)
    teleport(coords)
end)

function liftMenu(coords, name)
    local elements = {}
    for k,v in pairs(coords) do
        table.insert(elements,{label = v.text, value = v.coords})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), "ESX-Lifts",
        {
            title  = name,
            align    = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local destination = vector3(data.current.value.x, data.current.value.y, data.current.value.z)
            local distance = #(destination - GetEntityCoords(PlayerPedId()))
            if distance > 3 then
                local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3)
                local datos = {}
                for i = 1, #players, 1 do
                    table.insert(datos,{GetPlayerServerId(players[i])})
                    TriggerServerEvent("esx_lifts:teleportPeopleS", datos, data.current.value)
                end
            else
                ESX.ShowNotification("~r~Select a diferent floor.")
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function teleport(coords)
    DoScreenFadeOut(1500)
    Citizen.Wait(1500)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
    Citizen.Wait(1500)
    DoScreenFadeIn(1000)
end

