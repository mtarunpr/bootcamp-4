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
end

-- Function to update variables/screen periodically
function love.update(dt)
--TODO
end

-- Function to display items on screen
function love.draw()
--TODO
end
