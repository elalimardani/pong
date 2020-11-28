WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    love.window.setTitle('Pong Game - by El')

    --remove fade filter 
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallGameFont = love.graphics.newFont('Early_GameBoy.ttf', 8)
    largeGameFont = love.graphics.newFont('Early_GameBoy.ttf', 12)
    scoreFont = love.graphics.newFont('Early_GameBoy.ttf', 10)
    creditFont = love.graphics.newFont('WONDER.TTF',7)
    --sounds table
    sounds = {
         ['paddle_hit'] = love.audio.newSource('paddle.wav', 'static'),
         ['miss'] = love.audio.newSource('miss.wav', 'static'),
         ['wall'] = love.audio.newSource('wall.wav', 'static')
    }

    player1Score = 0
    player2Score = 0
    
    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    --initialize paddles
    paddle1 = Paddle(0, 20, 5, 20)
    paddle2 =  Paddle(VIRTUAL_WIDTH -5, VIRTUAL_HEIGHT - 30, 5, 20)
    ball=Ball(VIRTUAL_WIDTH/2-3, VIRTUAL_HEIGHT/2-3, 6, 6)


    if servingPlayer ==1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'

    push: setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end



function love.update(dt)
        --ball misses paddle1
        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            sounds['miss']:play()
            ball:restart()
            if player2Score >=3 then
                gameState = 'victory'
                winningPlayer =2
            else
                ball.dx = 100
                gameState = 'serve'
            end
        end

        --ball missespaddle2
        if ball.x > VIRTUAL_WIDTH-6 then
            player1Score = player1Score + 1
            servingPlayer =2 
            sounds['miss']:play()
            ball:restart()
            if player1Score >=3 then
                gameState = 'victory'
                winningPlayer = 1
            else
                ball.dx = -100
                gameState = 'serve'
            end
        end

        --ball hits paddle1
        if ball:collide(paddle1) then
            ball.dx = - ball.dx *1.03
            ball.x = paddle1.x+5
            sounds['paddle_hit']:play()
        end

        --ball hits paddle2
        if ball:collide(paddle2) then
            ball.dx = - ball.dx*1.03
            ball.x = paddle2.x-4
            sounds['paddle_hit']:play()
        end

        --ball bounces off top
        if ball.y <= 0 then
            ball.dy = - ball.dy
            ball.y = 0
            sounds['wall']:play()
        end

        --ball bounce off bottom
        if ball.y >= VIRTUAL_HEIGHT -6 then
            ball.dy = - ball.dy
            ball.y = VIRTUAL_HEIGHT -6
            sounds['wall']:play()
        end


        paddle1:update(dt)
        paddle2:update(dt)

        if love.keyboard.isDown('w') then
            paddle1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        if love.keyboard.isDown('up') then
            paddle2.dy = - PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end

        if gameState == 'play' then
        ball:update(dt)
        end
    end


function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
       if gameState == 'start' then
            gameState = 'serve'
       elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
       elseif gameState == 'serve' then
        gameState = 'play'
        end
    end
end



function love.draw()
    push:apply('start')
    love.graphics.clear(30/255, 45/255, 60/255, 255/255)

    love.graphics.setFont(smallGameFont)

    displayScore()

    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to play", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn", 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to serve", 0, 42, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setColor(1,1,0,1)
        love.graphics.printf("Winner is player " .. tostring(winningPlayer), 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    elseif gameState == 'play' then
        --nothing
    end

    love.graphics.setFont(largeGameFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH /2+30, VIRTUAL_HEIGHT/3)
    paddle1:render()
    paddle2:render()
    ball:render()
    displayFPS()
    displayCredits()
    push:apply('end')
end


function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallGameFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH /2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)
end

function displayCredits()
    love.graphics.setFont(creditFont)
    love.graphics.setColor(1, 122/255, 0,0.6)
    love.graphics.print('El - elCodeLab 2020 ', VIRTUAL_WIDTH /2+70, VIRTUAL_HEIGHT/3+150)
    love.graphics.setColor(1,1,1,1)
end

