-- Load the library from your Main file
local Internal = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/main.lua"))()

-- Create the window
local Win = Internal:CreateWindow()

-- 1. CREDITS
local Credits = Win:CreateTab("Credits")
Credits:CreateHeader({Name = "CREATORS"})
Credits:CreateButton({
    Name = "Discord: Copy Link", 
    Callback = function() setclipboard("discord.gg/yourlink") end
})
Credits:CreateButton({
    Name = "GitHub: @someoneyouwillforget", 
    Callback = function() setclipboard("someoneyouwillforget") end
})

-- 2. INFO
local Info = Win:CreateTab("Info")
Info:CreateHeader({Name = "PROJECT INFO"})
Info:CreateButton({
    Name = "Copy Source Link", 
    Callback = function() setclipboard("https://github.com/someoneyouwillforget/internal") end
})

-- 3. VISUALS
local Visuals = Win:CreateTab("Visuals")
Visuals:CreateHeader({Name = "UI SETTINGS"})
-- (You can add Toggles and Sliders here later)
