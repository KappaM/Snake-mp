-- Configuration File

function love.conf(t)
    t.title = "Snake"   -- Window title
    t.window.icon = nil
    t.window.width = 797
    t.window.height = 586
    t.author = ""               -- Game author
    t.url = nil                 -- Game website
    t.identity = nil            -- Save directory
    t.version = "0.10.2"        -- Love 2D version
    t.console = false           -- Attach a console
    t.release = false           -- Enable release mode
    t.modules.joystick = true   -- Enable the joystick module
    t.modules.audio = true      -- Enable the audio module
    t.modules.keyboard = true   -- Enable the keyboard module
    t.modules.event = true      -- Enable the event module
    t.modules.image = true      -- Enable the image module
    t.modules.graphics = true   -- Enable the graphics module
    t.modules.timer = true      -- Enable the timer module
    t.modules.mouse = true      -- Enable the mouse module
    t.modules.sound = true      -- Enable the sound module
    t.modules.physics = true    -- Enable the physics module
end