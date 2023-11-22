Config = {}


--
--██╗░░░░░██╗░░░██╗░██████╗████████╗██╗░░░██╗░█████╗░░░██╗██╗
--██║░░░░░██║░░░██║██╔════╝╚══██╔══╝╚██╗░██╔╝██╔══██╗░██╔╝██║
--██║░░░░░██║░░░██║╚█████╗░░░░██║░░░░╚████╔╝░╚██████║██╔╝░██║
--██║░░░░░██║░░░██║░╚═══██╗░░░██║░░░░░╚██╔╝░░░╚═══██║███████║
--███████╗╚██████╔╝██████╔╝░░░██║░░░░░░██║░░░░█████╔╝╚════██║
--╚══════╝░╚═════╝░╚═════╝░░░░╚═╝░░░░░░╚═╝░░░░╚════╝░░░░░░╚═╝


-- Thank you for downloading this script!

-- Below you can change multiple options to suit your server needs.


Config.DebugPoly = false -- debugs polyzone and displays green area of peyote plants zone


Config.CoreSettings = {
    EventNames = {
        Evidence = 'evidence:client:SetStatus', -- name of evidence event to set widepupils status when taking peyote plants
    },
    Target = {
        Type = 'qb', -- target script name support for qb-target and ox_target        
        --use 'qb' for qb-target
        --use 'ox' for ox_target 
    },
    Notify = {
        Type = 'qb', -- notification type, support for qb-core notify, okokNotify, mythic_notify, boii_ui notify and ox_lib notify
        --use 'qb' for default qb-core notify
        --use 'okok' for okokNotify
        --use 'mythic' for myhthic_notify
        --use 'boii' for boii_ui notify
        --use 'ox' for -x_lib notify
        Sound = true, -- use sound for OKOK notifications ONLY
        Length = {
            Success = 2500,
            Error = 2500,
            Primary = 2500,
        },
    },
    Inventory = { -- support for qb-inventory and ox_inventory
        Type = 'qb',
        --use 'qb' for qb-inventory
        --use 'ox' for ox_inventory
    },
    ProgressBar = {
		PickPeyotePlants = 7000, -- time it takes to pick peyote plants
		TakePeyotePlants = 3500, -- time it takes to eat peyote plants
    },
    Props = {
        PeyotePlants = { Name = 'prop_peyote_water_01', TargetItemName = 'shovel', TargetDistance = 4.0, TargetIcon = 'fa-solid fa-hand-point-up', TargetLabel = 'Pick Peyote Plants', },
    },    
}


Config.Blips = {
    {title = 'Peyote Plants', colour = 5, id = 66, coords = vector3(1670.74, 4498.81, 33.18), scale = 0.6, useblip = true,}, -- BLIP FOR PEYOTE PLANTS
}


Config.InteractionLocations = { 
    -- coords is peyote plants location -- name is name -- radius is size of zone -- plants is amount of plants that spawn -- chance is chance to find 'peyoteplants' when picking peyote
	PeyotePlants = {coords = vector3(1670.74, 4498.81, 33.18), name = ('Peyote Plants'), radius = 45.0, plants = 15, chance = 5,},
}


-- XP settings
Config.XP = { -- use xp when picking peyote
    Enabled = true, -- Toggles xp system on or off; true = on, false = off
    Command = true, -- Toggles commands on or off use /drugxp or whatever you have named the metadata
    MetaDataName = 'peyotexp', -- The name of your xp if you edit this make sure to also edit the line you added into qb-core/server/player.lua
    Levels = { -- Change your xp requirements here to suit your server set these as high as you want preset xp increase = (xp / 0.8) if changing amounts dont forget to edit server file also where peyoteplants is given to match new xp amounts
        150, -- level 2 
        250, -- level 3 
        500, -- level 4
        750, -- level 5
        1000, -- level 6
        1250, -- level 6
        1500, -- level 7
        1750, -- level 8
        2000, -- level 9
        2500, -- level 10  
    }
}


Config.MiniGameSettings = {
    Type = 'prog', -- type of minigame when picking peyote plants
    --use 'prog' for default progressbar -- MAKE SURE TO EDIT CONFIG.CORESETTINGS.PROGRESSBAR TIMERS TO SUIT YOUR SERVER IF USING PROGRESSBAR
    --use 'ox' for ox_lib skill check
   
    SkillCheckSettings = { -- ox lib settings
        Difficulty = 'easy', -- difficulty level of skill check
        AreaSize = 75, -- area size you have to press the required input
        SpeedMultiplier = 0.5, -- speed of the skill check each pass
        Keys = {'1', '2', '3', '4'}, -- input keys used for skill check
    },    
}


Config.Animations = { -- change animations below for various tasks
    PickPeyotePlants = {
        AnimDict = 'random@burial',
        Anim = 'a_burial',
        Flags = 41,
        Prop = "prop_tool_shovel",
    },
    TakeDrugs = {
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 49,
        Prop = 'prop_peyote_gold_01',
    },
}


Config.Language = {
	Notifications = { PickedPeyotePlants = 'You Picked Some Peyote!', EarnedXpLabel = 'XP Earned!', EarnedXpName = 'You Earned Some XP!', CancelledLabel = 'Action Cancelled!', CancelledName = 'Cancelled', NothingFoundLabel = 'Damaged Plant!', NothingFoundName = 'This Plant Was Damaged, Try Another!', CantCarryLabel = 'No Space!', CantCarryName = 'You Cant Carry That Much!', NoItemsLabel = 'Missing Items!', NoItemsName = 'You Need A Shovel To Dig Up The Peyote Plants!', },
	ProgressBar = { PickPeyotePlants = 'Picking Peyote', TakePeyotePlants = 'Eating Peyote', },	
}