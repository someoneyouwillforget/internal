local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/Theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/Elements.lua"))()

function Library:CreateWindow(Settings)
    local InternalUI = game:GetObjects("rbxassetid://10804731440")[1]
    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    
    local Main = InternalUI.Main
    Main.BackgroundColor3 = Theme.Background
    Main.Topbar.BackgroundColor3 = Theme.Topbar
    Main.Topbar.Title.Text = Settings.Name or "INTERNAL"
    Main.Topbar.Title.TextColor3 = Theme.TextColor
    
    InternalUI.Enabled = true
    
    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Main.TabList.Template:Clone()
        TabBtn.Parent = Main.TabList
        TabBtn.Title.Text = Name
        TabBtn.Visible = true
        
        local TabPage = Main.Elements.Template:Clone()
        TabPage.Parent = Main.Elements
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Main.Elements:GetChildren()) do 
                if v:IsA("ScrollingFrame") then v.Visible = false end 
            end
            TabPage.Visible = true
        end)
        
        local Container = {}
        function Container:CreateButton(D) return ElementsAPI.CreateButton(TabPage, D) end
        function Container:CreateToggle(D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        
        return Container
    end
    return Window
end

return Library
