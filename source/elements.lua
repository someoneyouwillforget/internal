local Elements = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- BUTTON
function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = Theme.ElementColor
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Theme.TextFont
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", Button)
    s.Color = Theme.BorderColor
    s.Thickness = 1.5
    
    Button.MouseButton1Click:Connect(function() pcall(BData.Callback) end)
    return Button
end

-- TOGGLE (FIXED: Now has a container frame and proper borders)
function Elements.CreateToggle(TabPage, TData, Theme)
    local ToggleFrame = Instance.new("Frame", TabPage)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Theme.ElementColor
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", ToggleFrame)
    s.Color = Theme.BorderColor
    s.Thickness = 1.5

    local ToggleBtn = Instance.new("TextButton", ToggleFrame)
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = "  " .. TData.Name
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.TextColor3 = Theme.TextColor
    ToggleBtn.Font = Theme.TextFont
    ToggleBtn.TextSize = 14

    local SwitchBar = Instance.new("Frame", ToggleFrame)
    SwitchBar.Size = UDim2.new(0, 34, 0, 18)
    SwitchBar.Position = UDim2.new(1, -44, 0.5, -9)
    SwitchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", SwitchBar).CornerRadius = UDim.new(1, 0)
    local barStroke = Instance.new("UIStroke", SwitchBar)
    barStroke.Color = Theme.BorderColor
    barStroke.Thickness = 1

    local Circle = Instance.new("Frame", SwitchBar)
    Circle.Size = UDim2.new(0, 12, 0, 12)
    Circle.Position = UDim2.new(0, 3, 0.5, -6)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local state = TData.CurrentValue or false
    local function update(first)
        local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local targetColor = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(40, 40, 40)
        
        if first then
            Circle.Position = targetPos
            SwitchBar.BackgroundColor3 = targetColor
        else
            TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
            TweenService:Create(SwitchBar, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
        end
        pcall(TData.Callback, state)
    end
    ToggleBtn.MouseButton1Click:Connect(function() state = not state; update(false) end)
    update(true)
end

-- [REST OF ELEMENTS: SLIDER & DROPDOWN REMAIN THE SAME AS PREVIOUS CODE]
