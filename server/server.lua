local activePlayers = {}
local disconnectedPlayers = {}
QB = {}
QBCore = exports['qb-core']:GetCoreObject()


AddEventHandler('playerConnecting', function()
    local player = source 
    local steamName, playerId, playerIdentifier = GetPlayerInfo(player)
    local playerInfo = {id = playerId, name = steamName, identifier = playerIdentifier}
    table.insert(activePlayers, playerInfo)
end)

AddEventHandler('playerDropped', function(reason)
    local player = source 
    local steamName, playerId, playerIdentifier = GetPlayerInfo(player)
    local playerInfo = {id = playerId, name = steamName, identifier = playerIdentifier}
    table.insert(disconnectedPlayers, playerInfo)
    table.remove(activePlayers, tableIndex(activePlayers, player)) 
end)


RegisterNetEvent('qb-playerlist:server:manualUpdate')
AddEventHandler('qb-playerlist:server:manualUpdate', function()
    local src = source
    if permission(src) then
        TriggerClientEvent('qb-playerlist:client:manualUpdate', src, activePlayers,disconnectedPlayers)
    else
        --print("yetkin yok")
    end
end)

function GetPlayerInfo(player)
    local steamName = GetPlayerName(player) 
    local playerId = player 
    local playerIdentifier = GetPlayerIdentifier(player, 0)

    return steamName, playerId, playerIdentifier
end

function permission(source)
    if QB.Admin["control"] then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local perms = xPlayer.Functions.GetPermission()
        for k, v in ipairs(QB.Admin["perms"]) do
            if perms == v then
                return true
            end
        end
        return false
    else
        return true
    end
end

function tableIndex(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end
