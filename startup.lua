--[[
    Author: iikk_a (https://github.com/iikk-a/)
    Latest Edit: 20.01.2021

    This code is absolutely not perfect, but it should be usable.
    No bugs have been found as of late. If you find a bug with this code,
    please leave an issue ticket on GitHub, so I can get to fixing it.

    Start up the application and select ores you want to track by clicking
    on them with your mouse cursor. You can deselect ores by clicking them again.

    If you have old tracers stuck mid air, just start this application again
    without picking ores and quit to clear the old tracers.

    Thank you.
]]--


-- Instantly quits if you don't have a neural interface
local modules = peripheral.find("neuralInterface")
if not modules then error("must have a neural interface", 0) end

-- List so we can display all missing modules at once
local missingModules = {}

-- Checks the existence of necessary modules
if not modules.hasModule("plethora:scanner") then table.insert(missingModules, "Block Scanner") end
if not modules.hasModule("plethora:glasses") then table.insert(missingModules, "Overlay Glasses") end

-- If one or more modules are missing, error out
if (#missingModules > 0) then error("Missing modules:\n - " .. table.concat(missingModules, "\n - "), 0) end

-- Wrap neural link as a peripheral, clear the old canvas and create a new one
local link = peripheral.wrap("back")
link.canvas3d().clear()
local canvas = link.canvas3d().create()

-- How many seconds there are between scans
local TIME_BETWEEN_SCANS = 0

-- Set to true if you want to disable configuration screen and always use all ores
local NO_CONFIGURATION_UI = false

-- The color values used in the background colors, can be found here: http://computercraft.info/wiki/Colors_(API)
-- CHANGE THESE IF YOU HAVE DEUTERANOPIA AND CANNOT EASILY DIFFERENTIATE RED AND GREEN
local COLOR_BLACK = 32768
local COLOR_RED = 16384
local COLOR_GREEN = 32

-- Get screen size to draw UI properly
local x = term.getSize()

-- List of ores that are tracked, will be all if NO_CONFIGURATION_UI is set to true
local ores = {}

-- List of all ores this tracker can track with current settings in current modpack
local completeOreList = {
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:redstone_ore",
    "minecraft:gold_ore",
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:emerald_ore",
    "ic2:resource",
    "appliedenergistics2:quartz_ore",
    "thermalfoundation:ore_fluid"
}

-- This table hold selected ores
local _UI_CONFIG = {}

-- Colors for ore tracers, colors use HEX with alpha, these can be changed
local colors = {
	["minecraft:coal_ore"] = 0x000000ff,
	["minecraft:iron_ore"] = 0xff9632ff,
	["minecraft:redstone_ore"] = 0xff0000ff,
    ["minecraft:gold_ore"] = 0xffff00ff,
	["minecraft:lapis_ore"] = 0x0032ffff,
	["minecraft:diamond_ore"] = 0x00ffffff,
    ["minecraft:emerald_ore"] = 0x00ff00ff,
    ["ic2:resource"] = 0x005a00ff,
    ["appliedenergistics2:quartz_ore"] = 0xe3fcfaff,
    ["thermalfoundation:ore_fluid"] = 0x781725ff
}

-- This function renders a line for all given blocks with given attributes
function renderLines(vectorList)
    -- Clear the 3D canvas so lines don't stack up
    link.canvas3d().clear()

    -- Create a new canvas, since link.canvas3d().clear() dereferences it
    local canvas = link.canvas3d().create()

    -- Loop through all given objects and draw lines to all of them with given thickness and color
    for i = 1, #vectorList, 1 do
        canvas.addLine({ 0, -1, 0 }, { vectorList[i].x, vectorList[i].y, vectorList[i].z }, vectorList[i].thickness, vectorList[i].color)
    end
end

-- Starting UI to select wanted ores
while not NO_CONFIGURATION_UI do
    -- Clear the screen and write ores onto it
    term.setBackgroundColor(COLOR_BLACK)
    term.clear()

    -- Loop through all the available ores to write them to screen in a specific order
    for i = 1, #completeOreList, 1 do
        -- Variable for checking if ore exists in list of selected ores
        local isSelected = false

        -- Move the cursor to the appropriate line
        term.setCursorPos(1, i)

        -- Calculate how many spaces are needed to center the text in the window
        local spaces = string.rep(" ", math.floor((x - (#completeOreList[i] + 2)) / 2))

        -- Make the string to print on the screen
        local str = "[" .. spaces .. completeOreList[i] .. spaces

        if (#str + 1 < x) then str = str .. " ]"
        else str = str .. "]" end

        -- If the ore can be found from the list of selected, make isSelected true, otherwise false
        for j = 1, #_UI_CONFIG, 1 do
            if (_UI_CONFIG[j] == completeOreList[i]) then isSelected = true end
        end

        -- If the ore is selected, make its background green, otherwise background is red
        if (isSelected) then
            term.setBackgroundColor(COLOR_GREEN)
        else
            term.setBackgroundColor(COLOR_RED)
        end

        -- Prints the ore name in the correct position
        print(str)
    end

    -- Set the cursor for second line below the ore block and set the text background to green
    term.setCursorPos(1, #completeOreList + 2)
    term.setBackgroundColor(COLOR_GREEN)

    -- Make string [ Start Application ] and center it on the line
    local str = "Start Application"

    -- This function replicates spaces until we get enough that the text is centered
    local spaces = string.rep(" ", math.floor((x - (#str + 2)) / 2))
    local toPrint = "[" .. spaces .. str .. spaces

    -- If the amount of spaces is one too few, add one to the end
    if (#toPrint + 1 < x) then toPrint = toPrint .. " ]"
    else toPrint = toPrint .. "]" end

    -- Write the new string to the screen and turn the background back to black
    write(toPrint)
    term.setBackgroundColor(COLOR_BLACK)

    -- Check for mouse clicks
    local event, button, x, y = os.pullEvent("mouse_click")

    -- If the mouse click is inside the area designated for ores, then log which ore was clicked
    if (y <= #completeOreList) then
        -- Variable for checking if ore already exists in table
        local isInTable = false
        
        -- Loop through all the selected ores to check if the clicked one is already selected
        for i = 1, #_UI_CONFIG, 1 do
            -- If ore is already selected, make isInTable its index, otherwise it stays false
            if (_UI_CONFIG[i] == completeOreList[y]) then isInTable = i end
        end

        -- If not false (AKA has an index) then remove that index from the table
        -- Otherwise insert value into the table
        if (isInTable ~= false) then
            table.remove(_UI_CONFIG, isInTable)
        else 
            table.insert(_UI_CONFIG, completeOreList[y])
        end
    else
        -- If the mouse click is outside of the ore selection area, then break and start the main application
        break
    end
end


-- Track all ores if NO_CONFIGURATION_UI is true and only selected if false
if (NO_CONFIGURATION_UI) then
    ores = completeOreList
else
    ores = _UI_CONFIG
end

-- Clear the canvas and set background color to black when starting
-- Please ignore this code block, it looks terrible, but making it better is not worth the effort
term.setBackgroundColor(COLOR_BLACK)
canvas.clear()
term.clear()
term.setCursorPos(1,1)
print("Hold CTRL + T to stop execution")
term.setCursorPos(1,2)
print("Hold CTRL + R to reconfigure ores")
term.setCursorPos(1,4)
print("Ores selected: " .. #ores)
term.setCursorPos(1,6)
print("Code running...")


-- Main execution block where ore tracking and rendering happens
while true do
    local oreList = {}
    -- Block scanning
    for _, block in pairs(link.scan()) do
        -- Loop through all the ores that are being tracked
        for i = 1, #ores, 1 do
            -- If a matching ore is found, execute the following code
            if (block.name == ores[i]) then
                -- Create an object with all necessary parameters
                local toAdd = {
                    ["x"] = block.x,
                    ["y"] = block.y,
                    ["z"] = block.z,
                    ["thickness"] = 3.0,
                    ["color"] = colors[block.name]
                }
                -- Insert made object into a table before being sent to the renderer
                table.insert(oreList, toAdd)
            end
        end
    end
    
    -- Render lines with correct colors for all blocks and sleep (if time is set)
    renderLines(oreList)
    os.sleep(TIME_BETWEEN_SCANS)
end