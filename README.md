## Lusty94_Peyote


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

PLEASE MAKE SURE TO READ THIS ENTIRE FILE AS IT COVERS SOME IMPORTANT INFORMATION

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


A peyote plant picking script where players pick peyote plants and consume them for visual effects and transform into an animal for a short period of time
with an in built xp system which allows players to gain more items when picking plants if a high enough level


- Multiple types of notification support [qb-notify, okokNotify, mythic_notify, boii_ui notify & ox_lib notify]
- Support for qb-target & ox_target
- Suport for qb-inventory and ox_inventory

- Extensive config file
- Change core settings to suit your server such as progressbar timers, notify lengths, event names and much more
- Language settings for custom translations




## INSTALLATION

- Add the ##ITEMS snippet below into your core/shared/items.lua file
- Add all .png images inside [images] folder into your inventory/html/images folder
- Add your own method of obtaining the required item to target plants 'shovel' - perhaps add it to your hardware store?




## XP & OVERDOSE METADATA
If you are using the inbuilt XP and Overdose system then you must add the metadata lines below to your player.lua file in core

- Insert the following lines around `LINE:90` do not forget to edit this if you have changed your `MetaDataName` inside `config.lua`

PlayerData.metadata['peyotexp'] = PlayerData.metadata['peyotexp'] or 0 -- Added for lusty94_peyote




## DEPENDENCIES

- QB-CORE - https://github.com/qbcore-framework/qb-core
- QB-TARGET - https://github.com/qbcore-framework/qb-target
- QB-INVENTORY - https://github.com/qbcore-framework/qb-inventory
- PROGRESSBAR - https://github.com/qbcore-framework/progressbar

- OX_LIB - https://github.com/overextended/ox_lib/releases/tag/v3.10.1





## ITEMS

```

	['peyoteplants'] 			 	 = {['name'] = 'peyoteplants', 			  	['label'] = 'Peyote Plants', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'peyoteplants.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	
	['shovel'] 			 	         = {['name'] = 'shovel', 			  	    ['label'] = 'Shovel', 			        ['weight'] = 100, 		['type'] = 'item', 		['image'] = 'shovel.png', 		        ['unique'] = true, 		    ['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
		


```


