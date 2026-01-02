local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

local function AddBorder(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.BorderColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui")
    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    local Main = Instance.new("Frame", InternalUI)
    Main.Name = "Main"
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.15
    Main.Position = UDim2.new(0.5, -150, 0.5, -100)
    Main.Size = UDim2.new(0, 320, 0, 260)
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main)

    -- TITLE CONTAINER (Isolated Frame)
    local TitleFrame = Instance.new("Frame", Main)
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Size = UDim2.new(1, -20, 0, 35)
    TitleFrame.Position = UDim2.new(0, 10, 0, 10)
    TitleFrame.BackgroundColor3 = Theme.Topbar
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 8)
    AddBorder(TitleFrame)

    local Title = Instance.new("TextLabel", TitleFrame)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- BUTTONS (X / -)
    local Close = Instance.new("TextButton", TitleFrame)
    Close.Size = UDim2.new(0, 22, 0, 22)
    Close.Position = UDim2.new(1, -28, 0.5, -11)
    Close.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
    AddBorder(Close, Color3.fromRGB(80, 30, 30))

    local Mini = Instance.new("TextButton", TitleFrame)
    Mini.Size = UDim2.new(0, 22, 0, 22)
    Mini.Position = UDim2.new(1, -54, 0.5, -11)
    Mini.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Mini.Text = "-"
    Mini.TextColor3 = Theme.TextColor
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 6)
    AddBorder(Mini)

    -- BUTTON LOGIC
    Close.MouseButton1Click:Connect(function() InternalUI:Destroy() end)
    local toggled = true
    Mini.MouseButton1Click:Connect(function()
        toggled = not toggled
        Main.Elements.Visible = toggled
        Main.TabList.Visible = toggled
        Main.DragHandle.Visible = toggled
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.3), {Size = toggled and UDim2.new(0, 320, 0, 260) or UDim2.new(0, 320, 0, 55)}):Play()
    end)

    -- TAB LIST (Centered & Bordered Tabs)
    local TabList = Instance.new("ScrollingFrame", Main)
    TabList.Name = "TabList"
    TabList.Position = UDim2.new(0, 10, 0, 55)
    TabList.Size = UDim2.new(1, -20, 0, 28)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Name = "Elements"
    ElementsArea.Position = UDim2.new(0, 10, 0, 95)
    ElementsArea.Size = UDim2.new(1, -20, 1, -120)
    ElementsArea.BackgroundTransparency = 1

    -- IOS DRAG BAR
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Name = "DragHandle"
    DragHandle.Size = UDim2.new(1, 0, 0, 20)
    DragHandle.Position = UDim2.new(0, 0, 1, -20)
    DragHandle.BackgroundTransparency = 1
    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 50, 0, 4)
    VisualBar.Position = UDim2.new(0.5, -25, 0.5, -2)
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
    game:GetService("UserInputService").InputEnded:Connect(function(input) dragging = false end)

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 65, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Theme.TextFont
        TabBtn.TextSize = 10
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        AddBorder(TabBtn) -- Each Tab gets a border

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do v.Visible = false end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do 
                if b:IsA("TextButton") then 
                    b.TextColor3 = Color3.fromRGB(150, 150, 150)
                    b.UIStroke.Color = Theme.BorderColor
                end 
            end
            TabBtn.TextColor3 = Theme.TextColor
            TabBtn.UIStroke.Color = Color3.fromRGB(200, 200, 200) -- Highlight active tab border
        end)

        return {
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end,
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
