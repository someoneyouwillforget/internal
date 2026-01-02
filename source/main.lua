-- INTERNAL LOADER
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/Library.lua"))()
end)

if not success then
    warn("FATAL ERROR: Could not load Library.")
    return nil
end

return Library
