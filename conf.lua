local conf = {
	name 		= "The bois",
	version = "0.10.1",
	icon 		= nil,
	debug 	=	true,

	dimensions = {800, 600},
	fullscreen = false,
	borderless = false,
	resizable  = true,
	vsync 		 =	true,
	msaa 			 = 0,

	modules = {
		audio = true,
		sound =	true,
		image = true,
		math  = true,
		mouse =	true,

		keyboard = true,
		event 	 = true,
		joystick = true,
		physics  = true,
		system   = true,
		timer    = true,
		thread 	 = true,
		graphics = true,
		window   = true,
	},
}

function love.conf(t)
	t.identity = conf.name
	t.version  = conf.version
	t.console  = conf.debug

	t.window.title          = conf.name
	t.window.icon           = conf.icon
	t.window.width          = conf.dimensions[1]
	t.window.height         = conf.dimensions[2]
	t.window.borderless     = conf.borderless
	t.window.resizable      = conf.resizable
	t.window.fullscreen     = conf.fullscreen
	t.window.fullscreentype = "exclusive"
	t.window.vsync          = conf.vsync
	t.window.msaa           = conf.msaa
  t.window.display        = 1
  t.window.highdpi        = false
  t.window.srgb           = false
  t.window.minwidth       = conf.dimensions[1] / 3
  t.window.minheight      = conf.dimensions[2] / 3

	for module, state in pairs(conf.modules) do
		t.modules[module] = state
	end
end
