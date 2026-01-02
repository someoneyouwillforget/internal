-- [[ INTERNAL LOADER ]] --
local MainLoader = {}

-- Fetching the Library from your GitHub tree
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/library.lua"))()
end)

if not success then
    -- Sends an error to the F9 console if the link is broken
    warn("INTERNAL ERROR: Library failed to fetch. Check GitHub paths.")
    return nil
end

-- Return the Library so the executor can run :CreateWindow()
return Library
