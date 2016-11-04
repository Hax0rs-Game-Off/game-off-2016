function love.conf(t)
    t.title = "MurderHaus"
    t.author = "Haxors"
    t.identity = "IDENTITY"
    t.version = "0.10.2" -- Löve version
    t.console = false
    t.release = false
    t.window.width = 1280
    t.window.height = 720
    t.window.fullwindow = false
    t.window.vsync = true
    t.window.fsaa = 0
	t.window.resizable = true
    t.modules.joystick = false
    t.modules.audio = false
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = false
    t.modules.physics = false
end

