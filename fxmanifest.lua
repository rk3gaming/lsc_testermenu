fx_version 'cerulean'
game 'gta5'
lua54 "yes"
author "LSC Development"

shared_scripts {
	'config.lua',
    '@ox_lib/init.lua',
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"config.lua",
	"server.lua",
}

client_scripts {
	"config.lua",
	"client.lua"
}

escrow_ignore {
    "config.lua",
}