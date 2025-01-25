fx_version 'adamant'
author 'xCoore Development'
description 'Simple Fight Ban System For Fivem ESX'
version '1.0'

server_script '@oxmysql/lib/MySQL.lua'

server_scripts {
    'Server/*.lua',
}

client_scripts {
    'Client/*.lua',
}