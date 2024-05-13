local QBCore = exports['qb-core']:GetCoreObject()
local MetaDataName = Config.XP.MetaDataName
local NotifyType = Config.CoreSettings.Notify.Type
local InvType = Config.CoreSettings.Inventory.Type
local Levels = Config.XP.Levels


--notification function
local function SendNotify(src, msg, type, time, title)
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
    elseif NotifyType == 'boii'  then
        TriggerClientEvent('boii_ui:notify', src, title, msg, type, time)
    elseif NotifyType == 'ox' then 
        TriggerClientEvent('ox_lib:notify', src, ({ title = title, description = msg, length = time, type = type, style = 'default'}))
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
    if peyote then
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
    if shovel then
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
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peyoteplants"], "add", amount)
        elseif InvType == 'ox' then
            if exports.ox_inventory:CanCarryItem(src, 'peyoteplants', amount) then
                exports.ox_inventory:AddItem(src, "peyoteplants", amount)
            else
                SendNotify(src,"You Can\'t Carry Anymore of This Item!", 'error', 2000)
            end
        end


    if Config.XP.Enabled then
        Player.Functions.SetMetaData(MetaDataName, (PeyoteXP + math.random(5,10))) -- Edit xp reward here
        SendNotify(src,"You Earned Some XP!", 'success', 2000)
    end	
end)


-- take peyote plants
RegisterServerEvent('lusty94_peyote:server:TakePeyotePlants', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    if InvType == 'qb' then
	    Player.Functions.RemoveItem('peyoteplants', 1)
	    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['peyoteplants'], "remove", 1)
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
                SendNotify(src, "You Are Currently Level: " ..level.. " ( You have: " ..data.. " xp)", 'success', 2000)
            end
        end)
    end
end





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