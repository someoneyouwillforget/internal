-- [[ INTERNAL MAIN LOADER ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/library.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

-- Link the elements to the library environment
getgenv().Internal_Elements = Elements
getgenv().Internal_Theme = Theme

return Library
