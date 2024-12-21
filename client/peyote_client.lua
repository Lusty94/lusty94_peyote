local QBCore = exports['qb-core']:GetCoreObject()
local NotifyType = Config.CoreSettings.Notify.Type
local TargetType = Config.CoreSettings.Target.Type
local ClothingType = Config.CoreSettings.Clothing.Type
local EvidenceEvent = Config.CoreSettings.EventNames.Evidence
local spawnedPeyote = {}
local busy = false
local peyoteprop = 'prop_peyote_water_01'

--notification function
local function SendNotify(msg,type,time,title)
    if NotifyType == nil then print("Lusty94_Peyote: NotifyType Not Set in Config.CoreSettings.Notify.Type!") return end
    if not title then title = "Peyote" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print("Notification Sent With No Message.") return end
    if NotifyType == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif NotifyType == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, true)
    elseif NotifyType == 'mythic' then
        exports['mythic_notify']:DoHudText(type, msg)
    elseif NotifyType == 'ox' then
        lib.notify({ title = title, description = msg, type = type, duration = time})
    end
end

CreateThread(function()
	for k,v in pairs(Config.Blips) do
		if v.useblip then
            peyoteblip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(peyoteblip, v.id)
            SetBlipDisplay(peyoteblip, 4)
            SetBlipScale(peyoteblip, v.scale)
            SetBlipColour(peyoteblip, v.colour)
            SetBlipAsShortRange(peyoteblip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(peyoteblip)
        end
	end

end)

--thread for spawning peyote plants
CreateThread(function()
	for k, v in pairs(Config.InteractionLocations.PeyotePlants) do
		lib.requestModel(peyoteprop, 10000)
		peyotePlants = CreateObject(peyoteprop, v.coords.x, v.coords.y, v.coords.z-1, true, false, false)
		PlaceObjectOnGroundProperly(peyotePlants)
		FreezeEntityPosition(peyotePlants, true)
		SetModelAsNoLongerNeeded(peyoteprop)
		spawnedPeyote[#spawnedPeyote+1] = peyotePlants
		SetEntityDrawOutline(peyotePlants, true)
		SetEntityDrawOutlineColor(75, 153, 0, 1.0)
		SetEntityDrawOutlineShader(0)
		if TargetType == 'qb' then
			exports['qb-target']:AddTargetEntity(peyotePlants, { options = { 
				{ 
					item = v.item,
					type = "client", 
					action = function()
						if not busy then
							pickPeyotePlants()
						else
							SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
						end
					end,
					icon = v.icon, 
					label = v.label, 
				}, 
			}, distance = v.distance })
		elseif TargetType == 'ox' then
			exports.ox_target:addLocalEntity(peyotePlants, (
				{ 
					name = 'peyotePlants', 
					items = v.item, 
					label = v.label, 
					icon = v.icon, 
					onSelect = function()
						if not busy then
							pickPeyotePlants()
						else
							SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
						end
					end,
					distance = v.distance, 
				}
			))
		end
	end
end)




-- Pick Peyote Plants
function pickPeyotePlants()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #spawnedPeyote, 1 do
		if #(coords - GetEntityCoords(spawnedPeyote[i])) < 3 then
			nearbyObject, nearbyID = spawnedPeyote[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		if busy then
			SendNotify(Config.Language.Notifications.Busy, 'error', 2500)
		else
			QBCore.Functions.TriggerCallback('lusty94_peyote:get:Shovel', function(HasItems)
				if HasItems then
					busy = true
					LockInventory(true)			
					if lib.progressCircle({ 
						duration = 5000, 
						position = 'bottom', 
						label = 'Picking peyote plants',
						useWhileDead = false, 
						canCancel = true, 
						disable = { car = true, move = true, }, 
						anim = { 
							dict = Config.Animations.PickPeyotePlants.AnimDict, 
							clip = Config.Animations.PickPeyotePlants.Anim, 
							flag = Config.Animations.PickPeyotePlants.Flags,
						},
						prop = { 
							model = Config.Animations.PickPeyotePlants.Prop, 
							bone = Config.Animations.PickPeyotePlants.Bone, 
							pos = Config.Animations.PickPeyotePlants.Pos, 
							rot = Config.Animations.PickPeyotePlants.Rot,
						},
					}) then
						SetEntityAsMissionEntity(nearbyObject, false, true)
						DeleteObject(nearbyObject)
						spawnedPeyote[nearbyID] = nil
						local pick = 75 -- change chance to get peyote here
						local chance = math.random(1,100)
						if pick >= chance then
							TriggerServerEvent('lusty94_peyote:server:PickPeyotePlants')
						else
							SendNotify(Config.Language.Notifications.NothingFound, 'error', 2500)
						end
						busy = false
						LockInventory(false)
					else
						busy = false
						LockInventory(false)
						SendNotify(Config.Language.Notifications.Cancelled, 'error', 2500)
					end
				else
					SendNotify(Config.Language.Notifications.MissingItem, 'error', 2500)
				end
			end)
		end
	end
end




local modelVariants = {
    "a_c_boar",
    "a_c_cat_01",
    "a_c_chickenhawk",
    "a_c_chimp",
    "a_c_cormorant",
    "a_c_cow",
    "a_c_coyote",
    "a_c_crow",
    "a_c_deer",
    "a_c_hen",
    "a_c_pig",
    "a_c_pigeon",
    "a_c_poodle",
    "a_c_pug",
    "a_c_rabbit_01",
    "a_c_rat",
    "a_c_rhesus",
    "a_c_seagull",
    "a_c_westy",
}



--consume peyote plants function
function TakePeyotePlants()
	local randomModel = modelVariants[math.random(1, #modelVariants)]
	local playerPed = PlayerPedId()
	print('random model selected to transform into is:', randomModel, 'if the selected model is invisible then delete it from modelVariants table - some models are not compatible as player models')
	Wait(2000)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.00)
	Wait(2000)
	ShakeGameplayCam('DRUNK_SHAKE', 1.10)
	Wait(2000) 
	SetTimecycleModifier('spectator5')
	SetPedMotionBlur(playerPed, true) 
	TriggerEvent(EvidenceEvent, "widepupils", 300)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.10)
	Wait(2000)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.10)
	Wait(2000)
	DoScreenFadeOut(1000)
	Wait(2000)
	ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    StopGameplayCamShaking(playerPed, true)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)
	if IsModelInCdimage(randomModel) and IsModelValid(randomModel) then
		lib.requestModel(randomModel, 10000)
		SetPlayerModel(PlayerPedId(), randomModel)
		SetPlayerInvincible(playerPed, true)
		SetModelAsNoLongerNeeded(randomModel)
	end
	Wait(1500)
	DoScreenFadeIn(2000)
	Wait(20000)
	DoScreenFadeOut(1000)
	Wait(2000)
	if ClothingType == 'qb' then
		TriggerServerEvent('qb-clothes:loadPlayerSkin')
	elseif ClothingType == 'illenium' then
		TriggerServerEvent('qb-clothes:loadPlayerSkin') -- support for illenium-appearance as illenium has qb compatibility providing you installed it correctly!
	end
	SetPlayerInvincible(playerPed, false)
	SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 100)
	Wait(2000)
	DoScreenFadeIn(2000)
	ClearPedTasks(playerPed)
end


-- take peyote plants
RegisterNetEvent('lusty94_peyote:client:TakePeyotePlants', function()
	local playerPed = PlayerPedId()
	if busy then
		SendNotify(Config.Language.Notifications.Busy, 'error', 2500)
	else
		QBCore.Functions.TriggerCallback('lusty94_peyote:get:PeyotePlants', function(HasItems)  
			if HasItems then
				busy = true
				LockInventory(true)
				if lib.progressCircle({ 
					duration = 5000, 
					label = 'Consuming peyote plant',
					position = 'bottom', 
					useWhileDead = false, 
					canCancel = true, 
					disable = { car = false, move = false, }, 
					anim = { 
						dict = Config.Animations.ConsumePeyote.AnimDict, 
						clip = Config.Animations.ConsumePeyote.Anim, 
						flag = Config.Animations.ConsumePeyote.Flags,
					},
					prop = { 
						model = Config.Animations.ConsumePeyote.Prop, 
						bone = Config.Animations.ConsumePeyote.Bone, 
						pos = Config.Animations.ConsumePeyote.Pos, 
						rot = Config.Animations.ConsumePeyote.Rot,
					},
				}) then
					TriggerServerEvent('lusty94_peyote:server:TakePeyotePlants')
					busy = false
					LockInventory(false)
					TakePeyotePlants()
				else
					busy = false
					LockInventory(false)
					SendNotify(Config.Language.Notifications.Cancelled, 'error', 2500)
				end
			else
				SendNotify("You are missing items required!", 'error', 2500)
			end
		end)
	end
end)


-- function to lock inventory to prevent exploits
function LockInventory(toggle)
	if toggle then
        LocalPlayer.state:set("inv_busy", true, true)
    else 
        LocalPlayer.state:set("inv_busy", false, true)
    end
end



AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		for _, v in pairs(spawnedPeyote) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) end
		spawnedPeyote = {}
		if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(peyotePlants, 'peyotePlants') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(peyotePlants, 'peyotePlants') end
		busy = false
		LockInventory(false)
		print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Peyote V2.1.0 Stopped Successfully ^5--<^3!^5>--^7')
	end
end)