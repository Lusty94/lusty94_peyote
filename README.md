## Lusty94_Peyote


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

PLEASE MAKE SURE TO READ THIS ENTIRE FILE AS IT COVERS SOME IMPORTANT INFORMATION

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


A peyote plant picking script where players pick peyote plants and consume them for visual effects and transform into an animal for a short period of time
with an in built xp system which allows players to gain more items when picking plants if a high enough level





## INSTALLATION

- Add the ##ITEMS snippet below into your core/shared/items.lua file
- Add all .png images inside [images] folder into your inventory/html/images folder
- Add your own method of obtaining the required item to target plants 'shovel' - perhaps add it to your hardware store?




## XP & OVERDOSE METADATA
If you are using the inbuilt XP and Overdose system then you must add the metadata lines below to your player.lua file in core

- Insert the following lines around `LINE:100` do not forget to edit this if you have changed your `MetaDataName` inside `config.lua`

PlayerData.metadata['peyotexp'] = PlayerData.metadata['peyotexp'] or 0 -- Added for lusty94_peyote



new qb-core metadata is held in the config file instead for some stupid reason kakarot likes to annoy creators with pointless changes. same for the items list below too




## DEPENDENCIES

- QB-CORE - https://github.com/qbcore-framework/qb-core
- QB-TARGET - https://github.com/qbcore-framework/qb-target
- QB-INVENTORY - https://github.com/qbcore-framework/qb-inventory
- PROGRESSBAR - https://github.com/qbcore-framework/progressbar
- OX_LIB - https://github.com/overextended/ox_lib/releases





## ITEMS

# old qb-core method
```

	['peyoteplants'] 			 	 = {['name'] = 'peyoteplants', 			  	['label'] = 'Peyote Plants', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'peyoteplants.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	
	['shovel'] 			 	         = {['name'] = 'shovel', 			  	    ['label'] = 'Shovel', 			        ['weight'] = 100, 		['type'] = 'item', 		['image'] = 'shovel.png', 		        ['unique'] = true, 		    ['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},		

```

# new qb-core method

```
	peyoteplants 			 	 = {name = 'peyoteplants', 			  	label = 'Peyote Plants', 			weight = 100, 		type = 'item', 		image = 'peyoteplants.png', 		unique = false, 		useable = true, 	shouldClose = true,	   combinable = nil,   description = ''},
		
	shovel 			 	         = {name = 'shovel', 			  	    label = 'Shovel', 			        weight = 100, 		type = 'item', 		image = 'shovel.png', 		        unique = true, 		    useable = true, 	shouldClose = true,	   combinable = nil,   description = ''},
```


