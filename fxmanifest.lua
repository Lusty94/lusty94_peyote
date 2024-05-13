fx_version 'cerulean'

game 'gta5'

author 'Lusty94'

name "lusty94_peyote"

description 'Peyote Plants Script For QB Core'

version '1.1.0'

lua54 'yes'

client_script {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/peyote_client.lua',
}


server_scripts { 
    'server/peyote_server.lua',
}


shared_scripts { 
	'shared/config.lua',
    '@ox_lib/init.lua',
}

escrow_ignore {
    'client/**.lua',
    'server/**.lua',
    'shared/**.lua',
}

