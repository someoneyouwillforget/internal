-- [[ INTERNAL PROJECT - OFFICIAL TEST SCRIPT ]] --
-- This script builds the UI structure with your requested tabs.

local Internal = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/main.lua"))()

local Win = Internal:CreateWindow({
    Name = "INTERNAL PROJECT"
})

-- Tab 1
local Credits = Win:CreateTab("Credits")

Credits:CreateButton({
    Name = "Developer: @someoneyouwillforget",
    Callback = function()
        setclipboard("someoneyouwillforget")
        print("GitHub username copied to clipboard!")
    end
})

Credits:CreateButton({
    Name = "Discord: Click to Copy Link",
    Callback = function()
        setclipboard("discord.gg/yourlink")
        print("Discord invite copied!")
    end
})

-- Tab 2
local Info = Win:CreateTab("Info")

Info:CreateButton({
    Name = "Open Source Repo (Copy)",
    Callback = function()
        setclipboard("https://github.com/someoneyouwillforget/internal")
        print("Source link copied!")
    end
})

Info:CreateButton({
    Name = "Version: v1.0.0 Alpha",
    Callback = function()
        print("Running latest build.")
    end
})

-- Tab 3
local Visuals = Win:CreateTab("Visuals")

-- Header for UI Toggles
Visuals:CreateButton({
    Name = "--- MENU SETTINGS ---",
    Callback = function() end
})

Visuals:CreateToggle({
    Name = "Rainbow Border Tabs",
    CurrentValue = false,
    Callback = function(state)
        print("Rainbow Borders:", state)
    end
})

Visuals:CreateSlider({
    Name = "UI Transparency",
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(val)
        print("Transparency:", val)
    end
})

Visuals:CreateToggle({
    Name = "Show Search Bar",
    CurrentValue = true,
    Callback = function(state)
        print("Search Bar Visibility:", state)
    end
})

Visuals:CreateSlider({
    Name = "Tab Border Thickness",
    Min = 1,
    Max = 5,
    Default = 2,
    Callback = function(val)
        print("Border Thickness set to:", val)
    end
})

print("Internal Test Script Loaded Successfully.")
