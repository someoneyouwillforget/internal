-- INTERNAL LOADER
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/library.lua"))()
end)

if not success then
    warn("INTERNAL ERROR: Failed to load Library. Check your GitHub links.")
    return nil
end

return Library
