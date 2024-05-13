local QBCore = exports['qb-core']:GetCoreObject()
local peyotePlants = {}
local busy = false
local NotifyType = Config.CoreSettings.Notify.Type
local TargetType = Config.CoreSettings.Target.Type
local ClothingType = Config.CoreSettings.Clothing.Type
local EvidenceEvent = Config.CoreSettings.EventNames.Evidence
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
    elseif NotifyType == 'boii' then
        exports['boii_ui']:notify(title, msg, type, time)
    elseif NotifyType == 'ox' then
        lib.notify({ title = title, description = msg, type = type, duration = time})
    end
end

CreateThread(function()
	for k,v in pairs(Config.Blips) do
		if v.useblip then
            peyoteblip = AddBlipForCoord(v['coords'].x, v['coords'].y, v['coords'].z)
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
		RequestModel(peyoteprop)
		while not HasModelLoaded(peyoteprop) do
			Wait(1000)
		end
		local plant = CreateObject(peyoteprop, v.coords.x, v.coords.y, v.coords.z-1, false, true, false)
		PlaceObjectOnGroundProperly(plant)
		FreezeEntityPosition(plant, true)
		peyotePlants[#peyotePlants+1] = plant
		SetEntityDrawOutline(plant, true)
		SetEntityDrawOutlineColor(75, 153, 0, 1.0)
		SetEntityDrawOutlineShader(0)
		if TargetType == 'qb' then
			exports['qb-target']:AddTargetEntity(plant, { options = { { item = v.item,type = "client", event = "lusty94_peyote:client:PickPeyotePlants", icon = v.icon, label = v.label, }, }, distance = v.distance })
		elseif TargetType == 'ox' then
			exports.ox_target:addLocalEntity(plant, ({ name = 'plant', items = v.item, name = 'peyoteplants', label = v.label, icon = v.icon, event = 'lusty94_peyote:client:PickPeyotePlants', distance = v.distance, }))
		end
	end
end)




-- Pick Peyote Plants
RegisterNetEvent("lusty94_peyote:client:PickPeyotePlants", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #peyotePlants, 1 do
		if #(coords - GetEntityCoords(peyotePlants[i])) < 3 then
			nearbyObject, nearbyID = peyotePlants[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		if busy then
			SendNotify("You are already doing something!", 'error', 2500)
		else
			busy = true			
			QBCore.Functions.TriggerCallback('lusty94_peyote:get:Shovel', function(HasItems)  
				local prop = GetHashKey(Config.Animations.PickPeyotePlants.Prop)
				local coords = GetEntityCoords(PlayerPedId())
				RequestModel(prop)
				while not HasModelLoaded(prop) do
					Wait(1000)
				end
				local shovel = CreateObject(prop, GetEntityCoords(PlayerPedId()), true, true, true)
				AttachEntityToEntity(shovel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.24, 0, 0, 0.0, 0.0, true, true, false, false, 1, true)
				if HasItems then
					if lib.progressCircle({ duration = 5000, position = 'bottom', useWhileDead = false, canCancel = true, disable = { car = false, }, anim = { dict = Config.Animations.PickPeyotePlants.AnimDict, clip = Config.Animations.PickPeyotePlants.Anim }, }) 
					then
						DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							SetEntityAsMissionEntity(nearbyObject, false, true)
							DeleteObject(nearbyObject)
							peyotePlants[nearbyID] = nil
							local chance = math.random(1,100)
							if chance <= 75 then
								TriggerServerEvent('lusty94_peyote:server:PickPeyotePlants')
							else
								SendNotify("This plant was damaged! Try another", 'error', 2500)
							end
							busy = false
					else
						DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							busy = false
							SendNotify("Action cancelled!", 'error', 2500)
					end
				else
					SendNotify("You are missing items required to pick peyote plants!", 'error', 2500)
				end
			end)
		end
	end
end)




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




local function TakePeyotePlants()
	local randomModel = modelVariants[math.random(1, #modelVariants)]
	local player = PlayerPedId()
	print('random model selected to transform into is:', randomModel, 'if this model is invisible then delete it from modelVariants above')
	Wait(2500)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.00)
	Wait(2000)
	ShakeGameplayCam('DRUNK_SHAKE', 1.10)
	Wait(3000) 
	SetTimecycleModifier('spectator5')
	SetPedMotionBlur(player, true) 
	TriggerEvent(EvidenceEvent, "widepupils", 300)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.10)
	Wait(2000)
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.10)
	Wait(2500)
	DoScreenFadeOut(1000)
	Wait(2500)
	ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    SetRunSprintMultiplierForPlayer(player, 1.0)
    StopGameplayCamShaking(player, true)
    SetPedIsDrunk(player, false)
    SetPedMotionBlur(player, false)
	if IsModelInCdimage(randomModel) and IsModelValid(randomModel) then
		RequestModel(randomModel)
		while not HasModelLoaded(randomModel) do
			Wait(0)
		end
		SetPlayerModel(PlayerId(), randomModel)
		SetPlayerInvincible(PlayerPedId(), true)
		SetModelAsNoLongerNeeded(randomModel)
	end
	Wait(1000)
	DoScreenFadeIn(2500)
	Wait(15000)
	DoScreenFadeOut(1000)
	Wait(2500)
	if ClothingType == 'qb' then
		TriggerServerEvent('qb-clothes:loadPlayerSkin')
	elseif ClothingType == 'illenium' then
		TriggerServerEvent('qb-clothes:loadPlayerSkin') -- support for illenium-appearance as illenium has qb compatibility providing you installed it correctly!
	end
	SetPlayerInvincible(PlayerPedId(), false)
	SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 100)
	DoScreenFadeIn(2500)
	ClearPedTasks(player)
end


-- take peyote plants
RegisterNetEvent('lusty94_peyote:client:TakePeyotePlants', function()

	QBCore.Functions.TriggerCallback('lusty94_peyote:get:PeyotePlants', function(HasItems)  
        if HasItems then
			if busy then
				SendNotify("You are already doing something!", 'error', 2500)
			else
				busy = true
				RequestModel(peyoteprop)
				while not HasModelLoaded(peyoteprop) do
					Wait(1000)
				end
				local prop = CreateObject(peyoteprop, GetEntityCoords(PlayerPedId()), true, true, true)
				AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.15, 0.0, 0.0, -190.0, 0.0, 0.0, true, true, false, false, 1, true)
				if lib.progressCircle({ duration = 5000, position = 'bottom', useWhileDead = false, canCancel = true, disable = { car = false, }, anim = { dict = Config.Animations.TakeDrugs.AnimDict, clip = Config.Animations.TakeDrugs.Anim }, }) 
				then
					DeleteEntity(prop)
					busy = false
					TriggerServerEvent('lusty94_peyote:server:TakePeyotePlants')
					TakePeyotePlants()
				else
					DeleteEntity(prop)
					ClearPedTasks(PlayerPedId())
					busy = false
					SendNotify("Action cancelled!", 'error', 2500)
				end
			end
		else
			SendNotify("You are missing items required!", 'error', 2500)
		end
	end)
end)





AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(peyotePlants) do SetEntityAsMissionEntity(v, false, true) DeleteObject(v) end
		busy = false
		print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Peyote V1.0.0 Stopped Successfully ^5--<^3!^5>--^7')
	end
end)