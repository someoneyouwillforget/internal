-- [[ INTERNAL PROJECT ]] --
local Internal = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/main.lua"))()

local Win = Internal:CreateWindow({
    Name = "INTERNAL PROJECT"
})

-- TAB 1: CREDITS (Flat text, no stroke)
local Credits = Win:CreateTab("Credits")
Credits:CreateButton({
    Name = "Discord Server (Copy Link)",
    Callback = function() setclipboard("discord.gg/yourserver") end
})
Credits:CreateButton({
    Name = "GitHub: @someoneyouwillforget",
    Callback = function() setclipboard("someoneyouwillforget") end
})

-- TAB 2: INFO
local Info = Win:CreateTab("Info")
Info:CreateButton({
    Name = "GitHub Open Source Link",
    Callback = function() setclipboard("https://github.com/someoneyouwillforget/internal") end
})
Info:CreateButton({
    Name = "Join Support Discord",
    Callback = function() setclipboard("discord.gg/yourserver") end
})

-- TAB 3: VISUALS (UI Controls & "Shiy")
local Visuals = Win:CreateTab("Visuals")

Visuals:CreateToggle({
    Name = "Menu Rainbow Border",
    CurrentValue = false,
    Callback = function(v) print("Rainbow:", v) end
})

Visuals:CreateSlider({
    Name = "Menu Transparency",
    Min = 0, Max = 100, Default = 0,
    Callback = function(v) print("Transparency:", v) end
})

Visuals:CreateToggle({
    Name = "Show Search Bar",
    CurrentValue = true,
    Callback = function(v) print("Search Bar:", v) end
})

Visuals:CreateSlider({
    Name = "Tab Border Thickness",
    Min = 1, Max = 5, Default = 2,
    Callback = function(v) print("Thickness:", v) end
})
