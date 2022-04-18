fx_version 'adamant'

game 'gta5'

description 'Easter Egg Sunday Special by Ginger Bread'

version '1.0'

ui_page 'html/index.html'

client_scripts {
  'client/client.lua',
  'config.lua'
}

server_scripts{'config.lua','server/server.lua','server/logs.lua'}

files {
	'html/index.html',
	'html/assets/css/style.css',
	'html/assets/js/jquery.js',
	'html/assets/js/init.js',
	'html/assets/css/materialize.min.css',
	'html/assets/js/materialize.js',
	'html/assets/img/banner.png',
}