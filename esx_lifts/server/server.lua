ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("esx_lifts:teleportPeopleS")
AddEventHandler("esx_lifts:teleportPeopleS", function(players, coords)   
    for i = 1, #players, 1 do
        TriggerClientEvent("esx_lifts:teleportPeopleC", players[i][1], coords)
    end 
end)