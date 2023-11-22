local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPeyotePlants = 0
local peyotePlants = {}
local isPicking, inZone = false, false
local NotifyType = Config.CoreSettings.Notify.Type
local TargetType = Config.CoreSettings.Target.Type
local MiniGameType = Config.MiniGameSettings.Type
local EvidenceEvent = Config.CoreSettings.EventNames.Evidence
local peyotePropName = Config.CoreSettings.Props.PeyotePlants.Name
local isTakingDrugs = false



--blip for peyote plants
CreateThread(function()
	for k, v in pairs(Config.Blips) do
        if v.useblip then
            v.blip = AddBlipForCoord(v['coords'].x, v['coords'].y, v['coords'].z)
            SetBlipSprite(v.blip, v.id)
            SetBlipDisplay(v.blip, 4)
            SetBlipScale(v.blip, v.scale)
            SetBlipColour(v.blip, v.colour)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(v.blip)
        end
    end
end)


-- Verify Peyote Location
local function verifyPeyoteLocations(plantCoord)
	local validate = true
	if spawnedPeyotePlants > 0 then
		for _, v in pairs(peyotePlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inZone then
			validate = false
		end
	end
	return validate
end

-- Get Z Coords of Peyote
local function getPeyoteZCoord(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end

-- Generate Peyote Randomly
local function generatePeyoteCoords()
	while true do
		Wait(1)

		local PeyoteCoordX, PeyoteCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		PeyoteCoordX = Config.InteractionLocations.PeyotePlants.coords.x + modX
		PeyoteCoordY = Config.InteractionLocations.PeyotePlants.coords.y + modY

		local coordZ = getPeyoteZCoord(PeyoteCoordX, PeyoteCoordY)
		local coord = vector3(PeyoteCoordX, PeyoteCoordY, coordZ)

		if verifyPeyoteLocations(coord) then
			return coord
		end
	end
end

--Spawn Peyote
local function SpawnPeyotePlants()
	local model = peyotePropName
	if TargetType == 'qb' then
		exports['qb-target']:AddTargetModel(model, { options = { { item = Config.CoreSettings.Props.PeyotePlants.TargetItemName,type = "client", event = "lusty94_peyote:client:PickPeyotePlants", icon = Config.CoreSettings.Props.PeyotePlants.TargetIcon, label = Config.CoreSettings.Props.PeyotePlants.TargetLabel, }, }, distance = Config.CoreSettings.Props.PeyotePlants.TargetDistance })
	elseif TargetType == 'ox' then
		exports.ox_target:addModel(model, ({ items = Config.CoreSettings.Props.PeyotePlants.TargetItemName, name = 'peyoteplants', label = Config.CoreSettings.Props.PeyotePlants.TargetLabel, icon = Config.CoreSettings.Props.PeyotePlants.TargetIcon, event = 'lusty94_peyote:client:PickPeyotePlants', distance = Config.CoreSettings.Props.PeyotePlants.TargetDistance, }))
	end
	while spawnedPeyotePlants < Config.InteractionLocations.PeyotePlants.plants do
		Wait(0)
		local peyoteLocation = generatePeyoteCoords()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(100)
		end
		local obj = CreateObject(model, peyoteLocation.x, peyoteLocation.y, peyoteLocation.z, false, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		peyotePlants[#peyotePlants+1] = obj
		spawnedPeyotePlants += 1
		SetEntityDrawOutline(obj, true)
		SetEntityDrawOutlineColor(75, 153, 0, 1.0)
		SetEntityDrawOutlineShader(0)
	end
	SetModelAsNoLongerNeeded(model)
end



--create peyote zone
CreateThread(function()
	local peyoteZone = CircleZone:Create(Config.InteractionLocations.PeyotePlants.coords, Config.InteractionLocations.PeyotePlants.radius, {
		name = "peyotePlants",
		debugPoly = Config.DebugPoly
	})
	peyoteZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inZone = true
            SpawnPeyotePlants()
        else
            inZone = false
        end
    end)
end)








-- Pick Peyote Plants
RegisterNetEvent("lusty94_peyote:client:PickPeyotePlants", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #peyotePlants, 1 do
		if #(coords - GetEntityCoords(peyotePlants[i])) < 5 then
			nearbyObject, nearbyID = peyotePlants[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		if not isPicking then
			isPicking = true			
			QBCore.Functions.TriggerCallback('lusty94_peyote:get:Shovel', function(HasItems)  
				local prop = GetHashKey(Config.Animations.PickPeyotePlants.Prop)
				local coords = GetEntityCoords(PlayerPedId())
				RequestModel(prop)
				while not HasModelLoaded(prop) do
					Citizen.Wait(100)
					RequestModel(prop)
				end
				local shovel = CreateObject(prop, GetEntityCoords(PlayerPedId()), true, true, true)
				AttachEntityToEntity(shovel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.24, 0, 0, 0.0, 0.0, true, true, false, false, 1, true)
				RequestAnimDict(Config.Animations.PickPeyotePlants.AnimDict)
				while not HasAnimDictLoaded(Config.Animations.PickPeyotePlants.AnimDict) do
					Wait(10)
				end
				TaskPlayAnim(PlayerPedId(), Config.Animations.PickPeyotePlants.AnimDict, Config.Animations.PickPeyotePlants.Anim, 1.0, -1.0, 1.0, 11, Config.Animations.PickPeyotePlants.Flags, 0, 0, 0)
				if HasItems then
					if MiniGameType == 'prog' then
						QBCore.Functions.Progressbar("pickpeyote", Config.Language.ProgressBar.PickPeyotePlants, Config.CoreSettings.ProgressBar.PickPeyotePlants, false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
						}, {}, {}, function() -- Done
							DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							SetEntityAsMissionEntity(nearbyObject, false, true)
							DeleteObject(nearbyObject)
							peyotePlants[nearbyID] = nil
							spawnedPeyotePlants -= 1
							local chance = math.random(1,100)
							local chance2 = Config.InteractionLocations.PeyotePlants.chance
							if chance <= chance2 then
								TriggerServerEvent('lusty94_peyote:server:PickPeyotePlants')
							else
								if NotifyType == 'qb' then
									QBCore.Functions.Notify(Config.Language.Notifications.NothingFoundName, "error", Config.CoreSettings.Notify.Length.Error)
								elseif NotifyType == 'okok' then
									exports['okokNotify']:Alert(Config.Language.Notifications.NothingFoundLabel, Config.Language.Notifications.NothingFoundName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
								elseif NotifyType == 'mythic' then
									exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.NothingFoundName)
								elseif NotifyType == 'boii' then
									exports['boii_ui']:notify(Config.Language.Notifications.NothingFoundLabel, Config.Language.Notifications.NothingFoundName, 'error', Config.CoreSettings.Notify.Length.Error)
								elseif NotifyType == 'ox' then
									lib.notify({ title = Config.Language.Notifications.NothingFoundLabel, description = Config.Language.Notifications.NothingFoundName, type = 'error' })
								end
							end
							isPicking = false
						end, function()
							DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							isPicking = false
							if NotifyType == 'qb' then
								QBCore.Functions.Notify(Config.Language.Notifications.CancelledName, "error", Config.CoreSettings.Notify.Length.Error)
							elseif NotifyType == 'okok' then
								exports['okokNotify']:Alert(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
							elseif NotifyType == 'mythic' then
								exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.CancelledName)
							elseif NotifyType == 'boii' then
								exports['boii_ui']:notify(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, 'error', Config.CoreSettings.Notify.Length.Error)
							elseif NotifyType == 'ox' then
								lib.notify({ title = Config.Language.Notifications.CancelledLabel, description = Config.Language.Notifications.CancelledName, type = 'error' })
							end
						end)
					elseif MiniGameType == 'ox' then
						Wait(500)
						local success = lib.skillCheck({Config.MiniGameSettings.SkillCheckSettings.Difficulty, Config.MiniGameSettings.SkillCheckSettings.Difficulty, {areaSize = Config.MiniGameSettings.SkillCheckSettings.AreaSize, speedMultiplier = Config.MiniGameSettings.SkillCheckSettings.SpeedMultiplier}, Config.MiniGameSettings.SkillCheckSettings.Difficulty}, Config.MiniGameSettings.SkillCheckSettings.Keys)
						if success then
							DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							SetEntityAsMissionEntity(nearbyObject, false, true)
							DeleteObject(nearbyObject)
							peyotePlants[nearbyID] = nil
							spawnedPeyotePlants -= 1
							local chance = math.random(1,100)
							local chance2 = Config.InteractionLocations.PeyotePlants.chance
							if chance <= chance2 then
								TriggerServerEvent('lusty94_peyote:server:PickPeyotePlants')
							else
								if NotifyType == 'qb' then
									QBCore.Functions.Notify(Config.Language.Notifications.NothingFoundName, "error", Config.CoreSettings.Notify.Length.Error)
								elseif NotifyType == 'okok' then
									exports['okokNotify']:Alert(Config.Language.Notifications.NothingFoundLabel, Config.Language.Notifications.NothingFoundName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
								elseif NotifyType == 'mythic' then
									exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.NothingFoundName)
								elseif NotifyType == 'boii' then
									exports['boii_ui']:notify(Config.Language.Notifications.NothingFoundLabel, Config.Language.Notifications.NothingFoundName, 'error', Config.CoreSettings.Notify.Length.Error)
								elseif NotifyType == 'ox' then
									lib.notify({ title = Config.Language.Notifications.NothingFoundLabel, description = Config.Language.Notifications.NothingFoundName, type = 'error' })
								end
							end
							isPicking = false
						else
							DeleteEntity(shovel)
							ClearPedTasks(PlayerPedId())
							isPicking = false
							if NotifyType == 'qb' then
								QBCore.Functions.Notify(Config.Language.Notifications.CancelledName, "error", Config.CoreSettings.Notify.Length.Error)
							elseif NotifyType == 'okok' then
								exports['okokNotify']:Alert(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
							elseif NotifyType == 'mythic' then
								exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.CancelledName)
							elseif NotifyType == 'boii' then
								exports['boii_ui']:notify(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, 'error', Config.CoreSettings.Notify.Length.Error)
							elseif NotifyType == 'ox' then
								lib.notify({ title = Config.Language.Notifications.CancelledLabel, description = Config.Language.Notifications.CancelledName, type = 'error' })
							end
						end
					end
				else
					if NotifyType == 'qb' then
						QBCore.Functions.Notify(Config.Language.Notifications.NoItemsName, "error", Config.CoreSettings.Notify.Length.Error)
					elseif NotifyType == 'okok' then
						exports['okokNotify']:Alert(Config.Language.Notifications.NoItemsLabel, Config.Language.Notifications.NoItemsName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
					elseif NotifyType == 'mythic' then
						exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.NoItemsName)
					elseif NotifyType == 'boii' then
						exports['boii_ui']:notify(Config.Language.Notifications.NoItemsLabel, Config.Language.Notifications.NoItemsName, 'error', Config.CoreSettings.Notify.Length.Error)
					elseif NotifyType == 'ox' then
						lib.notify({ title = Config.Language.Notifications.NoItemsLabel, description = Config.Language.Notifications.NoItemsName, type = 'error' })
					end
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


local originalModel = nil

function SaveOriginalModel()
    originalModel = GetEntityModel(PlayerPedId())
end

function RevertToOriginalModel()
    if originalModel then
        RequestModel(originalModel)
        while not HasModelLoaded(originalModel) do
            Wait(0)
        end
        SetPlayerModel(PlayerId(), originalModel)
        SetModelAsNoLongerNeeded(originalModel)
        originalModel = nil
		SetPlayerInvincible(PlayerPedId(), false)
		SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 100)
    else
		print('error, incorrect model specified, unable to revert back to original ped model!')
    end
end



function GetRandomModelVariant()
    return modelVariants[math.random(1, #modelVariants)]
end

local function TakePeyotePlants()
	SaveOriginalModel()
	local randomModel = GetRandomModelVariant()
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
	RevertToOriginalModel() 
	DoScreenFadeIn(2500)
	ClearPedTasks(player)
end


-- take peyote plants
RegisterNetEvent('lusty94_peyote:client:TakePeyotePlants', function()

	QBCore.Functions.TriggerCallback('lusty94_peyote:get:PeyotePlants', function(HasItems)  
        if HasItems then
			if isTakingDrugs then
				if NotifyType == 'qb' then
					QBCore.Functions.Notify(Config.Language.Notifications.AlreadyTakingDrugsName, "error", Config.CoreSettings.Notify.Length.Error)
				elseif NotifyType == 'okok' then
					exports['okokNotify']:Alert(Config.Language.Notifications.AlreadyTakingDrugsLabel, Config.Language.Notifications.AlreadyTakingDrugsName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
				elseif NotifyType == 'mythic' then
					exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.AlreadyTakingDrugsName)
				elseif NotifyType == 'boii' then
					exports['boii_ui']:notify(Config.Language.Notifications.AlreadyTakingDrugsLabel, Config.Language.Notifications.AlreadyTakingDrugsName, 'error', Config.CoreSettings.Notify.Length.Error)
				elseif NotifyType == 'ox' then
					lib.notify({ title = Config.Language.Notifications.AlreadyTakingDrugsLabel, description = Config.Language.Notifications.AlreadyTakingDrugsName, type = 'error' })
				end
			else
				isTakingDrugs = true
				local prop = GetHashKey(peyotePropName)
				RequestModel(prop)
				while not HasModelLoaded(prop) do
					Citizen.Wait(100)
					RequestModel(prop)
				end
				local peyoteprop = CreateObject(prop, GetEntityCoords(PlayerPedId()), true, true, true)
				AttachEntityToEntity(peyoteprop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.15, 0.0, 0.0, -190.0, 0.0, 0.0, true, true, false, false, 1, true)
				QBCore.Functions.Progressbar('TakePeyotePlants', Config.Language.ProgressBar.TakePeyotePlants, Config.CoreSettings.ProgressBar.TakePeyotePlants, false, true,{
					disableMovement = false,
					disableCarMovement = false,
					disableMouse = false,
					disableCombat = false,
				}, {
					animDict = Config.Animations.TakeDrugs.AnimDict,
					anim = Config.Animations.TakeDrugs.Anim,
					flags = Config.Animations.TakeDrugs.Flags,
				}, {}, {}, function()
					DeleteEntity(peyoteprop)
					isTakingDrugs = false
					TriggerServerEvent('lusty94_peyote:server:TakePeyotePlants')
					TakePeyotePlants()
				end, function() -- Cancel
					DeleteEntity(peyoteprop)
					ClearPedTasks(PlayerPedId())
					isTakingDrugs = false
					if NotifyType == 'qb' then
						QBCore.Functions.Notify(Config.Language.Notifications.CancelledName, "error", Config.CoreSettings.Notify.Length.Error)
					elseif NotifyType == 'okok' then
						exports['okokNotify']:Alert(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
					elseif NotifyType == 'mythic' then
						exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.CancelledName)
					elseif NotifyType == 'boii' then
						exports['boii_ui']:notify(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledName, 'error', Config.CoreSettings.Notify.Length.Error)
					elseif NotifyType == 'ox' then
						lib.notify({ title = Config.Language.Notifications.CancelledLabel, description = Config.Language.Notifications.CancelledName, type = 'error' })
					end 
				end)
			end
		else
			if NotifyType == 'qb' then
				QBCore.Functions.Notify(Config.Language.Notifications.NoItemsName, "error", Config.CoreSettings.Notify.Length.Error)
			elseif NotifyType == 'okok' then
				exports['okokNotify']:Alert(Config.Language.Notifications.NoItemsLabel, Config.Language.Notifications.NoItemsName, Config.CoreSettings.Notify.Length.Error, 'error', Config.CoreSettings.Notify.Sound)
			elseif NotifyType == 'mythic' then
				exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.NoItemsName)
			elseif NotifyType == 'boii' then
				exports['boii_ui']:notify(Config.Language.Notifications.NoItemsLabel, Config.Language.Notifications.NoItemsName, 'error', Config.CoreSettings.Notify.Length.Error)
			elseif NotifyType == 'ox' then
				lib.notify({ title = Config.Language.Notifications.NoItemsLabel, description = Config.Language.Notifications.NoItemsName, type = 'error' })
			end
		end
	end)
end)





AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(peyotePlants) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
		istakingDrugs = false
	end
    print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Peyote V1.0.0 Stopped Successfully ^5--<^3!^5>--^7')
end)