local configFile = GetResourcePath(GetCurrentResourceName()) .. '/config.json'

-- خواندن فایل تنظیمات
local function loadConfig()
    local file = LoadResourceFile(GetCurrentResourceName(), 'config.json')
    return json.decode(file) or {elevators = {}}
end

-- ذخیره فایل تنظیمات
local function saveConfig(data)
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(data, {indent = true}), -1)
end

-- کامند برای اضافه کردن طبقه جدید در بازی (مثلا: /addfloor elevator_name floor_name)
RegisterCommand('addfloor', function(source, args)
    local xPlayer = source -- در صورت نیاز از ox_core یا esx استفاده کنید
    
    -- بررسی سطح دسترسی (ادمین)
    if IsPlayerAceAllowed(source, 'command.addfloor') then
        local elevatorName = args[1]
        local floorName = args[2]
        
        if not elevatorName or not floorName then return end

        local data = loadConfig()
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        if not data.elevators[elevatorName] then
            data.elevators[elevatorName] = {floors = {}}
        end

        data.elevators[elevatorName].floors[floorName] = {x = coords.x, y = coords.y, z = coords.z}
        saveConfig(data)
        
        TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'طبقه ' .. floorName .. ' اضافه شد.'})
    end
end, false)
