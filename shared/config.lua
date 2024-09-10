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


Config.CoreSettings = {
    EventNames = {
        Evidence = 'evidence:client:SetStatus', -- name of evidence event to set widepupils status when taking peyote plants
    },
    Notify = {
        Type = 'qb', -- notification type, support for qb-core notify, okokNotify, mythic_notify, boii_ui notify and ox_lib notify
        --use 'qb' for default qb-core notify
        --use 'okok' for okokNotify
        --use 'mythic' for myhthic_notify
        --use 'boii' for boii_ui notify
        --use 'ox' for -x_lib notify
    },     
    Target = {
        Type = 'qb', -- target script name support for qb-target and ox_target        
        --use 'qb' for qb-target
        --use 'ox' for ox_target 
    },
    Inventory = { -- support for qb-inventory and ox_inventory
        Type = 'qb',
        --use 'qb' for qb-inventory
        --use 'ox' for ox_inventory
    }, 
    Clothing = {
        Type = 'qb', -- target script name support for qb-clolthing and illenium-appearance       
        --use 'qb' for qb-clothing
        --use 'illenium' for illenium-appearance  
    },
}


Config.Blips = {
    {
        title = 'Peyote Plants', 
        colour = 5, 
        id = 66, 
        coords = vector3(1670.74, 4498.81, 33.18), 
        scale = 0.8, 
        useblip = true,
    },
}


Config.InteractionLocations = { 
    --item is required item, label is target label, icon is target icon, coords is object location, distance is max target distance
	PeyotePlants = {
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1670.74, 4498.81, 33.18), distance = 1.5, },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1651.38, 4508.7, 34.34),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1652.2, 4517.98, 36.35),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1660.02, 4518.44, 36.48), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1650.16, 4494.63, 31.69), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1638.81, 4501.72, 31.87), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1635.64, 4513.91, 34.49), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1643.79, 4522.15, 37.16), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1650.99, 4527.03, 38.34), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1662.31, 4533.42, 39.09), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1674.4, 4528.01, 37.58),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1687.37, 4524.68, 36.33), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1692.28, 4517.04, 34.85), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1704.49, 4511.42, 33.34), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1703.63, 4495.55, 31.99), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1694.13, 4485.0, 31.65),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1678.84, 4484.49, 31.65), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1665.33, 4486.44, 31.57), distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1647.3, 4493.07, 31.31),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1655.96, 4499.62, 32.8),  distance = 1.5,  },
        { item = 'shovel', label = 'Pick Peyote Plants', icon = 'fa-solid fa-hand-point-up', coords = vector3(1682.72, 4504.22, 33.67), distance = 1.5,  },
    },
}


-- XP settings
Config.XP = { -- use xp when picking peyote
    Enabled = false, -- Toggles xp system on or off; true = on, false = off
    Command = false, -- Toggles commands on or off use /drugxp or whatever you have named the metadata
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





Config.Animations = { -- change animations below for various tasks
    PickPeyotePlants = {
        AnimDict = 'random@burial',
        Anim = 'a_burial',
        Flags = 41,
        Prop = "prop_tool_shovel",
        Bone = 28422,
        Pos = vec3(0.0, 0.0, 0.24),
        Rot = vec3(0, 0, 0.0),
    },
    ConsumePeyote = {
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 49,
        Prop = 'prop_peyote_gold_01',
        Bone = 18905,
        Pos = vec3(0.15, 0.0, 0.0),
        Rot = vec3(-190.0, 0.0, 0.0),
    },
}
