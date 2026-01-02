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

    -- Main Window
    Main.Name = "Main"
    Main.Parent = InternalUI
    Main.BackgroundColor3 = Theme.Background
    Main.Position = UDim2.new(0.5, -200, 0.5, -125)
    Main.Size = UDim2.new(0, 400, 0, 280) -- Made slightly taller for top tabs
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Theme.StrokeColor
    mainStroke.Thickness = 1

    -- Topbar (Title)
    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", Topbar).CornerRadius = Theme.Rounding

    Title.Parent = Topbar
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 16

    -- Tab Bar (Horizontal - Under Title)
    TabList.Name = "TabList"
    TabList.Parent = Main
    TabList.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TabList.Position = UDim2.new(0, 5, 0, 40)
    TabList.Size = UDim2.new(1, -10, 0, 30)
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(2, 0, 0, 0) -- Allows horizontal scrolling if many tabs
    
    local tabLayout = Instance.new("UIListLayout", TabList)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    Instance.new("UICorner", TabList).CornerRadius = UDim.new(0, 4)

    -- Content Area
    ElementsArea.Name = "Elements"
    ElementsArea.Parent = Main
    ElementsArea.BackgroundTransparency = 1
    ElementsArea.Position = UDim2.new(0, 10, 0, 80)
    ElementsArea.Size = UDim2.new(1, -20, 1, -90)

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabList
        TabBtn.Size = UDim2.new(0, 80, 1, -6)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

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
            -- Update Visual Feedback
            for _, btn in pairs(TabList:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            TabBtn.TextColor3 = Theme.TextColor
        end)

        local Container = {}
        function Container:CreateButton(D) return ElementsAPI.CreateButton(TabPage, D, Theme) end
        function Container:CreateToggle(D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        return Container
    end
    return Window
end

return Library
