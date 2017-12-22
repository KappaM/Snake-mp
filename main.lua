local TLfres = require "tlfres"
--require "game"
require "menu"
--require "options"
--require "difficulty"
--require "players"
require "snake"


gfx = love.graphics

debug = false -- Toggles debug mode

state = "splash"

logoY = 0
logoDirection = 1
logoYFinal = 255
logoA = logoY

fadeColorAlpha = 0
fadeColor = {0,0,0}
fadingColor = true
fadeTime = 1

bgColors = {{0,0,0},{205,37,144},{37,183,205},{78,191,43},{0xff, 0x66, 0x00}} -- Possible background colors
bgColorIndex = 1 -- Currently selected background color
bgColorDelay = 10 -- Delay between automoatic change of background color
bgColorINT = 0	-- Current state of automatic color change
autoBackground = false -- Toggles automatic change of background color
pauseAutoBg = false -- Pauses automatic change of background color

WinWidth = gfx.getWidth()
WinHeight = gfx.getHeight()

blockSize = 20
blockSpacing = 1
totalBlocksX = 37
totalBlocksY = 27

lvlPopY = 200 -- Position of level popup on Y-axis
lvlPopYD = 150 -- Next position of level popup on Y-axis
lvlPopA = 255 -- Alpha of level popup
lvlPopAD = 255 -- Next alpha of level popup
showLvlPop = 0

score = 0

	function love.load()

		-- Images
		main_bg = gfx.newImage("image/grid.png")
		main_logo = gfx.newImage("image/logo.png")
		block_glow = gfx.newImage("image/block_glow.png")
		game_over = gfx.newImage("image/gameover.png") 

		-- Fonts
		menuFont = gfx.newFont("font/font.ttf", 20)
		lvlFont = gfx.newFont("font/font.ttf", 40)
		defaultFont = gfx.newFont(12)

		-- Audio
    music1OGG = love.audio.newSource("audio/music1.ogg", "stream")
		startOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		selectOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		nextOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		hitOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		collectOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		pauseOGG = love.audio.newSource("audio/sound1.ogg", "stream")
		unPauseOGG = love.audio.newSource("audio/sound1.ogg", "stream")
    hitOGG:setVolume(0.6)
    collectOGG:setVolume(0.6)
    pauseOGG:setVolume(0.6)
    unPauseOGG:setVolume(0.6)
		startOGG:setVolume(0.6)
		selectOGG:setVolume(0.6)
		nextOGG:setVolume(0.6)

		-- Misc. settings
		love.mouse.setVisible(false) -- Makes mouse cursor invisible in game window
		gfx.setBackgroundColor(0,0,0)
		logoY = -70
		logoYFinal = 255

		-- Main menu
		menu.load(WinWidth/2-100, WinHeight/2+50.5, 200, 33, 8, 10, "left")
		menu.addItem("Start")
    menu.addItem("Players")
		menu.addItem("Difficulty")
    menu.addItem("Options")
		menu.addItem("Quit")

		menu.setItemColors({0,0,0,0},{255,255,255,255})
		menu.setSelectedColors({0,0,0,125},{255,255,255})

		love.audio.play(startOGG)
		
		fadeBgColor(bgColors[math.random(#bgColors)])
	end

	function love.update(dt)

		-- Fades logo
		if logoY * logoDirection < logoYFinal * logoDirection then
			logoY = logoY + 500 * dt * logoDirection
		else
			logoY = logoYFinal
		end

		if logoY < 0 then logoA = 0 else logoA = logoY end


		-- Background color of fading logo
		if fadingColor then
			if fadeColorAlpha == 255 then
				gfx.setBackgroundColor(fadeColor)
				fadeColorAlpha = 0
				fadingColor = false

			else
				fadeColorAlpha = fadeColorAlpha + (255 / fadeTime) * dt
				if fadeColorAlpha > 255 then fadeColorAlpha = 255 end
			end
			fadeColor = {fadeColor[1],fadeColor[2],fadeColor[3],fadeColorAlpha}
		end
		
		-- Automatic background change
		if autoBackground and not pauseAutoBg then
			if bgColorINT > bgColorDelay then
				bgColorINT = 0
				if bgColorIndex == #bgColors then
					bgColorIndex = 1
				else
					bgColorIndex = bgColorIndex + 1
				end
				fadeBgColor(bgColors[bgColorIndex])
			else
				bgColorINT = bgColorINT + 1 * dt
			end
		end
		
		
		if state == "splash" or state =="gameover" then
			menu.update(dt)
      love.audio.stop(music1OGG)

  elseif state == "game"  then
      love.audio.play(music1OGG)
			snake.move(dt)
			food.update(dt)
			
			-- Level popup
			if showLvlPop > 1 and showLvlPop <= 2 then
				
				showLvlPop = showLvlPop + 1 * dt
				
				-- Moves level popup
				if lvlPopY ~= lvlPopYD then
					lvlPopY = lvlPopY - 150 * dt
					if lvlPopY < lvlPopYD then lvlPopY = lvlPopYD end
				end
				
				-- Fades level popup
				if lvlPopA ~= lvlPopAD then
					lvlPopA = lvlPopA + 550 * dt
					if lvlPopA > lvlPopAD then lvlPopA = lvlPopAD end
				end
				
			elseif showLvlPop >= 2 and showLvlPop < 3 then
				
				
				lvlPopYD = 0
				lvlPopY = 150
				lvlPopA = 255
				lvlPopAD = 0
				showLvlPop = 3
				
				
			elseif showLvlPop >= 3 and showLvlPop < 4 then
			
				showLvlPop = showLvlPop + .1 * dt
			
				-- Moves level popup
				if lvlPopY ~= lvlPopYD then
					lvlPopY = lvlPopY - 150 * dt
					if lvlPopY < lvlPopYD then lvlPopY = lvlPopYD end
				end
				
				-- Fades level popup
				if lvlPopA ~= lvlPopAD then
					lvlPopA = lvlPopA - 550 * dt
					if lvlPopA < lvlPopAD then lvlPopA = lvlPopAD end
				end
				
			elseif showLvlPop >= 4 then
				showLvlPop = 0
			end

		elseif state == "paused" then



		elseif state == "gameover" then
		

		
		end

	end
	

	function fadeBgColor(color)
		fadeColor = color
		fadeColorAlpha = 0
		fadingColor = true
	end
	
	function gameStart()
		
		bgColorINT = 0
		logoYFinal = 0
		logoDirection = -1
		state = "game"
		score = 0

		bgColorIndex = 1
		fadeBgColor({0,0,0})
		
		snake.setup()
	end
	
	function drawScore()
	
		if state == "gameover" then
			--Score
			gfx.setFont(lvlFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Score: " ..tostring(score * 1) .. " - Level: " ..tostring(multiplyer), 10, 256, WinWidth-20, "center")
			gfx.setColor(255,255,255)
			gfx.printf("Score: " ..tostring(score * 1) .. " - Level: " ..tostring(multiplyer), 8, 254, WinWidth-19, "center")
			
		else
			-- Score
			gfx.setFont(menuFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Score: " ..tostring(score * 1), 10, 6, WinWidth-20, "left")
			gfx.setColor(255,255,255)
			gfx.printf("Score: " ..tostring(score * 1), 8, 4, WinWidth-16, "left")
			
			-- Level
			gfx.setColor(0,0,0,100)
			gfx.printf("Level: " ..tostring(multiplyer), 10, 6, WinWidth-18, "right")
			gfx.setColor(255,255,255)
			gfx.printf("Level: " ..tostring(multiplyer), 8, 4, WinWidth-18, "right")
		end
		
		
		
		-- Draws level popup
		if showLvlPop > 0 then
			gfx.setFont(lvlFont)
			a1 = 0
			if lvlPopA - 155 > 0 then a1 = lvlPopA - 155 end
			gfx.setColor(0,0,0, a1)
			gfx.printf("Level " ..tostring(multiplyer), 1, lvlPopY + 1, WinWidth+1, "center")
			gfx.setColor(255,255,255,lvlPopA)
			gfx.printf("Level " ..tostring(multiplyer), -1, lvlPopY - 1, WinWidth-1, "center")
		end

	end
	
	function drawBlock(x, y, color)
		
		gfx.setColor(color[4],color[4],color[4])
		
		love.graphics.setBlendMode("alpha")
		gfx.draw(block_glow, blockSize * x + (blockSpacing * x) + block_glow:getWidth() / 2 - 13, blockSize * y + (blockSpacing * y) + block_glow:getWidth() / 2 - 13, 0,1, 1, block_glow:getWidth() / 2, block_glow:getWidth() / 2)
		love.graphics.setBlendMode("alpha")
		gfx.setColor(color)
		gfx.rectangle("fill", blockSize * x + (blockSpacing * x), blockSize * y+ (blockSpacing * y), blockSize, blockSize)
		
    
	end

	function love.draw()
    
    TLfres.beginRendering(797, 586)
		
		
		if fadeColorAlpha > 5 and fadingColor then
			gfx.setColor(fadeColor)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
		end

		-- Draws grid in background
		
		gfx.setColor(255,255,255)
		gfx.draw(main_bg,0,0)
		

		if state == "splash" then

			gfx.setFont(menuFont)
			menu.draw()

		elseif state == "game" then

			-- Draws gameplay items
			snake.draw()
			food.draw()
			drawScore()

		elseif state == "paused" then

			--Draws snake underneath pause screen
			snake.draw()
			food.draw()
			drawScore()
			
			-- Draws pause screen background
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
			
			-- Draws pause screen text
			gfx.setFont(lvlFont)
			gfx.setColor(0,0,0,100)
			gfx.printf("Game Paused", 1, WinHeight/2-8, WinWidth, "center")
			gfx.setColor(255,255,255)
			gfx.printf("Game Paused", -1, WinHeight/2-10, WinWidth, "center")

		elseif state == "gameover" then
			
			
			snake.draw()
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,0,WinWidth,WinHeight)
			drawScore()
			gfx.setColor(255,255,255)
			gfx.draw(game_over, WinWidth/2 - game_over:getWidth()/2,  200)
			
			gfx.setFont(menuFont)
			menu.draw()
		end
		
		-- Draws logo
		gfx.setColor(255,255,255,logoA)
		gfx.draw(main_logo, WinWidth/2-main_logo:getWidth()/2 +.5, 188,0)


		if debug then
			gfx.setFont(defaultFont)
			gfx.setColor(0,0,0,100)
			gfx.rectangle("fill",0,WinHeight-40,WinWidth,40)
			gfx.setColor(255,255,255)
			-- left aligned
			gfx.print("FPS: "..tostring(love.timer.getFPS()), 10, WinHeight-20)
			gfx.print("Game State: "..state, 10, WinHeight-35)
		end

TLfres.endRendering()

	end

	function love.keypressed(key)
		if key == "`" then
			debug = not debug
			love.mouse.setVisible(debug)
		end

		-- Toggles pause screen, only in game
		if state == "game" then
		
			if key == "pause" or key == "p" or key == "space" or key == "return" or key == "escape" then
				state = "paused"
				pauseAutoBg = true
				love.audio.play(pauseOGG)
        love.audio.stop(music1OGG)
				love.mouse.setVisible(true)
			end
			
			if key == "up" and snake.direction ~= "s" then
				
				snake.changeDir("n")
				
			elseif key == "down" and snake.direction ~= "n" then
				
				snake.changeDir("s")
				
			elseif key == "left" and snake.direction ~= "e" then
				
				snake.changeDir("w")
				
			elseif key == "right" and snake.direction ~= "w" then
				
				snake.changeDir("e")
				
			end
			
			
		elseif state =="splash" or state =="gameover" then
		
			if key == "up" then
				menu.up()
				love.audio.play(nextOGG)
			elseif key == "down" then
				menu.down()
				love.audio.play(nextOGG)
			elseif key == "return" then

				love.audio.play(selectOGG)
				love.timer.sleep(.2)
				
				if menu.selected == 1 then
				
					gameStart()
					
				elseif menu.selected == 2 then

					
				
        elseif menu.selected == 3 then
        
        
        
        elseif menu.selected == 4 then
        
        
        
        elseif menu.selected == 5 then
        
          love.event.quit()
				
					
				end
			end
			
		elseif state == "paused" then
			if key == "pause" or key == "p" or key == "space" or key == "return" or key == "escape" then
				state = "game"
				pauseAutoBg = false
				love.audio.play(unPauseOGG)
				love.mouse.setVisible(false)
			end
		end

		-- Debug mode
		if debug then
			if key == "1" then
				fadeBgColor(bgColors[1])
			elseif key == "2" then
				fadeBgColor(bgColors[2])
			elseif key == "3" then
				fadeBgColor(bgColors[3])
			elseif key == "4" then
				fadeBgColor(bgColors[4])
			elseif key == "5" then
				fadeBgColor(bgColors[5])
			end
		end
	end