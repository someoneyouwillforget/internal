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

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = InternalUI
    Main.BackgroundColor3 = Theme.Background
    Main.Position = UDim2.new(0.5, -200, 0.5, -125)
    Main.Size = UDim2.new(0, 420, 0, 300)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main)

    -- TOPBAR
    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Theme.Topbar
    AddBorder(Topbar)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- CLOSE & MINIMIZE BUTTONS
    local Close = Instance.new("TextButton", Topbar)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Position = UDim2.new(1, -35, 0.5, -12)
    Close.BackgroundColor3 = Theme.ElementColor
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
    AddBorder(Close).Color = Color3.fromRGB(80, 40, 40)

    local Mini = Instance.new("TextButton", Topbar)
    Mini.Size = UDim2.new(0, 25, 0, 25)
    Mini.Position = UDim2.new(1, -65, 0.5, -12)
    Mini.BackgroundColor3 = Theme.ElementColor
    Mini.Text = "-"
    Mini.TextColor3 = Theme.TextColor
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 4)
    AddBorder(Mini)

    -- TAB LIST (BIGGER)
    local TabList = Instance.new("ScrollingFrame", Main)
    TabList.Position = UDim2.new(0, 10, 0, 50)
    TabList.Size = UDim2.new(1, -20, 0, 40)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 10)

    -- IOS DRAG BAR (AT BOTTOM)
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Size = UDim2.new(1, 0, 0, 20)
    DragHandle.Position = UDim2.new(0, 0, 1, -20)
    DragHandle.BackgroundTransparency = 1

    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 100, 0, 4)
    VisualBar.Position = UDim2.new(0.5, -50, 0.5, -2)
    VisualBar.BackgroundColor3 = Theme.BorderColor
    Instance.new("UICorner", VisualBar).CornerRadius = UDim.new(1, 0)

    -- DRAG LOGIC
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Position = UDim2.new(0, 10, 0, 100)
    ElementsArea.Size = UDim2.new(1, -20, 1, -130)
    ElementsArea.BackgroundTransparency = 1

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundColor3 = Theme.ElementColor
        TabBtn.Text = Name
        TabBtn.TextColor3 = Theme.TextColor
        TabBtn.Font = Theme.TextFont
        Instance.new("UICorner", TabBtn).CornerRadius = Theme.Rounding
        AddBorder(TabBtn)

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do v.Visible = false end
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
