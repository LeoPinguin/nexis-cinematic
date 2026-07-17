fx_version 'cerulean'
game 'gta5'

description 'Cinematic Video Player - Standalone / https://discord.gg/jpeSt659Du'
version '1.0.0'
author 'Nexis Scripts / leo_hs'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

client_script 'client.lua'
server_script 'server.lua'