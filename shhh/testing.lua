local Internal = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/main.lua"))()

local Win = Internal:CreateWindow({ Name = "INTERNAL PROJECT" })

-- CREDITS
local Credits = Win:CreateTab("Credits")
Credits:CreateButton({
    Name = "Discord: Click to Copy",
    Callback = function() setclipboard("discord.gg/yourlink") end
})
Credits:CreateButton({
    Name = "GitHub: @someoneyouwillforget",
    Callback = function() setclipboard("someoneyouwillforget") end
})

-- INFO
local Info = Win:CreateTab("Info")
Info:CreateButton({ Name = "Source Code (GitHub)", Callback = function() setclipboard("https://github.com/someoneyouwillforget/internal") end })

-- VISUALS (With Headers)
local Visuals = Win:CreateTab("Visuals")

Visuals:CreateHeader({ Name = "UI SETTINGS" }) -- NEW HEADER WITH BORDER

Visuals:CreateToggle({
    Name = "Rainbow Borders",
    CurrentValue = false,
    Callback = function(v) end
})

Visuals:CreateHeader({ Name = "MENU CUSTOMIZATION" }) -- NEW HEADER WITH BORDER

Visuals:CreateSlider({
    Name = "Transparency",
    Min = 0, Max = 100, Default = 0,
    Callback = function(v) end
})
