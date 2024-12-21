local QBCore = exports['qb-core']:GetCoreObject()
local MetaDataName = Config.XP.MetaDataName
local NotifyType = Config.CoreSettings.Notify.Type
local InvType = Config.CoreSettings.Inventory.Type
local Levels = Config.XP.Levels


--notification function
local function SendNotify(src, msg, type, time, title)
    if NotifyType == nil then print("Lusty94_Peyote: NotifyType Not Set in Config.CoreSettings.Notify.Type!") return end
    if not title then title = "Peyote" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print("Notification Sent With No Message") return end
    if NotifyType == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, msg, type, time)
    elseif NotifyType == 'okok' then
        TriggerClientEvent('okokNotify:Alert', src, title, msg, time, type, Config.CoreSettings.Notify.Sound)
    elseif NotifyType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = type, text = msg, style = { ['background-color'] = '#00FF00', ['color'] = '#FFFFFF' } })
    elseif NotifyType == 'ox' then 
        TriggerClientEvent('ox_lib:notify', src, ({ title = title, description = msg, length = time, type = type, style = 'default'}))
    end
end


--remove items
local function removeItem(src, item, amount)
    if InvType == 'qb' then
        if exports['qb-inventory']:RemoveItem(src, item, amount, false, false, false) then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
        end
    elseif InvType == 'ox' then
        exports.ox_inventory:RemoveItem(src, item, amount)
    end
end

--add items
local function addItem(src, item, amount)
    if InvType == 'qb' then
        if exports['qb-inventory']:AddItem(src, item, amount, false, false, false) then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
        end
    elseif InvType == 'ox' then
        if exports.ox_inventory:CanCarryItem(src, item, amount) then
            exports.ox_inventory:AddItem(src, item, amount)
        else
            SendNotify(src, Config.Language.Notifications.CantCarry, 'error', 5000)
        end
    end
end


--calculate rewards
local function calculateXP(PeyoteXP)
    if Config.XP.Enabled then
        if PeyoteXP <= 150 then
            return math.random(1, 4)
        elseif PeyoteXP <= 500 then
            return math.random(3, 6)
        elseif PeyoteXP <= 750 then
            return math.random(5, 8)
        elseif PeyoteXP <= 1250 then
            return math.random(7, 10)
        elseif PeyoteXP <= 1500 then
            return math.random(9, 12)
        elseif PeyoteXP <= 2200 then
            return math.random(11, 14)
        else
            return math.random(13, 16) -- For players beyond the XP threshold
        end
    else
        return math.random(1,3) -- Default reward when XP is disabled
    end
end

--give xp
local function givePeyoteXP(src)
    if Config.XP.Enabled then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then
            print("Error: Player not found for source: " .. tostring(src))
            return
        end
        local MetaDataName = Config.XP.MetaDataName
        local PeyoteXP = Player.PlayerData.metadata[MetaDataName] or 0
        local xpChance = Config.XP.XPChance
        local xpAmount = Config.XP.XPGain
        if xpChance >= math.random(1,100) then
            local newXP = PeyoteXP + xpAmount
            Player.Functions.SetMetaData(MetaDataName, newXP)
            SendNotify(src, 'You earned ' .. xpAmount .. ' XP!', 'success', 5000)
        end
    end
end


----------USEABLE ITEMS-------------

--peyote plants
QBCore.Functions.CreateUseableItem("peyoteplants", function(source)
	TriggerClientEvent("lusty94_peyote:client:TakePeyotePlants", source)
end)



--------------CALL BACKS-----------
--peyoteplants
QBCore.Functions.CreateCallback('lusty94_peyote:get:PeyotePlants', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local peyote = Player.Functions.GetItemByName("peyoteplants")
    if peyote and peyote.amount >= 1 then
        cb(true)
    else
        cb(false)
    end
end)
--shovel
QBCore.Functions.CreateCallback('lusty94_peyote:get:Shovel', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local shovel = Player.Functions.GetItemByName("shovel")
    if shovel and shovel.amount >= 1 then
        cb(true)
    else
        cb(false)
    end
end)




----------EVENTS-------------

-- pick peyote plants
RegisterServerEvent('lusty94_peyote:server:PickPeyotePlants', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local PeyoteXP = Player.PlayerData.metadata[MetaDataName]
    local returnAmount = calculateXP(PeyoteXP)
    if Player then
        addItem(src, 'peyoteplants', returnAmount)
        givePeyoteXP()
    end
end)


-- take peyote plants
RegisterServerEvent('lusty94_peyote:server:TakePeyotePlants', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        removeItem(src, 'peyoteplants', 1)
    end
end)



-- /commands
if Config.XP.Enabled then
    if Config.XP.Command then
        QBCore.Commands.Add(MetaDataName, "Check Your Peyote XP Level", {}, true, function(source, args)
            local source = source
            local src = source
            local level = 1
            local Player = QBCore.Functions.GetPlayer(source)
            local data = Player.PlayerData.metadata[MetaDataName]
            if data ~= nil then
                for i=1, #Levels, 1 do
                    if data >= Levels[i] then
                        level = i + 1
                    end
                end
                SendNotify(src, "You Are Currently Level: " ..level.. " ( You have: " ..data.. " xp)", 'success', 2000)
            end
        end)
    end
end




--------------< VERSION CHECK >-------------

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Peyote/version.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        if not newestVersion then
            print('^1[Lusty94_Peyote]^7: Unable to fetch the latest version.')
            return
        end
        newestVersion = newestVersion:gsub('%s+', '')
        currentVersion = currentVersion and currentVersion:gsub('%s+', '') or "Unknown"
        if newestVersion == currentVersion then
            print(string.format('^2[Lusty94_Peyote]^7: ^6You are running the latest version.^7 (^2v%s^7)', currentVersion))
        else
            print(string.format('^2[Lusty94_Peyote]^7: ^3Your version: ^1v%s^7 | ^2Latest version: ^2v%s^7\n^1Please update to the latest version | Changelogs can be found in the support discord.^7', currentVersion, newestVersion))
        end
    end)
end

CheckVersion()