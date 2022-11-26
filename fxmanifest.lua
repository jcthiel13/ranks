fx_version 'cerulean'
game 'gta5'

author 'xXxTHE LAWxXx97'
description 'A resource for asigning players ranks. Requires NAT2K15 framework.'
version '0.0.1'

server_scripts {
    'server/**.lua',
    '@mysql-async/lib/MySQL.lua',
}

client_scripts {
    'client/**.lua',
}

shared_scripts {
    'config.lua'
}

dependencies {
    'framework',
}