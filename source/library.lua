local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabList = Instance.new("ScrollingFrame")
    local ElementsArea = Instance.new("Frame")
    
    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    Main.Name = "Main"
    Main.Parent = InternalUI
    Main.BackgroundColor3 = Theme.Background
    Main.Position = UDim2.new(0.5, -200, 0.5, -125)
    Main.Size = UDim2.new(0, 400, 0, 250)
    Main.Active = true
    Main.Draggable = true
    
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Theme.StrokeColor
    mainStroke.Thickness = 2

    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Instance.new("UICorner", Topbar).CornerRadius = Theme.Rounding

    Title.Parent = Topbar
    Title.Size = UDim2.new(1, -15, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    TabList.Name = "TabList"
    TabList.Parent = Main
    TabList.BackgroundColor3 = Theme.Topbar
    TabList.Position = UDim2.new(0, 8, 0, 48)
    TabList.Size = UDim2.new(0, 100, 1, -56)
    TabList.ScrollBarThickness = 0
    local tabLayout = Instance.new("UIListLayout", TabList)
    tabLayout.Padding = UDim.new(0, 5)
    Instance.new("UICorner", TabList).CornerRadius = Theme.Rounding

    ElementsArea.Name = "Elements"
    ElementsArea.Parent = Main
    ElementsArea.BackgroundTransparency = 1
    ElementsArea.Position = UDim2.new(0, 115, 0, 48)
    ElementsArea.Size = UDim2.new(1, -123, 1, -56)

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabList
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 14

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Parent = ElementsArea
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do 
                if v:IsA("ScrollingFrame") then v.Visible = false end 
            end
            TabPage.Visible = true
        end)

        local Container = {}
        function Container:CreateButton(D) return ElementsAPI.CreateButton(TabPage, D, Theme) end
        function Container:CreateToggle(D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        return Container
    end
    return Window
end

return Library
