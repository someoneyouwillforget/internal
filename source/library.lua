local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

local function AddBorder(obj)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.BorderColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui")
    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    -- MAIN FRAME: Shrunk to a compact rectangle for mobile
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = InternalUI
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.15 -- Semi-Transparent as requested
    Main.Position = UDim2.new(0.5, -150, 0.5, -100)
    Main.Size = UDim2.new(0, 320, 0, 240) -- Compact Mobile Size
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main)

    -- TITLE BAR (Transparent)
    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 32)
    Topbar.BackgroundTransparency = 1 
    AddBorder(Topbar)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- CLOSE & MINIMIZE LOGIC
    local Close = Instance.new("TextButton", Topbar)
    Close.Size = UDim2.new(0, 22, 0, 22)
    Close.Position = UDim2.new(1, -28, 0.5, -11)
    Close.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
    AddBorder(Close)

    local Mini = Instance.new("TextButton", Topbar)
    Mini.Size = UDim2.new(0, 22, 0, 22)
    Mini.Position = UDim2.new(1, -54, 0.5, -11)
    Mini.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Mini.Text = "-"
    Mini.TextColor3 = Theme.TextColor
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 4)
    AddBorder(Mini)

    local Toggled = true
    Close.MouseButton1Click:Connect(function() InternalUI:Destroy() end)
    Mini.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        Main.Elements.Visible = Toggled
        Main.TabList.Visible = Toggled
        Main.DragHandle.Visible = Toggled
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.3), {Size = Toggled and UDim2.new(0, 320, 0, 240) or UDim2.new(0, 320, 0, 32)}):Play()
    end)

    -- TABS: Transparent & Small
    local TabList = Instance.new("ScrollingFrame", Main)
    TabList.Name = "TabList"
    TabList.Position = UDim2.new(0, 5, 0, 38)
    TabList.Size = UDim2.new(1, -10, 0, 25)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ELEMENTS
    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Name = "Elements"
    ElementsArea.Position = UDim2.new(0, 8, 0, 70)
    ElementsArea.Size = UDim2.new(1, -16, 1, -95)
    ElementsArea.BackgroundTransparency = 1

    -- IOS DRAG BAR
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Name = "DragHandle"
    DragHandle.Size = UDim2.new(1, 0, 0, 15)
    DragHandle.Position = UDim2.new(0, 0, 1, -15)
    DragHandle.BackgroundTransparency = 1
    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 60, 0, 3)
    VisualBar.Position = UDim2.new(0.5, -30, 0.5, -1)
    VisualBar.BackgroundColor3 = Theme.BorderColor
    Instance.new("UICorner", VisualBar).CornerRadius = UDim.new(1, 0)

    -- DRAG LOGIC
    local dragging, dragStart, startPos
    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 60, 1, 0)
        TabBtn.BackgroundTransparency = 1 -- Transparent Tabs
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 11

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 4)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do v.Visible = false end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabBtn.TextColor3 = Theme.TextColor
        end)
        return {
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end,
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
