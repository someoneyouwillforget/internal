local Elements = {}
local TweenService = game:GetService("TweenService")

function Elements.CreateButton(TabPage, BData)
    local Button = TabPage.Parent.Parent.Template.Button:Clone()
    Button.Parent = TabPage
    Button.Title.Text = BData.Name
    Button.Visible = true
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.MouseButton1Click:Connect(function()
        pcall(BData.Callback)
    end)
    return Button
end

function Elements.CreateToggle(TabPage, TData, Theme)
    local Toggle = TabPage.Parent.Parent.Template.Toggle:Clone()
    local Toggled = TData.CurrentValue or false
    Toggle.Parent = TabPage
    Toggle.Title.Text = TData.Name
    Toggle.Visible = true
    
    local function Update()
        local Color = Toggled and Theme.Accent or Color3.fromRGB(40, 40, 40)
        TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color}):Play()
        pcall(TData.Callback, Toggled)
    end
    
    Toggle.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        Update()
    end)
    Update()
    return Toggle
end

return Elements
