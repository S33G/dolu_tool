RESOURCE_NAME = GetCurrentResourceName()

Shared = {}

if not GetResourceState('ox_lib'):find('start') then
    print('^1ox_lib should be started before this resource^0', 2)
end

if GetResourceState('ox_inventory'):find('start') then
    Shared.ox_inventory = true
end

lib.locale()

CreateThread(function()    
    if IsDuplicityVersion() then
        Server = {}
    else
        Client = {
            noClip = false,
            isMenuOpen = false,
            currentTab = 'home',
            lastLocation = json.decode(GetResourceKvpString('dolu_tool:lastLocation')),
            portalPoly = false,
            portalLines = false,
            portalCorners = false,
            portalInfos = false,
            interiorId = GetInteriorFromEntity(cache.ped),
            spawnedEntities = {},
            freezeTime = false,
            freezeWeather = false,
            data = {}
        }

        -- Get data from shared/data json files
        lib.callback('dolu_tool:getData', false, function(data)
            Client.data = data
        end)

        CreateThread(function()
            FUNC.setMenuPlayerCoords()
            while true do
                Wait(100)
                Client.interiorId = GetInteriorFromEntity(cache.ped)
            end
        end)
        
        if Config.target and GetResourceState('ox_target'):find('start') then
            FUNC.initTarget()
        end

        RegisterNUICallback('loadLocale', function(_, cb)
            cb(1)
            local resource = GetCurrentResourceName()
            local locale = GetConvar('ox:locale', 'en')
            local JSON = LoadResourceFile(resource, ('locales/%s.json'):format(locale)) or LoadResourceFile(resource, ('locales/en.json'):format(locale))
            SendNUIMessage({
                action = 'setLocale',
                data = json.decode(JSON)
            })
        end)
    end
end)

