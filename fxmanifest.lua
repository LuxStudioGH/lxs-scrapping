fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'LuxStudio'
description 'Basic scrapping system for FiveM'
version '1.0.0'

shared_scripts {
    'config/cfg_locations.lua',
    'config/cfg_peds.lua',     
    'config/cfg_main.lua'      
}

client_scripts {
    '@ox_lib/init.lua',
    'client/cl_*.lua' 
}

server_scripts {
    'server/sv_utils.lua',
    'server/sv_*.lua'
}