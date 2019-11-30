gui = {}

function love.load()
    score = 0;
    bestScore = 0;
    color = 1;

    gameStarted = false;

    gridXCount = 40;
    gridYCount = 25;

    love.window.setMode(40 * 15, 30 * 15);
    love.window.setTitle("Better Snake");

    cellSize = 15;

        snakeSegments = {
            {x = 3, y = 4},
            {x = 2, y = 4},
            {x = 1, y = 4},
        }

        function moveFood()
    local possibleFoodPositions = {}

        for foodX = 1, gridXCount do
            for foodY = 1, gridYCount do
                local possible = true;

                for segmentIndex, segment in ipairs(snakeSegments) do
                    if foodX == segment.x and foodY == segment.y then
                        possible = false;
                    end
                    
                    -- this just makes sure the food random change is on the board and to make sure it doesn't spawn in the snake.
                    
                    if (foodY < 4 or foodY > (30 * 15) - 45) then
                      possible = false;
                      end
                end

                if possible then
                    table.insert(possibleFoodPositions, {x = foodX, y = foodY})
                end
            end
        end

        foodPosition = possibleFoodPositions[love.math.random(1, #possibleFoodPositions)]
    end

    moveFood();

    function reset()
        snakeSegments = {
            {x = 3, y = 4},
            {x = 2, y = 4},
            {x = 1, y = 4},
        }
        
        directionQueue = {'right'} -- the starting movement is right.
        snakeAlive = true;
        timer = 0;
        gui.timer = 0;
        gameTimer = 0;

        if score > bestScore then
            bestScore = score;
        end
        
        score = 0;
        stage = 1;
        color = 1;

        moveFood();       
    end

    reset();
end

function love.update(dt)
    if gameStarted then
        timer = timer + dt;
        
        gameTimer = gameTimer + dt;

        if snakeAlive then
            if (gameTimer >= 1) then
            gui.timer = gui.timer + 1;
            gameTimer = 0;
            end
            
        
            local timerLimit = 0.09 - 0.02 * level; -- snake speed
            if timer >= timerLimit then
                timer = timer - timerLimit;

                if #directionQueue > 1 then
                    table.remove(directionQueue, 1);
                end

                local nextXPosition = snakeSegments[1].x;
                local nextYPosition = snakeSegments[1].y;

                if directionQueue[1] == 'right' then
                    nextXPosition = nextXPosition + 1;
                    if nextXPosition > gridXCount then
                        --table.remove(snakeSegments);
                        snakeAlive = false;
                    end
                    
                elseif directionQueue[1] == 'left' then
                    nextXPosition = nextXPosition - 1;
                    if nextXPosition < 1 then
                        --table.remove(snakeSegments);
                        snakeAlive = false;
                    end
                    
                    -- all this stuff is collision
                    
                elseif directionQueue[1] == 'down' then
                    nextYPosition = nextYPosition + 1;
                    if nextYPosition > (gridYCount + 3) then
                        --table.remove(snakeSegments);
                        snakeAlive = false;
                    end
                    
                elseif directionQueue[1] == 'up' then
                    nextYPosition = nextYPosition - 1;
                    if nextYPosition < 4 then
                        --table.remove(snakeSegments);
                        snakeAlive = false;
                    end
                end

                local canMove = true;

                for segmentIndex, segment in ipairs(snakeSegments) do
                    if segmentIndex ~= #snakeSegments
                    and nextXPosition == segment.x 
                    and nextYPosition == segment.y then -- this stops the player going back on itself
                        canMove = false;
                    end
                end

                if canMove then
                    table.insert(snakeSegments, 1, {x = nextXPosition, y = nextYPosition})

                    if snakeSegments[1].x == foodPosition.x
                    and snakeSegments[1].y == foodPosition.y then
                        moveFood();
                        score = score + color;
                        if score < 10 then
                            stage = 1
                        elseif score < 40 then
                            stage = 2
                        else
                            stage = 3
                        end
                        color = math.random(stage);
                    else
                        table.remove(snakeSegments);
                    end
                else
                    snakeAlive = false;
                end
            end
        elseif timer >= 1.5 then
            reset(); -- when the snake dies, the timer stops. if the timer has stopped for 1.5 seconds, restart the game.
        end
    end
end

function createGameWindow()
  love.graphics.setColor(28/255, 28/255, 28/255);
  love.graphics.rectangle('fill', 0, 45, gridXCount * cellSize , (gridYCount * cellSize)); -- The Game Window
  end

function love.draw()
    local cellSize = 15;

    createGameWindow();

    local function drawCell(x, y)
        love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1); -- draw entity function
    end

    if not gameStarted then
        love.graphics.setColor(1, 1, 1);
        font = love.graphics.newFont(15); -- font size+
        love.graphics.setFont(font);
        xoffset = 250;
        yoffset = 175;
        love.graphics.print("Choose level:", xoffset, yoffset);
        love.graphics.print("1 - Easy", xoffset, yoffset + 20);
        love.graphics.print("2 - Medium", xoffset, yoffset + 40);
        love.graphics.print("3 - Hard", xoffset, yoffset + 60);
    else
        for segmentIndex, segment in ipairs(snakeSegments) do
            if snakeAlive then
                love.graphics.setColor(173/255, 255/255, 47/255); -- snake colour
            else
                love.graphics.setColor(70/255, 70/255, 70/255); -- dead snake colour
            end
            drawCell(segment.x, segment.y); -- draw snake
        end

        if color == 1 then
            love.graphics.setColor(1, 0, 0); -- food colour
        elseif color == 2 then
            love.graphics.setColor(0, 1, 0);
        else
            love.graphics.setColor(0, 0, 1);
        end

        drawCell(foodPosition.x, foodPosition.y);
    end

    drawGUI();
end

function love.keypressed(key)
    if not gameStarted then
        if key == '1' then
            level = 1
            gameStarted = true
        elseif key == '2' then
            level = 2
            gameStarted = true
        elseif key == '3' then
            level = 3
            gameStarted = true
        end
    else
        if (key == "right" or key == "d")
        and directionQueue[#directionQueue] ~= 'right'
        and directionQueue[#directionQueue] ~= 'left' then
            table.insert(directionQueue, 'right')

        elseif (key == "left" or key == "a")
        and directionQueue[#directionQueue] ~= 'left'
        and directionQueue[#directionQueue] ~= 'right' then
            table.insert(directionQueue, 'left')

    -- This is handling key presses.

        elseif (key == "up" or key == "w")
        and directionQueue[#directionQueue] ~= 'up'
        and directionQueue[#directionQueue] ~= 'down' then
            table.insert(directionQueue, 'up')

        elseif (key == "down" or key == "s")
        and directionQueue[#directionQueue] ~= 'down'
        and directionQueue[#directionQueue] ~= 'up' then
            table.insert(directionQueue, 'down')
        end
    end
end

function drawGUI()
  
  love.graphics.setColor(1, 1, 1);
  font = love.graphics.newFont(28);
  love.graphics.setFont(font);
  love.graphics.print("- SNAKE -", 235, 5);
  
  font = love.graphics.newFont(15); -- font size+
  love.graphics.setFont(font);
  
  love.graphics.print("Score: " .. tostring(score), 50, 425);
  love.graphics.print("Timer: " .. tostring(gui.timer), 270, 425);
  love.graphics.print("Best Score: " .. tostring(bestScore), 450, 425);
  
  end
