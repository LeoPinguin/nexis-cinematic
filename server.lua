-- Vérification des permissions via ACE (Native FiveM)
local function isAdmin(source)
    -- L'ACE 'cinematique.admin' est défini dans le config.lua
    if IsPlayerAceAllowed(source, Config.AdminAce) then
        return true
    end
    return false
end

RegisterNetEvent('cinematique:requestPlay')
AddEventHandler('cinematique:requestPlay', function(mode, targetData, videoId, volume)
    local source = source
    if not isAdmin(source) then 
        print(_L('log_unauthorized') .. source)
        return 
    end

    if mode == 'all' then
        TriggerClientEvent('cinematique:playClient', -1, videoId, volume)
        
    elseif mode == 'id' then
        local targetId = tonumber(targetData)
        if targetId and GetPlayerPing(targetId) > 0 then
            TriggerClientEvent('cinematique:playClient', targetId, videoId, volume)
        end

    elseif mode == 'radius' then
        local radius = tonumber(targetData)
        local adminPed = GetPlayerPed(source)
        local adminCoords = GetEntityCoords(adminPed)
        
        for _, playerId in ipairs(GetPlayers()) do
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            -- Distance check
            if #(adminCoords - targetCoords) <= radius then
                TriggerClientEvent('cinematique:playClient', playerId, videoId, volume)
            end
        end
    end
end)

RegisterNetEvent('cinematique:requestStop')
AddEventHandler('cinematique:requestStop', function()
    local source = source
    if not isAdmin(source) then return end
    TriggerClientEvent('cinematique:stopClient', -1)
    print(_L('log_emergency') .. source)
end)