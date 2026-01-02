local Elements = {}
function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, -5, 0, 28) -- Smaller buttons
    Button.BackgroundColor3 = Theme.ElementColor
    Button.BackgroundTransparency = 0.2
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Theme.TextFont
    Button.TextSize = 12
    local c = Instance.new("UICorner", Button); c.CornerRadius = Theme.Rounding
    local s = Instance.new("UIStroke", Button); s.Color = Theme.BorderColor; s.ApplyStrokeMode = "Border"
    Button.MouseButton1Click:Connect(function() pcall(BData.Callback) end)
    return Button
end

function Elements.CreateToggle(TabPage, TData, Theme)
    local Toggle = Instance.new("TextButton", TabPage)
    Toggle.Size = UDim2.new(1, -5, 0, 28)
    Toggle.BackgroundColor3 = Theme.ElementColor
    Toggle.BackgroundTransparency = 0.2
    Toggle.Text = "  "..TData.Name; Toggle.TextXAlignment = "Left"
    Toggle.TextColor3 = Theme.TextColor; Toggle.Font = Theme.TextFont; Toggle.TextSize = 12
    Instance.new("UICorner", Toggle).CornerRadius = Theme.Rounding
    Instance.new("UIStroke", Toggle).Color = Theme.BorderColor
    
    local Ind = Instance.new("Frame", Toggle)
    Ind.Position = UDim2.new(1, -22, 0.5, -7); Ind.Size = UDim2.new(0, 14, 0, 14)
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 3)
    
    local state = TData.CurrentValue or false
    local function update() 
        Ind.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40,40,40)
        pcall(TData.Callback, state)
    end
    Toggle.MouseButton1Click:Connect(function() state = not state; update() end)
    update()
    return Toggle
end
return Elements
