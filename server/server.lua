local activePlayers = {}
local disconnectedPlayers = {}
QB = {}
QBCore = exports['qb-core']:GetCoreObject()

-- Initialize player list with currently connected players when resource starts
CreateThread(function()
    Wait(1000) -- Wait for QBCore to be ready
    local players = GetPlayers()
    for _, playerIdStr in ipairs(players) do
        local src = tonumber(playerIdStr)
        local steamName, playerId, playerIdentifier = GetPlayerInfo(src)
        local playerInfo = {id = playerId, name = steamName, identifier = playerIdentifier}
        table.insert(activePlayers, playerInfo)
    end
end)

AddEventHandler('playerConnecting', function()
    local player = source 
    local steamName, playerId, playerIdentifier = GetPlayerInfo(player)
    local playerInfo = {id = playerId, name = steamName, identifier = playerIdentifier}
    table.insert(activePlayers, playerInfo)
    UpdateAllClients()
end)

AddEventHandler('playerDropped', function(reason)
    local player = source 
    local steamName, playerId, playerIdentifier = GetPlayerInfo(player)
    local playerInfo = {id = playerId, name = steamName, identifier = playerIdentifier}
    table.insert(disconnectedPlayers, playerInfo)
    
    -- Remove player from activePlayers by finding the correct index
    local index = tableIndex(activePlayers, playerId)
    if index then
        table.remove(activePlayers, index)
    end
    
    UpdateAllClients()
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

function tableIndex(tbl, playerId)
    for i, v in ipairs(tbl) do
        if v.id == playerId then
            return i
        end
    end
    return nil
end

function UpdateAllClients()
    -- Update all clients with the current player list
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        if permission(src) then
            TriggerClientEvent('qb-playerlist:client:manualUpdate', src, activePlayers, disconnectedPlayers)
        end
    end
end
