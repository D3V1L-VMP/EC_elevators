local elevators = {} -- اینجا تنظیمات از فایل لود می‌شود

-- تابع برای لود کردن کانفیگ از فایل
local function loadElevators()
    local data = LoadResourceFile(GetCurrentResourceName(), 'config.json')
    elevators = json.decode(data).elevators
end

loadElevators()

for name, data in pairs(elevators) do
    for floorName, coords in pairs(data.floors) do
        -- ایجاد زون برای هر طبقه
        local zone = lib.zones.box({
            coords = vec3(coords.x, coords.y, coords.z),
            size = vec3(2, 2, 3),
            rotation = 0,
            debug = false,
            onEnter = function()
                lib.showTextUI('[E] برای استفاده از آسانسور')
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then -- کلید E
                    local options = {}
                    for fName, fCoords in pairs(data.floors) do
                        table.insert(options, {
                            title = fName,
                            onSelect = function()
                                DoScreenFadeOut(500)
                                Wait(500)
                                SetEntityCoords(cache.ped, fCoords.x, fCoords.y, fCoords.z)
                                Wait(500)
                                DoScreenFadeIn(500)
                            end
                        })
                    end
                    
                    lib.registerContext({
                        id = 'elevator_menu',
                        title = 'پنل آسانسور',
                        options = options
                    })
                    lib.showContext('elevator_menu')
                end
            end
        })
    end
end
