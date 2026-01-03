local Library = {}
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/theme.lua"))().Default
local ElementsAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/internal/main/source/elements.lua"))()

function Library:CreateWindow(Settings)
    local InternalUI = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    
    local Main = Instance.new("Frame", InternalUI)
    Main.BackgroundColor3 = Theme.Background
    Main.Size = UDim2.new(0, 400, 0, 300) -- Original Height
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.BorderColor
    MainStroke.Thickness = 2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 0) -- Square look

    local TabList = Instance.new("Frame", Main)
    TabList.Size = UDim2.new(1, -20, 0, 35)
    TabList.Position = UDim2.new(0, 10, 0, 15)
    TabList.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", TabList)
    Layout.FillDirection = "Horizontal"
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = "Center"

    local ElementsArea = Instance.new("Frame", Main)
    ElementsArea.Size = UDim2.new(1, -20, 1, -70)
    ElementsArea.Position = UDim2.new(0, 10, 0, 60)
    ElementsArea.BackgroundTransparency = 1

    local Window = {}
    function Window:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(0, 90, 0, 28) -- Original Tab Size
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name
        TabBtn.Font = Theme.Font
        TabBtn.TextColor3 = Theme.TextColor
        TabBtn.TextSize = 14
        TabBtn.TextStrokeTransparency = 1
        
        local tStroke = Instance.new("UIStroke", TabBtn)
        tStroke.Color = Theme.BorderColor
        tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0

        -- Minimal Padding just to stop the clip, no layout changes
        local Padding = Instance.new("UIPadding", TabPage)
        Padding.PaddingTop = UDim.new(0, 2) 

        local eLayout = Instance.new("UIListLayout", TabPage)
        eLayout.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ElementsArea:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            TabPage.Visible = true
        end)

        return {
            CreateHeader = function(_, D) return ElementsAPI.CreateHeader(TabPage, D, Theme) end,
            CreateButton = function(_, D) return ElementsAPI.CreateButton(TabPage, D, Theme) end
        }
    end
    return Window
end
return Library
