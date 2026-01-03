local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/library.lua"))()

local Win = Library:CreateWindow()

-- CREDITS
local Credits = Win:CreateTab("Credits")
Credits:CreateHeader({Name = "CREATORS"})
Credits:CreateButton({Name = "Discord: Copy Link", Callback = function() setclipboard("discord.gg/link") end})
Credits:CreateButton({Name = "GitHub: @someoneyouwillforget", Callback = function() setclipboard("someoneyouwillforget") end})

-- INFO
local Info = Win:CreateTab("Info")
Info:CreateHeader({Name = "PROJECT INFO"})
Info:CreateButton({Name = "Copy Source Link", Callback = function() setclipboard("github.com/link") end})

-- VISUALS
local Visuals = Win:CreateTab("Visuals")
Visuals:CreateHeader({Name = "UI SETTINGS"})

return Library
