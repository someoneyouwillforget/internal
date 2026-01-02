local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

local function AddBorder(obj, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.BorderColor
    stroke.Thickness = thickness or 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui")
    InternalUI.Name = "InternalSuite"
    InternalUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    local Main = Instance.new("Frame", InternalUI)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.1
    Main.Position = UDim2.new(0.5, -175, 0.5, -125)
    Main.Size = UDim2.new(0, 350, 0, 280) -- Slightly bigger frame
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main, 2)

    -- TITLE CAPSULE
    local TitleFrame = Instance.new("Frame", Main)
    TitleFrame.Size = UDim2.new(1, -24, 0, 38)
    TitleFrame.Position = UDim2.new(0, 12, 0, 12)
    TitleFrame.BackgroundColor3 = Theme.Topbar
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 12)
    AddBorder(TitleFrame, 1.5)

    local Title = Instance.new("TextLabel", TitleFrame)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 14
    Title.TextXAlignment = "Left"

    -- BUTTONS (X / -) Logic
    local Close = Instance.new("TextButton", TitleFrame)
    Close.Size = UDim2.new(0, 24, 0, 24)
    Close.Position = UDim2.new(1, -32, 0.5, -12)
    Close.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    Close.Text = "×"; Close.TextColor3 = Color3.fromRGB(255,100,100)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
    AddBorder(Close, 1.5)

    local Mini = Instance.new("TextButton", TitleFrame)
    Mini.Size = UDim2.new(0, 24, 0, 24)
    Mini.Position = UDim2.new(1, -62, 0.5, -12)
    Mini.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Mini.Text = "-"; Mini.TextColor3 = Theme.TextColor
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 8)
    AddBorder(Mini, 1.5)

    -- FUNCTIONALITY
    Close.MouseButton1Click:Connect(function()
        InternalUI:Destroy()
    end)

    local minimized = false
    Mini.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 350, 0, 62) or UDim2.new(0, 350, 0, 280)
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    end)

    -- TABS (Thinner and Longer)
    local TabList = Instance.new("ScrollingFrame", Main)
    TabList.Position = UDim2.new(0, 10, 0, 62)
    TabList.Size = UDim2.new(1, -20, 0, 26) -- Thinner height
    TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = "Horizontal"; layout.Padding = UDim.new(0, 8); layout.HorizontalAlignment = "Center"

    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Name = "Elements"
    ElementsArea.Position = UDim2.new(0, 12, 0, 100)
    ElementsArea.Size = UDim2.new(1, -24, 1, -130)
    ElementsArea.BackgroundTransparency = 1

    -- IOS DRAG BAR
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Size = UDim2.new(1, 0, 0, 20); DragHandle.Position = UDim2.new(0, 0, 1, -20); DragHandle.BackgroundTransparency = 1
    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 60, 0, 4); VisualBar.Position = UDim2.new(0.5, -30, 0.5, -2); VisualBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", VisualBar).CornerRadius = UDim.new(1, 0)

    -- DRAG LOGIC (Bottom bar)
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
    game:GetService("UserInputService").InputEnded:Connect(function() dragging = false end)

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 95, 1, 0) -- Longer for more text
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Theme.TextFont; TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        AddBorder(TabBtn, 1.2)

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.Visible = false; TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do v.Visible = false end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do 
                if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(180, 180, 180); b.UIStroke.Color = Theme.BorderColor end 
            end
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.UIStroke.Color = Color3.fromRGB(255, 255, 255)
        end)
        return {
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end,
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
