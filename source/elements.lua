local Elements = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = Theme.ElementColor
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Enum.Font.SourceSansBold -- Forced
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Button).Color = Theme.BorderColor
    
    Button.MouseButton1Click:Connect(function() pcall(BData.Callback) end)
    return Button
end

function Elements.CreateToggle(TabPage, TData, Theme)
    local ToggleFrame = Instance.new("Frame", TabPage)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Theme.ElementColor
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", ToggleFrame)
    s.Color = Theme.BorderColor; s.Thickness = 1.5

    local ToggleBtn = Instance.new("TextButton", ToggleFrame)
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = "  " .. TData.Name
    ToggleBtn.TextXAlignment = "Left"
    ToggleBtn.TextColor3 = Theme.TextColor
    ToggleBtn.Font = Enum.Font.SourceSansBold -- Forced Fix
    ToggleBtn.TextSize = 14

    local SwitchBar = Instance.new("Frame", ToggleFrame)
    SwitchBar.Size = UDim2.new(0, 34, 0, 18)
    SwitchBar.Position = UDim2.new(1, -44, 0.5, -9)
    SwitchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", SwitchBar).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", SwitchBar)
    Circle.Size = UDim2.new(0, 12, 0, 12)
    Circle.Position = UDim2.new(0, 3, 0.5, -6)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local state = TData.CurrentValue or false
    local function update(first)
        local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local targetColor = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(40, 40, 40)
        if first then Circle.Position = targetPos; SwitchBar.BackgroundColor3 = targetColor
        else
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(SwitchBar, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        end
        pcall(TData.Callback, state)
    end
    ToggleBtn.MouseButton1Click:Connect(function() state = not state; update(false) end)
    update(true)
end

function Elements.CreateSlider(TabPage, SData, Theme)
    local SliderFrame = Instance.new("Frame", TabPage)
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.BackgroundColor3 = Theme.ElementColor
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", SliderFrame).Color = Theme.BorderColor

    local Title = Instance.new("TextLabel", SliderFrame)
    Title.Text = "  " .. SData.Name; Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1; Title.TextColor3 = Theme.TextColor
    Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14; Title.TextXAlignment = "Left"

    local ValueLabel = Instance.new("TextLabel", SliderFrame)
    ValueLabel.Size = UDim2.new(1, -15, 0, 25)
    ValueLabel.BackgroundTransparency = 1; ValueLabel.TextColor3 = Theme.TextColor
    ValueLabel.Font = Enum.Font.SourceSansBold; ValueLabel.TextSize = 14; ValueLabel.TextXAlignment = "Right"

    local BarBack = Instance.new("Frame", SliderFrame)
    BarBack.Size = UDim2.new(1, -24, 0, 6); BarBack.Position = UDim2.new(0, 12, 1, -12)
    BarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", BarBack).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBack)
    BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function move(input)
        local pos = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
        local val = math.floor(SData.Min + ((SData.Max - SData.Min) * pos))
        ValueLabel.Text = tostring(val); BarFill.Size = UDim2.new(pos, 0, 1, 0)
        pcall(SData.Callback, val)
    end
    SliderFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; move(input) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    
    local defPos = (SData.Default - SData.Min) / (SData.Max - SData.Min)
    BarFill.Size = UDim2.new(defPos, 0, 1, 0); ValueLabel.Text = tostring(SData.Default)
end

function Elements.CreateDropdown(TabPage, DData, Theme)
    local Dropped = false
    local DropFrame = Instance.new("Frame", TabPage)
    DropFrame.Size = UDim2.new(1, 0, 0, 36); DropFrame.BackgroundColor3 = Theme.ElementColor; DropFrame.ClipsDescendants = true
    Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", DropFrame).Color = Theme.BorderColor

    local MainBtn = Instance.new("TextButton", DropFrame)
    MainBtn.Size = UDim2.new(1, 0, 0, 36); MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. DData.Name .. " : " .. (DData.Default or "None")
    MainBtn.TextColor3 = Theme.TextColor; MainBtn.Font = Enum.Font.SourceSansBold; MainBtn.TextSize = 14; MainBtn.TextXAlignment = "Left"

    local ItemHolder = Instance.new("Frame", DropFrame)
    ItemHolder.Position = UDim2.new(0, 5, 0, 40); ItemHolder.Size = UDim2.new(1, -10, 0, 0); ItemHolder.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", ItemHolder); layout.Padding = UDim.new(0, 4)

    MainBtn.MouseButton1Click:Connect(function()
        Dropped = not Dropped
        TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = Dropped and UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 45) or UDim2.new(1, 0, 0, 36)}):Play()
    end)

    for _, option in pairs(DData.Options) do
        local OptBtn = Instance.new("TextButton", ItemHolder)
        OptBtn.Size = UDim2.new(1, 0, 0, 28); OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        OptBtn.Text = option; OptBtn.TextColor3 = Theme.TextColor; OptBtn.Font = Enum.Font.SourceSansBold; OptBtn.TextSize = 13
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 6)
        OptBtn.MouseButton1Click:Connect(function()
            MainBtn.Text = "  " .. DData.Name .. " : " .. option; Dropped = false
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
            pcall(DData.Callback, option)
        end)
    end
end

return Elements
