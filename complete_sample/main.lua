-- Global Variables
CELL_SIZE = 15

-- Function to initialize screen and variables
function love.load()
    -- Screen width (in 'cells')
    gridXCount = 40;
    -- Screen height (in 'cells')
    gridYCount = 25;

    -- Finds midpoints for x and y
    local middle_x = gridXCount * CELL_SIZE / 2 ;
    local middle_y = gridYCount * CELL_SIZE / 2;
    
    -- Setting up the graphics window
    love.window.setMode(gridXCount * CELL_SIZE, gridYCount * CELL_SIZE);
    love.window.setTitle("Finished Sample Game");

    -- Setting up random seed based on current time:
    math.randomseed(os.time());

    -- Starting X and Y positions
    boxX, boxY = middle_x - CELL_SIZE / 2, middle_y - CELL_SIZE / 2;

    -- Random starting velocities:
    dx, dy = math.random(200), math.random(200);
    if math.random() > .5 then
        dx = -dx;
    end
    if math.random() > .5 then
        dy = -dy;
    end

    -- Keep track of whether or not the square is moving:
    isMoving = true;

end

-- Function to update variables/screen periodically
function love.update(dt)
    -- If we hit the left wall or right wall, change dx direction
    if boxX < 0 or boxX > gridXCount * CELL_SIZE - CELL_SIZE then
        dx = -1.1 * dx;
    end

    -- If we hit the top or bottom wall, change dy direction
    if boxY < 0 or boxY > gridYCount * CELL_SIZE - CELL_SIZE then
        dy = -1.1 * dy;
    end

    -- Change position of square if currently moving
    if isMoving then
        boxX = boxX + dx * dt;
        boxY = boxY + dy * dt;
    end
end

-- Function to display items on screen
function love.draw()
    love.graphics.setColor(1, 1, 1)

    -- draws square in the middle of the screen
    love.graphics.rectangle('fill', boxX, boxY, CELL_SIZE, CELL_SIZE);
end

function love.keypressed(key) 
    -- Checks which key was pressed, and adjust dx, dy accordingly
    if key == "space" then
        isMoving = not isMoving;
    elseif key == "right" then
        dx = dx + 20;
    elseif key == "left" then
        dx = dx - 20
    elseif key == "up" then
        dy = dy - 20;
    elseif key == "down" then
        dy = dy + 20
    end
end
