WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallGameFont = love.graphics.newFont('Early_GameBoy.ttf', 8)
    largeGameFont = love.graphics.newFont('Early_GameBoy.ttf', 20)

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT-40

    push: setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT-20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT-20, player2Y + PADDLE_SPEED * dt)
    end
end


function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(30/255, 45/255, 60/255, 255/255)

    love.graphics.setFont(smallGameFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(largeGameFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH /2+30, VIRTUAL_HEIGHT/3)

    -- the ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-3, VIRTUAL_HEIGHT/2-3, 6, 6)
    --left paddle
    love.graphics.rectangle('fill', 10, player1Y, 6, 20)
    -- right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10, player2Y, 6, 20)
    push:apply('end')
end