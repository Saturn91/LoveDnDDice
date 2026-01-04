Dice = require("Dice")

local testDices = {
    "2d6",
    "d20",
    "3d8+5",
    "4d10-2",
    "d12+1",
    "5d4",
    "2d6 + 3",  -- with spaces
    "d6-1",     -- single die with modifier
    "3d0",      -- invalid dice size
}

function love.load()
    -- Load your main module or game here
    print("Welcome to the Dice Roller!")

    for _, dice in ipairs(testDices) do
        local result = Dice.roll(dice)
        if result then
            for i = 1, 10 do
                print("Rolling " .. dice .. ": " .. Dice.roll(dice))
            end
        else
            print("Rolling " .. dice .. ": Invalid formula")
        end
    end
end