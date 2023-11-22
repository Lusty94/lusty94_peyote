local QBCore = exports['qb-core']:GetCoreObject()
local MetaDataName = Config.XP.MetaDataName
local NotifyType = Config.CoreSettings.Notify.Type
local InvType = Config.CoreSettings.Inventory.Type
local Levels = Config.XP.Levels

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
    local item1 = Player.Functions.GetItemByName("peyoteplants")
    if item1 then
        cb(true)
    else
        cb(false)
    end
end)
--shovel
QBCore.Functions.CreateCallback('lusty94_peyote:get:Shovel', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item1 = Player.Functions.GetItemByName("shovel")
    if item1 then
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

    if Config.XP.Enabled then
        if PeyoteXP <= 150 then
            amount = math.random(2,5)
        elseif PeyoteXP <= 500 then
            amount = math.random(5,8)
        elseif PeyoteXP <= 750 then
            amount = math.random(8, 11)
        elseif PeyoteXP <= 1250 then
            amount = math.random(11, 14)
        elseif PeyoteXP <= 1500 then
            amount = math.random(14, 17)
        elseif PeyoteXP <= 2000 then
            amount = math.random(17, 20)
        else
            amount = math.random(23,26)
        end
    else amount = math.random(3,6) end
        if InvType == 'qb' then
            Player.Functions.AddItem("peyoteplants", amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peyoteplants"], "add")
        elseif InvType == 'ox' then
            if exports.ox_inventory:CanCarryItem(src, 'peyoteplants', amount) then
                exports.ox_inventory:AddItem(src, "peyoteplants", amount)
            else
                if NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, Config.Language.Notifications.CantCarryName, 'error', Config.CoreSettings.Notify.Length.Error)
                elseif NotifyType == 'okok' then
                    TriggerClientEvent('okokNotify:Alert', src, Config.Language.Notifications.CantCarryLabel, Config.Language.Notifications.CantCarryName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
                elseif NotifyType == 'mythic' then
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.Language.Notifications.CantCarryName, style = { ['background-color'] = '#FF0000', ['color'] = '#FFFFFF' } })
                elseif NotifyType == 'boii'  then
                    TriggerClientEvent('boii_ui:notify', src, Config.Language.Notifications.CantCarryLabel, Config.Language.Notifications.CantCarryName, 'error', Config.CoreSettings.Notify.Length.Error)
                elseif NotifyType == 'ox' then 
                    TriggerClientEvent('ox_lib:notify', src, ({ title = Config.Language.Notifications.CantCarryLabel, description = Config.Language.Notifications.CantCarryName, length = Config.CoreSettings.Notify.Length.Error, type = 'error', style = 'default'}))
                end
            end
        end


    if Config.XP.Enabled then
        Player.Functions.SetMetaData(MetaDataName, (PeyoteXP + math.random(5,10))) -- Edit xp reward here
        if NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, Config.Language.Notifications.EarnedXpName, 'success', Config.CoreSettings.Notify.Length.Success)
        elseif NotifyType == 'okok' then
            TriggerClientEvent('okokNotify:Alert', src, Config.Language.Notifications.EarnedXpLabel, Config.Language.Notifications.EarnedXpName, Config.CoreSettings.Notify.Length.Success, 'success', Config.CoreSettings.Notify.Sound)
        elseif NotifyType == 'mythic' then
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = Config.Language.Notifications.EarnedXpName, style = { ['background-color'] = '#FF0000', ['color'] = '#FFFFFF' } })
        elseif NotifyType == 'boii'  then
            TriggerClientEvent('boii_ui:notify', src, Config.Language.Notifications.EarnedXpLabel, Config.Language.Notifications.EarnedXpName, 'success', Config.CoreSettings.Notify.Length.Success)
        elseif NotifyType == 'ox' then 
            TriggerClientEvent('ox_lib:notify', src, ({ title = Config.Language.Notifications.EarnedXpLabel, description = Config.Language.Notifications.EarnedXpName, length = Config.CoreSettings.Notify.Length.Success, type = 'success', style = 'default'}))
        end
    end	
end)


-- take peyote plants
RegisterServerEvent('lusty94_peyote:server:TakePeyotePlants', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    if InvType == 'qb' then
	    Player.Functions.RemoveItem('peyoteplants', 1)
	    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['peyoteplants'], "remove")
    elseif InvType == 'ox' then
        exports.ox_inventory:RemoveItem(src, 'peyoteplants', 1)        
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
                if NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, 'You Are Currently Level: ' ..level.. ' ( You have: ' ..data.. ' xp)', 'success', Config.CoreSettings.Notify.Length.Success)
                elseif NotifyType == 'okok' then
                    TriggerClientEvent('okokNotify:Alert', src, 'XP Level', 'You Are Currently Level: ' ..level.. ' ( You have: ' ..data.. ' xp)', Config.CoreSettings.Notify.Length.Success, 'success', Config.CoreSettings.Notify.Sound)
                elseif NotifyType == 'mythic' then
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = 'You Are Currently Level: ' ..level.. ' ( You have: ' ..data.. ' xp)', style = { ['background-color'] = '#FF0000', ['color'] = '#FFFFFF' } })
                elseif NotifyType == 'boii'  then
                    TriggerClientEvent('boii_ui:notify', src, 'XP Level', 'You Are Currently Level: ' ..level.. ' ( You have: ' ..data.. ' xp)', 'success', Config.CoreSettings.Notify.Length.Success)
                elseif NotifyType == 'ox' then 
                    TriggerClientEvent('ox_lib:notify', src, ({ title = 'XP Level', description = 'You Are Currently Level: ' ..level.. ' ( You have: ' ..data.. ' xp)', length = Config.CoreSettings.Notify.Length.Success, type = 'success', style = 'default'}))
                end
            end
        end)
    end
end



AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
        print('^5--<^3!^5>-- ^7| Lusty94 ^5| ^5--<^3!^5>-- ^7 Peyote V1.0.0 Started Successfully ^5--<^3!^5>--^7')
end)



local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Peyote/version.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion..advice) end
	end)
end
CheckVersion()