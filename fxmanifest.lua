fx_version 'cerulean'
game 'gta5'

author 'TheStoicBear'
description 'StoicMDT-Tickets'
version '1.0.0'
lua54 'yes'
ui_page 'ui/index.html'

shared_scripts {
    'config.lua',
    "@ND_Core/init.lua",
    '@ox_lib/init.lua',
}
client_scripts {
    'src/ticket_ui.lua',
    'src/ticket.lua'
}

server_scripts {
    'src/ticekt_s.lua'
}

files {
    'ui/index.html',
}

