local Dice = {}

-- Parse dice formula and return dice size, dice amount, and constant modifier
-- Returns: diceSize, diceAmount, modifier
function Dice.getDicesFromFormula(diceFormula)
    if not diceFormula then
        return nil, nil, nil
    end
    
    -- Remove spaces from the formula
    diceFormula = string.gsub(diceFormula, "%s", "")
    
    -- Handle modifier (+ or - at the end)
    local modifier = 0
    local modifierPattern = "([%+%-])(%d+)$"
    local modifierMatch = string.match(diceFormula, modifierPattern)
    if modifierMatch then
        local sign, value = string.match(diceFormula, modifierPattern)
        modifier = tonumber(value) or 0
        if sign == "-" then
            modifier = -modifier
        end
        -- Remove modifier from formula
        diceFormula = string.gsub(diceFormula, modifierPattern, "")
    end
    
    -- Parse dice formula (XdY format)
    local numDice, diceSize
    
    -- Check for "dX" format (single die)
    if string.match(diceFormula, "^d%d+$") then
        numDice = 1
        diceSize = tonumber(string.match(diceFormula, "d(%d+)"))
    -- Check for "XdY" format
    elseif string.match(diceFormula, "^%d+d%d+$") then
        numDice, diceSize = string.match(diceFormula, "(%d+)d(%d+)")
        numDice = tonumber(numDice)
        diceSize = tonumber(diceSize)
    else
        -- Invalid format
        return nil, nil, nil
    end
    
    -- Validate parsed values
    if not numDice or not diceSize or numDice <= 0 or diceSize <= 0 then
        return nil, nil, nil
    end
    
    return diceSize, numDice, modifier
end

-- dice formula can be "2d6" "d6" "2d6+3"
-- options can include: advantage (boolean), disadvantage (boolean)
function Dice.roll(diceFormula, options)
    if not Dice.validateFormula(diceFormula) then
        if Log and Log.log then
            Log.log("invalid dice markup " .. (diceFormula or "nil"))
        else
            error("invalid dice markup " .. (diceFormula or "nil"))
        end
        return
    end
    
    options = options or {}
    local hasAdvantage = options.advantage == true
    local hasDisadvantage = options.disadvantage == true
    
    -- Roll once normally, or twice for advantage/disadvantage
    local roll1 = Dice.rollOnce(diceFormula)
    
    if hasAdvantage and not hasDisadvantage then
        -- Advantage: roll twice, take higher
        local roll2 = Dice.rollOnce(diceFormula)
        return math.max(roll1, roll2)
    elseif hasDisadvantage and not hasAdvantage then
        -- Disadvantage: roll twice, take lower
        local roll2 = Dice.rollOnce(diceFormula)
        return math.min(roll1, roll2)
    else
        -- Normal roll (both flags set cancel out, or neither set)
        return roll1
    end
end

-- Internal function to roll dice once without advantage/disadvantage
function Dice.rollOnce(diceFormula)
    -- Parse the dice formula
    local diceSize, numDice, modifier = Dice.getDicesFromFormula(diceFormula)
    
    -- Roll the dice
    local total = 0
    for i = 1, numDice do
        total = total + love.math.random(1, diceSize)
    end
    
    total = total + modifier
    
    return math.max(1, total)
end

function Dice.validateFormula(diceFormula)
    val1, val2 = Dice.getDicesFromFormula(diceFormula)
    return val1 ~= nil and val2 ~= nil
end

return Dice