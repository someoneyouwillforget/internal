local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

-- Helper function for the light gray borders you wanted
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
    Main.Size = UDim2.new(0, 400, 0, 280)
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main)

    -- TITLE BAR (Now with Border)
    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BorderSizePixel = 0
    Instance.new("UICorner", Topbar).CornerRadius = Theme.Rounding
    AddBorder(Topbar) -- Added the missing border here

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 15

    -- TABS (Smaller and spaced away from Title)
    local TabList = Instance.new("ScrollingFrame", Main)
    TabList.Position = UDim2.new(0, 10, 0, 45) -- Moved 10px down from title
    TabList.Size = UDim2.new(1, -20, 0, 30)   -- Shorter height (30px)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6) -- Closer spacing between tabs
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ELEMENTS AREA (Adjusted for smaller tabs)
    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Position = UDim2.new(0, 10, 0, 85)
    ElementsArea.Size = UDim2.new(1, -20, 1, -115)
    ElementsArea.BackgroundTransparency = 1

    -- IOS DRAG BAR
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Size = UDim2.new(1, 0, 0, 20)
    DragHandle.Position = UDim2.new(0, 0, 1, -20)
    DragHandle.BackgroundTransparency = 1

    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 80, 0, 3)
    VisualBar.Position = UDim2.new(0.5, -40, 0.5, -1)
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

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 75, 1, 0) -- Smaller tab width
        TabBtn.BackgroundColor3 = Theme.ElementColor
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        AddBorder(TabBtn)

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do v.Visible = false end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(180, 180, 180) end end
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
