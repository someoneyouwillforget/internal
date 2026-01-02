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

    -- MAIN FRAME
    local Main = Instance.new("Frame", InternalUI)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.1
    Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    Main.Size = UDim2.new(0, 450, 0, 320)
    Main.ClipsDescendants = true -- This makes the 'squeeze' work
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main, 2.5)

    -- TITLE CAPSULE
    local TitleFrame = Instance.new("Frame", Main)
    TitleFrame.Name = "TitleFrame"
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
    Title.Font = Enum.Font.Code
    Title.TextSize = 14
    Title.TextXAlignment = "Left"

    -- CONTENT FOLDER (This is what we hide to make it "squeeze")
    local Content = Instance.new("Frame", Main)
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -62)
    Content.Position = UDim2.new(0, 0, 0, 62)
    Content.BackgroundTransparency = 1

    -- MINIMIZE / CLOSE BUTTONS
    local Close = Instance.new("TextButton", TitleFrame)
    Close.Size = UDim2.new(0, 24, 0, 24); Close.Position = UDim2.new(1, -32, 0.5, -12)
    Close.BackgroundColor3 = Color3.fromRGB(60, 20, 20); Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 100, 100); Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
    AddBorder(Close, 1.5)

    local Mini = Instance.new("TextButton", TitleFrame)
    Mini.Size = UDim2.new(0, 24, 0, 24); Mini.Position = UDim2.new(1, -62, 0.5, -12)
    Mini.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Mini.Text = "-"
    Mini.TextColor3 = Theme.TextColor; Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 8)
    AddBorder(Mini, 1.5)

    -- SQUEEZE LOGIC
    local minimized = false
    Mini.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetMainHeight = minimized and 62 or 320
        
        -- Instantly hide content so it doesn't leak out during animation
        if minimized then Content.Visible = false end
        
        local tween = game:GetService("TweenService"):Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 450, 0, targetMainHeight)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            if not minimized then Content.Visible = true end
        end)
    end)
    Close.MouseButton1Click:Connect(function() InternalUI:Destroy() end)

    -- SEARCH BAR (With border)
    local Search = Instance.new("TextBox", Content)
    Search.Size = UDim2.new(1, -24, 0, 28); Search.Position = UDim2.new(0, 12, 0, 0)
    Search.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Search.PlaceholderText = "Search..."
    Search.TextColor3 = Color3.fromRGB(255, 255, 255); Search.Font = Enum.Font.Code; Search.TextSize = 12
    Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8); AddBorder(Search, 1.2)

    -- TABS (Fixed Cut-off)
    local TabList = Instance.new("ScrollingFrame", Content)
    TabList.Position = UDim2.new(0, 12, 0, 38) -- Spaced below search
    TabList.Size = UDim2.new(1, -24, 0, 34) -- INCREASED HEIGHT TO PREVENT BORDER CUTOFF
    TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = "Horizontal"; layout.Padding = UDim.new(0, 10); layout.VerticalAlignment = "Center"

    local ElementsArea = Instance.new("Frame", Content)
    ElementsArea.Position = UDim2.new(0, 12, 0, 80); ElementsArea.Size = UDim2.new(1, -24, 1, -110)
    ElementsArea.BackgroundTransparency = 1

    -- IOS DRAG BAR (Always at the very bottom of the Main Frame)
    local DragHandle = Instance.new("Frame", Main)
    DragHandle.Size = UDim2.new(1, 0, 0, 20); DragHandle.Position = UDim2.new(0, 0, 1, -20); DragHandle.BackgroundTransparency = 1
    local VisualBar = Instance.new("Frame", DragHandle)
    VisualBar.Size = UDim2.new(0, 80, 0, 4); VisualBar.Position = UDim2.new(0.5, -40, 0.5, -2); VisualBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", VisualBar).CornerRadius = UDim.new(1, 0)

    -- Drag Logic
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
        TabBtn.Size = UDim2.new(0, 110, 0, 26) -- Fixed size that fits inside TabList
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180); TabBtn.Font = Enum.Font.Code; TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8); AddBorder(TabBtn, 1.2)

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.Visible = false; TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        return {
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end,
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
