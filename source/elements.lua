local Elements = {}

function Elements.CreateHeader(TabPage, HData, Theme)
    local Header = Instance.new("Frame", TabPage)
    Header.Size = UDim2.new(1, 0, 0, 22)
    Header.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = HData.Name
    Title.Font = Theme.Font
    Title.TextColor3 = Theme.TextColor
    Title.TextSize = 14
    Title.TextStrokeTransparency = 1
end

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, -2, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = BData.Name
    Button.Font = Theme.Font
    Button.TextColor3 = Theme.TextColor
    Button.TextSize = 14
    Button.TextStrokeTransparency = 1
    
    local bStroke = Instance.new("UIStroke", Button)
    bStroke.Color = Theme.BorderColor
    bStroke.Thickness = 1.2
    bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    Button.MouseButton1Click:Connect(function()
        pcall(BData.Callback)
    end)
end

return Elements
