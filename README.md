## Lusty94_Peyote


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

PLEASE MAKE SURE TO READ THIS ENTIRE FILE AS IT COVERS SOME IMPORTANT INFORMATION

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

======================================
SCRIPT SUPPORT VIA DISCORD: https://discord.gg/BJGFrThmA8
======================================


## FEATURES

- Pick peyote plants and consume them for visual effects and transform into an animal for a short period of time
- In built xp system which allows players to gain more items when picking plants if a high enough level
- Lots of customisation





## INSTALLATION

- Add items below to your core/shared/items.lua - ox_invnetory users place items snippet to inventory/data/items.lua
- Add all images inside [images] folder to your inventory/html/images folder - ox_inventory users place images inside inventory/web/images
- Add your own method of obtaining the required item to target plants 'shovel' - perhaps add it to your hardware store?



## DEPENDENCIES

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [ox_lib]('https://github.com/overextended/ox_lib/releases')




## XP
If you are using the inbuilt XP system then you must add the metadata lines below to your player.lua file in core
- new qb method is via the config but you might need to edit how metadata is assigned in server files

- look for the lines that are similair for the hunger and thirst  and stress or other xp types etc
- do not forget to edit this if you have changed your `MetaDataName` inside `config.lua`


## Old QB-Core

```
    PlayerData.metadata['peyotexp'] = PlayerData.metadata['peyotexp'] or 0 -- Added for lusty94_peyote
```
## New QB-Core

```
    peyotexp = 0,
```








## QB-CORE ITEMS

```

	--peyote
	peyoteplants 			 	 = {name = 'peyoteplants', 			  	label = 'Peyote Plants', 			weight = 100, 		type = 'item', 		image = 'peyoteplants.png', 		unique = false, 		useable = true, 	shouldClose = true,	   combinable = nil,   description = ''},
		
	shovel 			 	         = {name = 'shovel', 			  	    label = 'Shovel', 			        weight = 100, 		type = 'item', 		image = 'shovel.png', 		        unique = true, 		    useable = true, 	shouldClose = true,	   combinable = nil,   description = ''},

```

## OX_INVENTORY ITEMS

```

	["peyoteplants"] = {
		label = "Peyote Plants",
		weight = 200,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "peyoteplants.png",
		}
	},

	["shovel"] = {
		label = "Shovel",
		weight = 200,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "shovel.png",
		}
	},


```