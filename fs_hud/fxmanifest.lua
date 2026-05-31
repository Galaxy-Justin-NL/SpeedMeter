fx_version 'cerulean'
game 'gta5'

description 'Custom Minimalistic HUD'
version '1.0.0'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/seat-belt.png' -- Zorg dat je een icoontje in deze map zet
}

client_scripts {
    'client.lua'
}