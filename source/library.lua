local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    
    local Main = Instance.new("Frame", InternalUI)
    Main.BackgroundColor3 = Theme.Background
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.Size = UDim2.new(0, 400, 0, 280)
    Main.ClipsDescendants = true 
    Instance.new("UICorner", Main).CornerRadius = Theme.Rounding
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.BorderColor; MainStroke.Thickness = 2.5
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- Box only

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TitleFrame = Instance.new("Frame", Main)
    TitleFrame.Size = UDim2.new(1, -24, 0, 38); TitleFrame.Position = UDim2.new(0, 12, 0, 12)
    TitleFrame.BackgroundColor3 = Theme.Topbar
    Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 12)
    local tStroke = Instance.new("UIStroke", TitleFrame)
    tStroke.Color = Theme.BorderColor; tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel", TitleFrame)
    Title.Size = UDim2.new(1, -80, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "INTERNAL"; Title.TextColor3 = Theme.TextColor
    Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18; Title.TextXAlignment = "Left"
    Title.TextStrokeTransparency = 1 -- NO TEXT BORDER

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, 0, 1, -62); Content.Position = UDim2.new(0, 0, 0, 62); Content.BackgroundTransparency = 1

    -- SEARCH BOX BORDER (NO TEXT BORDER)
    local Search = Instance.new("TextBox", Content)
    Search.Size = UDim2.new(1, -24, 0, 28); Search.Position = UDim2.new(0, 12, 0, 0)
    Search.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Search.PlaceholderText = "Search..."
    Search.TextColor3 = Theme.TextColor; Search.Font = Enum.Font.SourceSansBold; Search.TextSize = 14; Search.Text = ""
    Search.TextStrokeTransparency = 1
    Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)
    local sStroke = Instance.new("UIStroke", Search)
    sStroke.Color = Theme.BorderColor; sStroke.Thickness = 1.5; sStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local TabList = Instance.new("ScrollingFrame", Content)
    TabList.Position = UDim2.new(0, 12, 0, 38); TabList.Size = UDim2.new(1, -24, 0, 32)
    TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", TabList); layout.FillDirection = "Horizontal"; layout.Padding = UDim.new(0, 10); layout.VerticalAlignment = "Center"

    local ElementsArea = Instance.new("Frame", Content)
    ElementsArea.Position = UDim2.new(0, 12, 0, 80); ElementsArea.Size = UDim2.new(1, -24, 1, -100); ElementsArea.BackgroundTransparency = 1

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 100, 0, 26); TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = Enum.Font.SourceSansBold; TabBtn.TextSize = 14
        TabBtn.TextStrokeTransparency = 1
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        
        -- TAB BOX BORDER (NO TEXT BORDER)
        local tBtnStroke = Instance.new("UIStroke", TabBtn)
        tBtnStroke.Color = Theme.BorderColor; tBtnStroke.Thickness = 1.5; tBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.Visible = false; TabPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            TabPage.Visible = true
            for _, b in pairs(TabList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        return {
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end,
            CreateToggle = function(_, D) return ElementsAPI.CreateToggle(TabPage, D, Theme) end,
            CreateSlider = function(_, D) return ElementsAPI.CreateSlider(TabPage, D, Theme) end,
            CreateDropdown = function(_, D) return ElementsAPI.CreateDropdown(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
