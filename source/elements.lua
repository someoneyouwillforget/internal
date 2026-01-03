local Elements = {}

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton", TabPage)
    Button.Size = UDim2.new(1, -10, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    
    -- MATCHING THE TAB FONT
    Button.Font = Enum.Font.SourceSansBold 
    Button.TextSize = 14
    Button.TextStrokeTransparency = 1 -- CLEAN TEXT, NO OUTLINE
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    -- ADDING THE BORDER (MATCHING THE TABS)
    local bStroke = Instance.new("UIStroke", Button)
    bStroke.Color = Theme.BorderColor
    bStroke.Thickness = 1.5
    bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- BOX ONLY

    Button.MouseButton1Click:Connect(function()
        pcall(BData.Callback)
    end)
    
    return Button
end

-- Repeat similar logic for Toggles/Sliders if you want them bordered too
return Elements
