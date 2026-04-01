fx_version 'cerulean'
game 'gta5'

author 'DOTINIT SCRIPTS'
description 'Multifarming Script for ESX-Legacy | ox_target | ox_inventory'
version '1.1.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
    'config/shops.lua',
    'config/processing.lua',
    'config/apple.lua',
    'config/blueberry.lua',
    'config/grapes.lua',
    'config/lemon.lua',
    'config/orange.lua',
    'config/pumpkin.lua',
    'config/strawberry.lua',
    'config/tomato.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    'server/webhook.lua',
}

escrow_ignore {
    'config/*.lua',
    'server/webhook.lua',
}

dependency 'ox_lib'
dependency 'es_extended'
dependency '/assetpacks'