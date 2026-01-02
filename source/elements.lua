local Elements = {}
local TweenService = game:GetService("TweenService")

local function Style(obj, Theme)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.Rounding
    corner.Parent = obj
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.StrokeColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

function Elements.CreateButton(TabPage, BData, Theme)
    local Button = Instance.new("TextButton")
    Button.Parent = TabPage
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.BackgroundColor3 = Theme.ElementColor
    Button.Text = BData.Name
    Button.TextColor3 = Theme.TextColor
    Button.Font = Theme.TextFont
    Button.TextSize = 14
    Style(Button, Theme)
    
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
    ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
    ToggleBtn.BackgroundColor3 = Theme.ElementColor
    ToggleBtn.Text = "  " .. TData.Name
    ToggleBtn.TextColor3 = Theme.TextColor
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Font = Theme.TextFont
    Style(ToggleBtn, Theme)

    Indicator.Parent = ToggleBtn
    Indicator.Position = UDim2.new(1, -30, 0.5, -10)
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 6)
    indCorner.Parent = Indicator

    local function Update()
        local Color = Toggled and Theme.Accent or Color3.fromRGB(50, 50, 50)
        TweenService:Create(Indicator, TweenInfo.new(0.25), {BackgroundColor3 = Color}):Play()
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
