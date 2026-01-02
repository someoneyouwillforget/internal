local Elements = {}
local TweenService = game:GetService("TweenService")

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton")
    Button.Parent = TabPage
    Button.Size = UDim2.new(1, -5, 0, 30)
    Button.BackgroundColor3 = Theme.ElementBackground
    Button.BorderSizePixel = 0
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Theme.TextFont
    Button.TextSize = 12
    
    Button.MouseButton1Click:Connect(function()
        pcall(BData.Callback)
    end)
    return Button
end

function Elements.CreateToggle(TabPage, TData, Theme)
    local ToggleBtn = Instance.new("TextButton")
    local Indicator = Instance.new("Frame")
    local Toggled = TData.CurrentValue or false

    ToggleBtn.Parent = TabPage
    ToggleBtn.Size = UDim2.new(1, -5, 0, 30)
    ToggleBtn.BackgroundColor3 = Theme.ElementBackground
    ToggleBtn.Text = "  " .. TData.Name
    ToggleBtn.TextColor3 = Theme.TextColor
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Font = Theme.TextFont

    Indicator.Parent = ToggleBtn
    Indicator.Position = UDim2.new(1, -25, 0.5, -10)
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.BorderSizePixel = 0

    local function Update()
        local Color = Toggled and Theme.Accent or Color3.fromRGB(40, 40, 40)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color}):Play()
        pcall(TData.Callback, Toggled)
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        Update()
    end)
    Update()
    return ToggleBtn
end

return Elements
