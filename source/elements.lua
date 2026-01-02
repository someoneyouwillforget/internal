local Elements = {}

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, 0, 0, 34)
    Button.BackgroundColor3 = Theme.ElementColor
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Theme.TextFont
    Button.TextSize = 11
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", Button)
    s.Color = Theme.BorderColor
    s.Thickness = 1.5
    
    Button.MouseButton1Click:Connect(function() pcall(BData.Callback) end)
    return Button
end

function Elements.CreateToggle(TabPage, TData, Theme)
    local Toggle = Instance.new("TextButton", TabPage)
    Toggle.Size = UDim2.new(1, 0, 0, 34)
    Toggle.BackgroundColor3 = Theme.ElementColor
    Toggle.Text = "  " .. TData.Name
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.TextColor3 = Theme.TextColor
    Toggle.Font = Theme.TextFont
    Toggle.TextSize = 11
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", Toggle)
    s.Color = Theme.BorderColor
    s.Thickness = 1.5
    
    local Ind = Instance.new("Frame", Toggle)
    Ind.Position = UDim2.new(1, -28, 0.5, -9)
    Ind.Size = UDim2.new(0, 18, 0, 18)
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 6)
    
    local state = TData.CurrentValue or false
    local function update() 
        Ind.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(50,50,50)
        pcall(TData.Callback, state)
    end
    Toggle.MouseButton1Click:Connect(function() state = not state; update() end)
    update()
    return Toggle
end

return Elements
