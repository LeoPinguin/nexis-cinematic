local hudHidden = false
local pedInVeh = false
local cruiseIsOn = false
local seatbeltIsOn = false
local isCinematicRunning = false -- NOUVELLE VARIABLE POUR LA CINÉMATIQUE

-- Commande pour basculer le HUD
RegisterCommand('togglehud', function()
    -- On empêche le joueur de réactiver son HUD pendant un film
    if isCinematicRunning then return end 

    hudHidden = not hudHidden
    
    if hudHidden then
        SendNUIMessage({hideHud = true})
        DisplayRadar(false)
        lib.notify({
            title = 'HUD désactivé',
            type = 'inform',
            position = 'top'
        })
    else
        SendNUIMessage({hideHud = false})
        -- On réaffiche la map seulement si le joueur n'est pas à pied
        if pedInVeh then 
            DisplayRadar(true) 
        end
        lib.notify({
            title = 'HUD activé',
            type = 'inform',
            position = 'top'
        })
    end
end)

-- Thread principal de gestion du HUD
Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)

        -- 1. GESTION DE LA VISIBILITÉ (Ajout de isCinematicRunning ici)
        if hudHidden or isCinematicRunning or IsPauseMenuActive() then
            SendNUIMessage({hideHud = true})
            DisplayRadar(false)
        else
            -- 2. AFFICHAGE STANDARD
            SendNUIMessage({hideHud = false})

            if IsPedInAnyVehicle(player, false) then
                if not pedInVeh then
                    pedInVeh = true
                    
                    Citizen.CreateThread(function()
                        Citizen.Wait(1500)
                        -- On s'assure que la map ne s'affiche pas si le HUD ou la cinématique est actif
                        if pedInVeh and not hudHidden and not isCinematicRunning then
                            DisplayRadar(true)
                        end
                    end)
                end
                
                local motor = GetIsVehicleEngineRunning(vehicle)
                local vehicleClass = GetVehicleClass(vehicle)
                
                if motor and vehicleClass ~= 13 then
                    SetPedConfigFlag(player, 32, true)

                    local fuel = 0
                    if Config.useLegacyFuel then
                        fuel = exports[Config.Fuelexport]:GetFuel(vehicle)
                    else
                        fuel = GetVehicleFuelLevel(vehicle)
                    end
                
                    SendNUIMessage({showVehiclePart = true, motor = motor, fuel = fuel})
                    
                    if vehicleClass == 8 then
                        SendNUIMessage({hideseat = true})
                    else
                        SendNUIMessage({hideseat = false})
                    end
                else
                    SendNUIMessage({showVehiclePart = true, motor = false, fuel = 0})
                end

            else
                -- 3. LOGIQUE QUAND ON EST À PIED
                if pedInVeh then
                    pedInVeh = false
                    cruiseIsOn = false
                    seatbeltIsOn = false
                    DisplayRadar(false)
                end

                local kimlik = GetPlayerServerId(NetworkGetEntityOwner(player))
                SendNUIMessage({
                    showVehiclePart = false, 
                    kimlik = kimlik,
                    seated = seatbeltIsOn, 
                    cruised = cruiseIsOn
                })
            end
        end

        Citizen.Wait(1000)
    end
end)

-- Commande pour ouvrir le menu
RegisterCommand('cinemenu', function()
    lib.registerContext({
        id = 'cine_main_menu',
        title = _L('menu_title'),
        options = {
            {
                title = _L('play_all'),
                description = _L('play_all_desc'),
                icon = 'users',
                onSelect = function()
                    local input = lib.inputDialog(_L('input_global_title'), {
                        {type = 'input', label = _L('label_yt_id'), required = true},
                        {type = 'slider', label = _L('label_volume'), default = 50, min = 0, max = 100}
                    })
                    if not input then return end
                    TriggerServerEvent('cinematique:requestPlay', 'all', nil, input[1], input[2])
                end
            },
            {
                title = _L('play_radius'),
                description = _L('play_radius_desc'),
                icon = 'circle-nodes',
                onSelect = function()
                    local input = lib.inputDialog(_L('input_zone_title'), {
                        {type = 'input', label = _L('label_yt_id'), required = true},
                        {type = 'number', label = _L('label_radius'), default = 20},
                        {type = 'slider', label = _L('label_volume'), default = 50, min = 0, max = 100}
                    })
                    if not input then return end
                    TriggerServerEvent('cinematique:requestPlay', 'radius', input[2], input[1], input[3])
                end
            },
            {
                title = _L('play_id'),
                description = _L('play_id_desc'),
                icon = 'user',
                onSelect = function()
                    local input = lib.inputDialog(_L('input_id_title'), {
                        {type = 'number', label = _L('label_player_id'), required = true},
                        {type = 'input', label = _L('label_yt_id'), required = true},
                        {type = 'slider', label = _L('label_volume'), default = 50, min = 0, max = 100}
                    })
                    if not input then return end
                    TriggerServerEvent('cinematique:requestPlay', 'id', input[1], input[2], input[3])
                end
            },
            {
                title = _L('preview'),
                description = _L('preview_desc'),
                icon = 'eye',
                onSelect = function()
                    local input = lib.inputDialog(_L('input_preview_title'), {
                        {type = 'input', label = _L('label_yt_id'), required = true},
                        {type = 'slider', label = _L('label_volume'), default = 50, min = 0, max = 100}
                    })
                    if not input then return end
                    SendNUIMessage({ type = "play", videoId = input[1], volume = input[2] })
                end
            },
            {
                title = _L('stop_all'),
                description = _L('stop_all_desc'),
                icon = 'ban',
                iconColor = 'red',
                onSelect = function()
                    TriggerServerEvent('cinematique:requestStop')
                end
            }
        }
    })
    lib.showContext('cine_main_menu')
end)

-- Événements de gestion de la vidéo
RegisterNetEvent('cinematique:playClient')
AddEventHandler('cinematique:playClient', function(videoId, volume)
    -- On prévient le HUD qu'une cinématique est en cours
    isCinematicRunning = true
    SendNUIMessage({hideHud = true})
    DisplayRadar(false)

    SendNUIMessage({
        type = "play",
        videoId = videoId,
        volume = volume
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent('cinematique:stopClient')
AddEventHandler('cinematique:stopClient', function()
    -- On coupe la vidéo et on informe le HUD que la cinématique est finie
    isCinematicRunning = false
    SendNUIMessage({ type = "stop" })
    -- Le HUD se réaffichera tout seul grâce à la boucle d'une seconde
end)

RegisterNUICallback('videoEnded', function(data, cb)
    -- Fin naturelle de la vidéo
    isCinematicRunning = false
    cb('ok')
end)

RegisterCommand('debugcine', function()
    SendNUIMessage({ type = "stop" })
    SetNuiFocus(false, false)
    
    -- On réinitialise la variable en cas de bug
    isCinematicRunning = false
    
    lib.notify({
        title = _L('notify_debug_title'),
        description = _L('notify_debug_desc'),
        type = 'success'
    })
end, false)