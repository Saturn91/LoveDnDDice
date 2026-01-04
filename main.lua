Dice = require("Dice")

-- UI variables
local buttons = {
    {label = "Roll 1D20", x = 50, y = 50, width = 150, height = 40, formula = "d20"},
    {label = "Roll 2D4", x = 50, y = 110, width = 150, height = 40, formula = "2d4"},
    {label = "Roll 1D20 with Advantage", x = 50, y = 170, width = 200, height = 40, formula = "d20", advantage = true},
    {label = "Roll 1D20 with Disadvantage", x = 50, y = 230, width = 220, height = 40, formula = "d20", disadvantage = true}
}

local resultHistory = {}
local detailsHistory = {}

function love.draw()
    -- Draw title
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("LoveDnDDice Test Interface", 50, 10)
    love.graphics.print("Click buttons to roll dice!", 50, 25)

    -- Draw buttons
    for _, button in ipairs(buttons) do
        -- Button background
        love.graphics.setColor(0.3, 0.3, 0.8)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        -- Button border
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)

        -- Button text
        love.graphics.setColor(1, 1, 1)
        local textWidth = love.graphics.getFont():getWidth(button.label)
        local textHeight = love.graphics.getFont():getHeight()
        local textX = button.x + (button.width - textWidth) / 2
        local textY = button.y + (button.height - textHeight) / 2
        love.graphics.print(button.label, textX, textY)
    end

    -- Draw results history
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Last 10 Results:", 50, 290)
    
    for i, result in ipairs(resultHistory) do
        local y = 305 + (i - 1) * 15
        
        -- Most recent result in yellow, others in dark gray
        if i == 1 then
            love.graphics.setColor(1, 1, 0)  -- Yellow for most recent
        else
            love.graphics.setColor(0.4, 0.4, 0.4)  -- Dark gray for older results
        end
        
        local resultText = i .. ". " .. result
        if detailsHistory[i] then
            resultText = resultText .. " (" .. detailsHistory[i] .. ")"
        end
        
        love.graphics.print(resultText, 50, y)
    end

    -- Instructions
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Press ESC to quit", 50, 470)
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Left click
        for _, btn in ipairs(buttons) do
            if x >= btn.x and x <= btn.x + btn.width and
               y >= btn.y and y <= btn.y + btn.height then

                -- Roll the dice
                local options = {returnDetails = true}
                if btn.advantage then
                    options.advantage = true
                elseif btn.disadvantage then
                    options.disadvantage = true
                end

                local result, details = Dice.roll(btn.formula, options)

                -- Add to result history (keep last 10)
                table.insert(resultHistory, 1, result)
                if #resultHistory > 10 then
                    table.remove(resultHistory, 11)
                end

                -- Generate details string and add to details history
                local detailsString = nil
                if details then
                    if details.type == "advantage" then
                        detailsString = string.format("Rolls: %d, %d -> took %d (advantage)", 
                                                  details.rolls[1], details.rolls[2], result)
                    elseif details.type == "disadvantage" then
                        detailsString = string.format("Rolls: %d, %d -> took %d (disadvantage)", 
                                                  details.rolls[1], details.rolls[2], result)
                    else
                        detailsString = string.format("Roll: %d", details.rolls[1])
                    end
                end

                table.insert(detailsHistory, 1, detailsString)
                if #detailsHistory > 10 then
                    table.remove(detailsHistory, 11)
                end

                break
            end
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end