local playerList = {}
local disconnectedPlayers = {}
QB = {}

RegisterCommand("list",function()
    TriggerEvent('qb-playerlist:client:manualUpdate')
    Wait(500)
    if playerList then 
        SendNUIMessage({
            type = "OPEN",
            data = {
                activePlayers = playerList,
                disconnectedPlayers = disconnectedPlayers
            }
        })
        SetNuiFocus(1,1)
        print(json.encode(playerList))
    end
end)


RegisterNetEvent('qb-playerlist:client:manualUpdate')
AddEventHandler('qb-playerlist:client:manualUpdate', function(activePlayers,disPlayers)
    TriggerServerEvent('qb-playerlist:server:manualUpdate')
    playerList = activePlayers
    disconnectedPlayers = disPlayers
end)

RegisterNUICallback("getData", function(data,cb)
    if data.variable == "online" then
        cb(playerList)
    else
        cb(disconnectedPlayers)
    end
end)


RegisterNUICallback("close",function()
    SetNuiFocus(0,0)
end)
