-- Global Variables
CELL_SIZE = 15

-- Function to initialize screen and variables
function love.load()
    -- Screen width (in 'cells')
    gridXCount = 40;
    -- Screen height (in 'cells')
    gridYCount = 25;

    -- Setting up the graphics window
    love.window.setMode(gridXCount * CELL_SIZE, gridYCount * CELL_SIZE);
    love.window.setTitle("Sample Game");

    -- Setting up random seed based on current time:
    math.randomseed(os.time())

    boxX = gridXCount * CELL_SIZE / 2 - 10;
    boxY = gridYCount * CELL_SIZE / 2 - 10;

    dx = math.random(-200, 200);
    dy = math.random(-200, 200);

    playing = true;
end

-- Function to update variables/screen periodically
function love.update(dt)
    if boxX < 0 then
        dx = -dx
    end

    if boxY < 0 then
        dy = -dy
    end

    if boxX > gridXCount * CELL_SIZE - 20 then
        dx = -dx
    end

    if boxY > gridYCount * CELL_SIZE - 20 then
        dy = -dy
    end

    if playing then
        boxX = boxX + dx * dt;
        boxY = boxY + dy * dt;
    end

end

-- Function to display items on screen
function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', boxX, boxY, 20, 20)
end

function love.keypressed(key)
    if key == 'space' then
        playing = not playing;
    end

    if key == 'right' then
        dx = dx + 10
    elseif key == 'left' then
        dx = dx - 10
    elseif key == 'up' then
        dy = dy + 10
    elseif key == 'down' then
        dy = dy - 10
    end

end