--[[

Internal Interface Suite
Rebranded Library

]]

local Release = "Internal v1.0"
local NotificationDuration = 6.5
local InternalFolder = "Internal"
local ConfigurationFolder = InternalFolder.."/Configurations"
local ConfigurationExtension = ".int"

local InternalLibrary = {
	Flags = {},
	Theme = {
		Default = {
			TextFont = "Code",
			TextColor = Color3.fromRGB(240, 240, 240),

			Background = Color3.fromRGB(15, 15, 15),
			Topbar = Color3.fromRGB(25, 25, 25),
			Shadow = Color3.fromRGB(10, 10, 10),

			NotificationBackground = Color3.fromRGB(20, 20, 20),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

			TabBackground = Color3.fromRGB(30, 30, 30),
			TabStroke = Color3.fromRGB(45, 45, 45),
			TabBackgroundSelected = Color3.fromRGB(255, 120, 0),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			SelectedTabTextColor = Color3.fromRGB(20, 20, 20),

			ElementBackground = Color3.fromRGB(22, 22, 22),
			ElementBackgroundHover = Color3.fromRGB(28, 28, 28),
			SecondaryElementBackground = Color3.fromRGB(18, 18, 18), 
			ElementStroke = Color3.fromRGB(40, 40, 40),
			SecondaryElementStroke = Color3.fromRGB(35, 35, 35),

			SliderBackground = Color3.fromRGB(40, 40, 40),
			SliderProgress = Color3.fromRGB(255, 120, 0),
			SliderStroke = Color3.fromRGB(50, 50, 50),

			ToggleBackground = Color3.fromRGB(25, 25, 25),
			ToggleEnabled = Color3.fromRGB(255, 120, 0),
			ToggleDisabled = Color3.fromRGB(60, 60, 60),
			ToggleEnabledStroke = Color3.fromRGB(255, 150, 50),
			ToggleDisabledStroke = Color3.fromRGB(70, 70, 70),
			ToggleEnabledOuterStroke = Color3.fromRGB(30, 30, 30),
			ToggleDisabledOuterStroke = Color3.fromRGB(20, 20, 20),

			InputBackground = Color3.fromRGB(20, 20, 20),
			InputStroke = Color3.fromRGB(50, 50, 50),
			PlaceholderColor = Color3.fromRGB(100, 100, 100)
		}
	}
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local InternalUI = game:GetObjects("rbxassetid://10804731440")[1]
InternalUI.Enabled = false

if gethui then
	InternalUI.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(InternalUI)
	InternalUI.Parent = CoreGui
else
	InternalUI.Parent = CoreGui
end

local Main = InternalUI.Main
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList

InternalUI.DisplayOrder = 100
LoadingFrame.Version.Text = Release
LoadingFrame.Title.Text = "INTERNAL"

local request = (syn and syn.request) or (http and http.request) or http_request
local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local Notifications = InternalUI.Notifications
local SelectedTheme = InternalLibrary.Theme.Default

function ChangeTheme(ThemeName)
	SelectedTheme = InternalLibrary.Theme[ThemeName]
	for _, obj in ipairs(InternalUI:GetDescendants()) do
		if obj.ClassName == "TextLabel" or obj.ClassName == "TextBox" or obj.ClassName == "TextButton" then
			if SelectedTheme.TextFont ~= "Default" then 
				obj.TextColor3 = SelectedTheme.TextColor
				obj.Font = SelectedTheme.TextFont
			end
		end
	end
	Main.BackgroundColor3 = SelectedTheme.Background
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow
end

local function AddDraggingFunctionality(DragPoint, MainObj)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		DragPoint.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = MainObj.Position
				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
				end)
			end
		end)
		DragPoint.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
		end)
		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				TweenService:Create(MainObj, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
			end
		end)
	end)
end

AddDraggingFunctionality(Topbar, Main)

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end
local function LoadConfiguration(Configuration)
	local Data = HttpService:JSONDecode(Configuration)
	for FlagName, FlagValue in next, Data do
		if InternalLibrary.Flags[FlagName] then
			spawn(function() 
				if InternalLibrary.Flags[FlagName].Type == "ColorPicker" then
					InternalLibrary.Flags[FlagName]:Set(UnpackColor(FlagValue))
				else
					if InternalLibrary.Flags[FlagName].CurrentValue or InternalLibrary.Flags[FlagName].CurrentKeybind or InternalLibrary.Flags[FlagName].CurrentOption or InternalLibrary.Flags[FlagName].Color ~= FlagValue then InternalLibrary.Flags[FlagName]:Set(FlagValue) end
				end     
			end)
		else
			InternalLibrary:Notify({Title = "Flag Error", Content = "Internal was unable to find '"..FlagName.. "'' in the current script"})
		end
	end
end

local function SaveConfiguration()
	if not CEnabled then return end
	local Data = {}
	for i,v in pairs(InternalLibrary.Flags) do
		if v.Type == "ColorPicker" then
			Data[i] = PackColor(v.Color)
		else
			Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
		end
	end	
	writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
end

local neon = (function()
	local module = {}
	local binds = {}
	local root = Instance.new('Folder', Camera)
	root.Name = 'InternalNeon'

	function module:BindFrame(frame, properties)
		if binds[frame] then return binds[frame].parts end
		local uid = "internal_"..math.random(1,10000)
		local parts = {}
		local f = Instance.new('Folder', root)
		f.Name = frame.Name
		-- (Simplified Neon logic to save character space for UI elements)
		binds[frame] = {uid = uid, parts = parts}
		return parts
	end

	function module:UnbindFrame(frame)
		local cb = binds[frame]
		if cb then
			for _, v in pairs(cb.parts) do v:Destroy() end
			binds[frame] = nil
		end
	end
	return module
end)()

function InternalLibrary:Notify(NotificationSettings)
	spawn(function()
		local ActionCompleted = true
		local Notification = Notifications.Template:Clone()
		Notification.Parent = Notifications
		Notification.Name = NotificationSettings.Title or "System Alert"
		Notification.Visible = true

		if NotificationSettings.Actions then
			for _, Action in pairs(NotificationSettings.Actions) do
				ActionCompleted = false
				local NewAction = Notification.Actions.Template:Clone()
				NewAction.BackgroundColor3 = SelectedTheme.NotificationActionsBackground
				NewAction.Visible = true
				NewAction.Parent = Notification.Actions
				NewAction.Text = Action.Name
				NewAction.MouseButton1Click:Connect(function()
					pcall(Action.Callback)
					ActionCompleted = true
				end)
			end
		end

		Notification.BackgroundColor3 = SelectedTheme.Background
		Notification.Title.Text = NotificationSettings.Title or "INTERNAL"
		Notification.Title.TextColor3 = SelectedTheme.TextColor
		Notification.Description.Text = NotificationSettings.Content or "No Content"
		Notification.Description.TextColor3 = SelectedTheme.TextColor
		
		Notification.Size = UDim2.new(0, 260, 0, 80)
		Notification.BackgroundTransparency = 1
		TweenService:Create(Notification, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.1, Size = UDim2.new(0, 295, 0, 91)}):Play()
		
		wait(NotificationSettings.Duration or NotificationDuration)
		repeat wait() until ActionCompleted
		
		TweenService:Create(Notification, TweenInfo.new(0.6), {BackgroundTransparency = 1, Size = UDim2.new(0, 260, 0, 0)}):Play()
		wait(0.6)
		Notification:Destroy()
	end)
end
function InternalLibrary:CreateWindow(Settings)
	local WindowName = Settings.Name or "Internal Suite"
	local ConfigSettings = Settings.ConfigurationSaving or {}
	
	if ConfigSettings.Enabled then
		CEnabled = true
		CFileName = ConfigSettings.FileName or "Config"
		if not isfolder(InternalFolder) then makefolder(InternalFolder) end
		if not isfolder(ConfigurationFolder) then makefolder(ConfigurationFolder) end
	end

	Main.Topbar.Title.Text = WindowName
	InternalUI.Enabled = true

	-- Loading Animation
	LoadingFrame.Title.Text = "INTERNAL"
	LoadingFrame.Visible = true
	wait(0.8)
	TweenService:Create(LoadingFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
	wait(0.5)
	LoadingFrame.Visible = false

	local Window = {}

	function Window:CreateTab(Name, Image)
		local Tab = Elements.Template:Clone()
		local TabButton = TabList.Template:Clone()

		Tab.Name = Name
		Tab.Parent = Elements
		Tab.Visible = false

		TabButton.Parent = TabList
		TabButton.Title.Text = Name
		TabButton.Visible = true
		TabButton.Name = Name

		if Image then
			TabButton.Image.Image = "rbxassetid://"..tostring(Image)
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, Page in ipairs(Elements:GetChildren()) do
				if Page.ClassName == "ScrollingFrame" then Page.Visible = false end
			end
			for _, Btn in ipairs(TabList:GetChildren()) do
				if Btn.ClassName == "Frame" and Btn.Name ~= "Placeholder" then
					TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(Btn.Title, TweenInfo.new(0.3), {TextTransparency = 0.2}):Play()
				end
			end
			Tab.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		end)

		local Container = {}

		-- [ Buttons ] --
		function Container:CreateButton(ButtonSettings)
			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Parent = Tab
			Button.Visible = true
			Button.Title.Text = ButtonSettings.Name

			Button.MouseButton1Click:Connect(function()
				pcall(ButtonSettings.Callback)
				local ClickTween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				ClickTween:Play()
				ClickTween.Completed:Wait()
				TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)
			return Button
		end

		-- [ Toggles ] --
		function Container:CreateToggle(ToggleSettings)
			local Toggle = Elements.Template.Toggle:Clone()
			local Toggled = ToggleSettings.CurrentValue or false
			Toggle.Name = ToggleSettings.Name
			Toggle.Parent = Tab
			Toggle.Visible = true
			Toggle.Title.Text = ToggleSettings.Name

			local function UpdateToggle()
				if Toggled then
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.3), {BackgroundColor3 = SelectedTheme.ToggleEnabled, Position = UDim2.new(1, -20, 0.5, 0)}):Play()
				else
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.3), {BackgroundColor3 = SelectedTheme.ToggleDisabled, Position = UDim2.new(0, 2, 0.5, 0)}):Play()
				end
				pcall(ToggleSettings.Callback, Toggled)
			end

			Toggle.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				UpdateToggle()
			end)
			
			UpdateToggle()
			return Toggle
		end

		return Container
	end

	return Window
end
-- [ Sliders ] --
		function Container:CreateSlider(SliderSettings)
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Parent = Tab
			Slider.Visible = true
			Slider.Title.Text = SliderSettings.Name
			
			local Min = SliderSettings.Range[1]
			local Max = SliderSettings.Range[2]
			local CurrentValue = SliderSettings.CurrentValue or Min
			
			local function UpdateSlider()
				local Percent = (CurrentValue - Min) / (Max - Min)
				Slider.Main.Progress.Size = UDim2.new(Percent, 0, 1, 0)
				Slider.Main.Value.Text = tostring(CurrentValue)
				pcall(SliderSettings.Callback, CurrentValue)
			end

			-- Simplified dragging logic for sliders
			Slider.Main.MouseButton1Down:Connect(function()
				local Connection
				Connection = RunService.RenderStepped:Connect(function()
					local MousePos = UserInputService:GetMouseLocation().X
					local SliderPos = Slider.Main.AbsolutePosition.X
					local SliderWidth = Slider.Main.AbsoluteSize.X
					local NewPercent = math.clamp((MousePos - SliderPos) / SliderWidth, 0, 1)
					CurrentValue = math.floor(Min + (Max - Min) * NewPercent)
					UpdateSlider()
				end)
				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Connection then Connection:Disconnect() end
					end
				end)
			end)

			UpdateSlider()
			return Slider
		end

		-- [ Inputs ] --
		function Container:CreateInput(InputSettings)
			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Parent = Tab
			Input.Visible = true
			Input.Title.Text = InputSettings.Name
			Input.Main.InputBox.PlaceholderText = InputSettings.Placeholder or "Type here..."

			Input.Main.InputBox.FocusLost:Connect(function()
				pcall(InputSettings.Callback, Input.Main.InputBox.Text)
			end)
			return Input
		end

		-- [ Dropdowns ] --
		function Container:CreateDropdown(DropdownSettings)
			local Dropdown = Elements.Template.Dropdown:Clone()
			Dropdown.Name = DropdownSettings.Name
			Dropdown.Parent = Tab
			Dropdown.Visible = true
			Dropdown.Title.Text = DropdownSettings.Name
			
			-- Dropdown logic usually involves a scrolling frame toggle
			Dropdown.MouseButton1Click:Connect(function()
				-- Toggle list visibility logic
			end)
			
			return Dropdown
		end

		return Container
	end

	-- Global Management
	function Window:Destroy()
		InternalUI:Destroy()
	end

	return Window
end

-- Final Rebranding of the Topbar Buttons
Topbar.ChangeSize.Image = "rbxassetid://10137941941" -- Custom Exit icon
Topbar.Hide.Image = "rbxassetid://10137941941" -- Custom Minimize icon

-- [[ LIBRARY EXPORT ]] --
return InternalLibrary
