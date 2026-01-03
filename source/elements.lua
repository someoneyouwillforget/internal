local Elements = {}

-- HEADER (Plain box with border)
function Elements.CreateHeader(TabPage, HData, Theme)
    local HeaderFrame = Instance.new("Frame", TabPage)
    HeaderFrame.Size = UDim2.new(1, -10, 0, 24)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 4)

    local hStroke = Instance.new("UIStroke", HeaderFrame)
    hStroke.Color = Theme.BorderColor
    hStroke.Thickness = 1
    hStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel", HeaderFrame)
    Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1
    Title.Text = HData.Name; Title.TextColor3 = Theme.TextColor
    Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 12
    Title.TextStrokeTransparency = 1
end

-- BUTTON (Border Tab Style)
function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, -10, 0, 32); Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = BData.Name; Button.TextColor3 = Theme.TextColor
    Button.Font = Enum.Font.SourceSansBold; Button.TextSize = 14
    Button.TextStrokeTransparency = 1
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    local bStroke = Instance.new("UIStroke", Button)
    bStroke.Color = Theme.BorderColor; bStroke.Thickness = 1.5; bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Button.MouseButton1Click:Connect(function() pcall(BData.Callback) end)
end

-- TOGGLE (Border Tab Style)
function Elements.CreateToggle(TabPage, TData, Theme)
    local ToggleFrame = Instance.new("Frame", TabPage)
    ToggleFrame.Size = UDim2.new(1, -10, 0, 36); ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    local tStroke = Instance.new("UIStroke", ToggleFrame)
    tStroke.Color = Theme.BorderColor; tStroke.Thickness = 1.5; tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel", ToggleFrame)
    Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = TData.Name; Title.TextColor3 = Theme.TextColor; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14
    Title.TextXAlignment = "Left"; Title.TextStrokeTransparency = 1

    -- Toggle logic... (Circle/SwitchBar here)
end

return Elements
