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
}

function love.load()
    -- Load your main module or game here
    print("Welcome to the Dice Roller!")

    print("\n=== Normal Rolls ===")
    for _, dice in ipairs(testDices) do
        local result = Dice.roll(dice)
        if result then
            print("Rolling " .. dice .. ": " .. result)
        else
            print("Rolling " .. dice .. ": Invalid formula")
        end
    end

    print("\n=== Advantage/Disadvantage Rolls ===")
    print("d20 with advantage: " .. Dice.roll("d20", {advantage = true}))
    print("d20 with disadvantage: " .. Dice.roll("d20", {disadvantage = true}))
    print("d20 with both (cancel out): " .. Dice.roll("d20", {advantage = true, disadvantage = true}))
    
    print("\n=== Multiple Rolls with Advantage ===")
    for i = 1, 5 do
        print("Attack roll (d20+5) with advantage: " .. (Dice.roll("d20", {advantage = true}) + 5))
    end
end