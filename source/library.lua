local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

function Library:CreateWindow(Settings)
    -- BASE UI CONSTRUCTION
    local InternalUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabList = Instance.new("ScrollingFrame")
    local ElementsArea = Instance.new("Frame")
    local UIList = Instance.new("UIListLayout")

    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    InternalUI.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = InternalUI
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -150, 0.5, -100)
    Main.Size = UDim2.new(0, 400, 0, 250)
    Main.Active = true
    Main.Draggable = true -- Mobile friendly dragging

    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 30)

    Title.Parent = Topbar
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 14

    TabList.Name = "TabList"
    TabList.Parent = Main
    TabList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 0, 0, 30)
    TabList.Size = UDim2.new(0, 100, 1, -30)
    TabList.ScrollBarThickness = 0

    UIList.Parent = TabList
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    ElementsArea.Name = "Elements"
    ElementsArea.Parent = Main
    ElementsArea.BackgroundTransparency = 1
    ElementsArea.Position = UDim2.new(0, 105, 0, 35)
    ElementsArea.Size = UDim2.new(1, -110, 1, -40)

    local Window = {}

    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabList
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = Name
        TabBtn.TextColor3 = Theme.TextColor
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 13

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Parent = ElementsArea
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 2
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.Padding = UDim.new(0, 5)

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
