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
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.Size = UDim2.new(0, 400, 0, 280)
    Main.ClipsDescendants = true 
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    AddBorder(Main, 2.5)

    local TitleFrame = Instance.new("Frame", Main)
    TitleFrame.Size = UDim2.new(1, -24, 0, 38)
    TitleFrame.Position = UDim2.new(0, 12, 0, 12)
    TitleFrame.BackgroundColor3 = Theme.Topbar
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 12)
    AddBorder(TitleFrame, 1.5)

    local Title = Instance.new("TextLabel", TitleFrame)
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"
    Title.TextColor3 = Theme.TextColor
    Title.Font = Theme.TextFont
    Title.TextSize = 18
    Title.TextXAlignment = "Left"

    local Content = Instance.new("Frame", Main)
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -62)
    Content.Position = UDim2.new(0, 0, 0, 62)
    Content.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", TitleFrame)
    Close.Size = UDim2.new(0, 24, 0, 24); Close.Position = UDim2.new(1, -32, 0.5, -12)
    Close.BackgroundColor3 = Color3.fromRGB(60, 20, 20); Close.Text = "×"; Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8); AddBorder(Close, 1.5)

    local Mini = Instance.new("TextButton", TitleFrame)
    Mini.Size = UDim2.new(0, 24, 0, 24); Mini.Position = UDim2.new(1, -62, 0.5, -12)
    Mini.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Mini.Text = "-"; Mini.TextColor3 = Theme.TextColor
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 8); AddBorder(Mini, 1.5)

    local minimized = false
    Mini.MouseButton1Click:Connect(function()
        minimized = not minimized
        Content.Visible = not minimized
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = minimized and UDim2.new(0, 400, 0, 62) or UDim2.new(0, 400, 0, 280)
        }):Play()
    end)
    Close.MouseButton1Click:Connect(function() InternalUI:Destroy() end)

    local Search = Instance.new("TextBox", Content)
    Search.Size = UDim2.new(1, -24, 0, 28); Search.Position = UDim2.new(0, 12, 0, 0)
    Search.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Search.PlaceholderText = "Search Settings..."
    Search.Text = ""; Search.TextColor3 = Theme.TextColor; Search.Font = Theme.TextFont; Search.TextSize = 14
    Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8); AddBorder(Search, 1.2)

    local TabList = Instance.new("ScrollingFrame", Content)
    TabList.Position = UDim2.new(0, 12, 0, 36); TabList.Size = UDim2.new(1, -24, 0, 32)
    TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local layout = Instance.new("UIListLayout", TabList)
    layout.FillDirection = "Horizontal"; layout.Padding = UDim.new(0, 10); layout.VerticalAlignment = "Center"

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X + 20, 0, 0)
    end)

    local ElementsArea = Instance.new("Frame", Content)
    ElementsArea.Position = UDim2.new(0, 12, 0, 75); ElementsArea.Size = UDim2.new(1, -24, 1, -100)
    ElementsArea.BackgroundTransparency = 1

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 100, 0, 26)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = Theme.TextFont; TabBtn.TextSize = 14
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
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end,
            CreateSlider = function(_, D) return ElementsAPI.CreateSlider(TabPage, D, Theme) end,
            CreateDropdown = function(_, D) return ElementsAPI.CreateDropdown(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
