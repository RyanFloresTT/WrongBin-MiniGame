-- Define constants
local GRAVITY = 600
local OBJECT_SIZE = 32
local SPEED_INCREASE = 5
local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 400
local SPAWN_TIME_DECREASE = 2

-- Define global variables
local objects = {}
local player = {x=100, y=325, lives=3, score=0}
local elapsed = 0
local speed = 500
local spawnInterval = 2
local state = "menu"
local startButton = {x=100, y=250, width=200, height=50}
local quitButton = {x=100, y=325, width=200, height=50}
local highscore = 0
local highscoreFile = "highscore.txt"
local playerSprite = love.graphics.newImage("art/player.png")
local objectSprite = love.graphics.newImage("art/paper.png")
local heartSprite = love.graphics.newImage("art/heart.png")
local iconSprite = love.image.newImageData("art/paper.png")
local backgroundImage = love.graphics.newImage("art/office.png")
local titleFont = love.graphics.newFont("fonts/EVILDEAD.ttf", 48)
local menuFont = love.graphics.newFont("fonts/Roboto-Medium.ttf", 24)

function love.load()
    -- Set Icon
    love.window.setIcon(iconSprite)

    -- Set up the player
    player.image = playerSprite
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()

    -- Set up window size
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {resizable = false})

    -- Set up initial score value, and grab file
    if love.filesystem.getInfo(highscoreFile) then
    local content = love.filesystem.read(highscoreFile)
    highscore = tonumber(content)
    end
end

function love.update(dt)
    -- Run Game if in game state
    if state == "game" then
        -- Update the elapsed time
        elapsed = elapsed + dt

        -- Check if it's time to spawn a new object
        if elapsed > spawnInterval then
            elapsed = 0
            if player.score >= 20 and player.score < 30 then
                spawnObject()
                spawnObject()
            elseif player.score >= 30 then
                spawnObject()
                spawnObject()
                spawnObject()
            elseif player.score < 20 then
                spawnObject()
            end
            spawnInterval = spawnInterval * ( 1 - SPAWN_TIME_DECREASE * dt)
        end
        -- Update the player's position based on input
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            player.x = player.x - dt * 200
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            player.x = player.x + dt * 200
        end
        -- Update the position of each object
        for i, object in ipairs(objects) do
            object.y = object.y + dt * speed
            object.x = object.x + dt * object.vx
    
            -- Check if the object has collided with the player
            if checkCollision(object, player) then
                -- Remove the object from the screen
                table.remove(objects, i)

                -- Decrement the player's lives
                player.lives = player.lives - 1

                -- Check if the player is out of lives
                if player.lives == 0 then
                    -- End the game
                    if player.score > highscore then
                        love.filesystem.write(highscoreFile, tostring(math.floor(player.score)))
                    end
                    state = "lost"
                end
            end

            -- Check if the object has reached the left or right edge of the screen
            if object.x < 0 or object.x + OBJECT_SIZE > love.graphics.getWidth() then
                -- Reverse the object's horizontal velocity
                object.vx = -object.vx
            end
            -- Check if player has reached left or right side edge of the screen
            if player.x < 0 then
                player.x = 0
            elseif player.x + player.image:getWidth() > SCREEN_WIDTH then
                player.x = SCREEN_WIDTH - player.image:getWidth()
            end
        end
        -- Increment the score
        player.score = player.score + dt

        -- Increase the speed of the objects
        speed = speed + SPEED_INCREASE * dt
    end
end

function love.draw()
    -- Draw Menu if in menu state 
    if state == "menu" then
        -- Draw the start menu
        love.graphics.setBackgroundColor(163/255, 88/255, 54/255)
        love.graphics.setColor(1, 1, 1)

        -- Set Font and Print Title
        love.graphics.setFont(titleFont)
        love.graphics.print("WRONG BIN!", 50, 50)

        -- Set Font and Print High Score 
        love.graphics.setFont(menuFont)
        love.graphics.print("High Score: " .. highscore, 125, 155)

        -- Create Button Rectangles
        love.graphics.rectangle("fill", startButton.x, startButton.y, startButton.width, startButton.height)
        love.graphics.rectangle("fill", quitButton.x, quitButton.y, quitButton.width, quitButton.height)
        love.graphics.setColor(0, 0, 0)

        -- Create Text for Buttons
        love.graphics.print("Start", startButton.x + 75, startButton.y + 10)
        love.graphics.print("Quit", quitButton.x + 75, quitButton.y + 10)
        love.graphics.setColor(1, 1, 1)

    elseif state == "game" then
        -- Draw background
        love.graphics.draw(backgroundImage, -100, -130, 0, .5, .5)
        -- Draw the player
        love.graphics.draw(player.image, player.x, player.y)

        -- Draw each object
        for _, object in ipairs(objects) do
            love.graphics.draw(object.sprite, object.x, object.y)
        end

        -- Draw the score
        love.graphics.setFont(menuFont)
        love.graphics.print("Score: " .. math.floor(player.score), 150, 10, 0, 1.3, 1.3)
        -- Show Remaining Life Points
        for i=0,player.lives - 1 do
            love.graphics.draw(heartSprite, 5 + heartSprite:getWidth() * i, 10)
        end
    elseif state == "lost" then
        -- Draw the start menu
        love.graphics.setBackgroundColor(163/255, 88/255, 54/255)
        love.graphics.setColor(1, 1, 1)

        -- Set Font and Print Title
        love.graphics.setFont(titleFont)
        love.graphics.print("YOU LOST!", 50, 50)

        -- Set Font and Print High Score 
        love.graphics.setFont(menuFont)
        love.graphics.print("High Score: " .. highscore, 125, 155)
        love.graphics.print("Your Score: " .. math.floor(player.score), 125, 185)

        love.graphics.rectangle("fill", quitButton.x, quitButton.y, quitButton.width, quitButton.height)
        love.graphics.setColor(0, 0, 0)

        love.graphics.print("Quit", quitButton.x + 75, quitButton.y + 10)
        love.graphics.setColor(1, 1, 1)
    end

end

function spawnObject()
    -- Choose a random x position for the object
    local x = math.random(0, love.graphics.getWidth() - OBJECT_SIZE)

    -- Choose a random velocity for the object
    local vx = math.random(-200, 200)

    -- Choose a random size for the object
    local size = 32

    -- Add the object to the objects table
    table.insert(objects, {x=x, y=-size, vx=vx, size=size, sprite=objectSprite})
end


function checkCollision(object, player)
    -- Check if the object and player are colliding
    if object.x < player.x + player.width and
        object.x + OBJECT_SIZE > player.x and
        object.y < player.y + player.height and
        object.y + OBJECT_SIZE > player.y then
        -- The object and player are colliding
            return true
    else
        -- The object and player are not colliding
        return false
    end
end

-- Handles Menu Options
function love.keypressed(key)
    -- If in the menu, you can press enter or escape to navigate the menu
    if state == "menu" then
        if key == "return" then
            state = "game"
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

-- Function handles the click on the button on the main menu.
function love.mousereleased(x, y, button)
    if button == 1 then
        if x > startButton.x and x < startButton.x + startButton.width and y > startButton.y and y < startButton.y + startButton.height then
            state = "game"
        elseif x > quitButton.x and x < quitButton.x + quitButton.width and y > quitButton.y and y < quitButton.y + quitButton.height then
            love.event.quit()
        end
    end
end