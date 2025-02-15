local HallowHub = {}
HallowHub.__index = HallowHub

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")

ReplicatedFirst:RemoveDefaultLoadingScreen()

-- Constants
local CORNER_RADIUS = 8
local STROKE_THICKNESS = 2
local TWEEN_TIME = 0.3
local EASING_STYLE = Enum.EasingStyle.Quart
local EASING_DIRECTION = Enum.EasingDirection.Out

-- Color palette
local COLORS = {
    BACKGROUND = Color3.fromRGB(35, 35, 35),
    SECONDARY = Color3.fromRGB(45, 45, 45),
    TEXT = Color3.fromRGB(255, 255, 255),
    ACCENT = Color3.fromRGB(255, 68, 0),
    HOVER = Color3.fromRGB(65, 65, 65),
    STROKE = Color3.fromRGB(255, 0, 0),
}

-- Utility functions
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function map(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function HallowHub.new(windowName)
    local self = setmetatable({}, HallowHub)
    self.WindowName = windowName
    self.Tabs = {}
    self.CurrentTab = nil
    self.UIComponents = {}
    self.Dragging = false
    self.DragStart = nil
    self.StartPosition = nil
    self:InitializeUI()
    return self
end

function HallowHub:InitializeUI()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub_" .. self.WindowName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = playerGui

    local viewportSize = workspace.CurrentCamera.ViewportSize
    self.ScaleFactor = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    self.IsPhone = (viewportSize.Y <= 500)

    self:CreateLoadingScreen()
    self:CreateMainUI()
    self:CreateReopenButton()
    self:PlayLoadingAnimation()
end

function HallowHub:CreateLoadingScreen()
    self.LoadingFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLORS.BACKGROUND,
        BackgroundTransparency = 0.2,
    })

    self.LoadingText = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundTransparency = 1,
        Text = "HallowHub",
        TextColor3 = COLORS.TEXT,
        TextSize = 96 * self.ScaleFactor,
        Font = Enum.Font.GothamBold,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = COLORS.ACCENT,
    }, self.LoadingFrame)

    self.LoadingDots = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 100 * self.ScaleFactor),
        Position = UDim2.new(0, 0, 0.35, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = COLORS.TEXT,
        TextSize = 100 * self.ScaleFactor,
        Font = Enum.Font.GothamBold,
    }, self.LoadingFrame)

    self.Pumpkin = self:CreateElement("TextLabel", {
        Text = "🎃",
        TextSize = 100,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
    }, self.LoadingFrame)
end

function HallowHub:CreateMainUI()
    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = self:ScaleUDim2(UDim2.new(0, 800, 0, 500)),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.BACKGROUND,
        Visible = false,
    })

    self:AddUICorner(self.MainFrame, CORNER_RADIUS)
    self:AddUIStroke(self.MainFrame, COLORS.STROKE, STROKE_THICKNESS)

    self.LeftSide = self:CreateElement("Frame", {
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = COLORS.SECONDARY,
    }, self.MainFrame)

    self:CreateUserInfo()

    self.ContentArea = self:CreateElement("Frame", {
        Size = UDim2.new(0.75, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        BackgroundTransparency = 1,
    }, self.MainFrame)

    self:CreateWindowControls()
    self:MakeDraggable(self.MainFrame)
end

function HallowHub:CreateUserInfo()
    local player = Players.LocalPlayer

    if not player or not player:IsDescendantOf(Players) then
        warn("Player not found!")
        return
    end

    local userInfo = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 60 * self.ScaleFactor),
        BackgroundTransparency = 1,
    }, self.LeftSide)

    -- Get player thumbnail
    local thumbnailSuccess, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId, -- Use the UserId property directly
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)

    local avatar = self:CreateElement("ImageLabel", {
        Size = UDim2.new(0, 40 * self.ScaleFactor, 0, 40 * self.ScaleFactor),
        Position = UDim2.new(0, 10 * self.ScaleFactor, 0, 10 * self.ScaleFactor),
        Image = thumbnailSuccess and thumbnail or "rbxasset://textures/ui/LuaApp/graphic/gr-default-avatar.png",
    }, userInfo)
    self:AddUICorner(avatar, 1, true)

    self:CreateElement("TextLabel", {
        Text = player.DisplayName or player.Name,
        Size = UDim2.new(1, -60 * self.ScaleFactor, 0, 20 * self.ScaleFactor),
        Position = UDim2.new(0, 60 * self.ScaleFactor, 0, 10 * self.ScaleFactor),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 18 * self.ScaleFactor,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = COLORS.TEXT,
        BackgroundTransparency = 1,
    }, userInfo)

    self:CreateElement("TextLabel", {
        Text = "@" .. player.Name,
        Size = UDim2.new(1, -60 * self.ScaleFactor, 0, 20 * self.ScaleFactor),
        Position = UDim2.new(0, 60 * self.ScaleFactor, 0, 30 * self.ScaleFactor),
        TextColor3 = Color3.new(0.7, 0.7, 0.7),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 14 * self.ScaleFactor,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
    }, userInfo)
end

function HallowHub:AddTab(tabName)
    local tab = {
        Name = tabName,
        Content = nil,
        Button = nil,
        Elements = {}
    }

    tab.Button = self:CreateElement("TextButton", {
        Text = tabName,
        Size = UDim2.new(1, -20 * self.ScaleFactor, 0, 40 * self.ScaleFactor),
        Position = UDim2.new(0, 10 * self.ScaleFactor, 0, 120 * self.ScaleFactor + (#self.Tabs * 50 * self.ScaleFactor)),
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 18 * self.ScaleFactor,
        Font = Enum.Font.SourceSansBold,
    }, self.LeftSide)
    self:AddUICorner(tab.Button, CORNER_RADIUS)

    tab.Content = self:CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -10 * self.ScaleFactor),
        Position = UDim2.new(0, 0, 0, 10 * self.ScaleFactor),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.ACCENT,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, self.ContentArea)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = tab.Content
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10 * self.ScaleFactor)

    -- Add content padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 10 * self.ScaleFactor)
    contentPadding.PaddingRight = UDim.new(0, 10 * self.ScaleFactor)
    contentPadding.PaddingTop = UDim.new(0, 10 * self.ScaleFactor)
    contentPadding.PaddingBottom = UDim.new(0, 10 * self.ScaleFactor)
    contentPadding.Parent = tab.Content

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = tab.Content
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10 * self.ScaleFactor)

    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end

    return tab
end

function HallowHub:SwitchTab(selectedTab)
    for _, tab in pairs(self.Tabs) do
        tab.Button.BackgroundColor3 = COLORS.SECONDARY
        tab.Content.Visible = false
    end
    selectedTab.Button.BackgroundColor3 = COLORS.HOVER
    selectedTab.Content.Visible = true
    self.CurrentTab = selectedTab
end

function HallowHub:CreateElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent or self.ScreenGui
    return element
end

function HallowHub:AddUICorner(element, cornerRadius, isCircle)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, cornerRadius * self.ScaleFactor)
    corner.Parent = element
end

function HallowHub:AddUIStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness * self.ScaleFactor
    stroke.Parent = element
end

function HallowHub:ScaleUDim2(udim2)
    return UDim2.new(udim2.X.Scale, udim2.X.Offset * self.ScaleFactor, udim2.Y.Scale, udim2.Y.Offset * self.ScaleFactor)
end

function HallowHub:MakeDraggable(element)
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = true
            self.DragStart = input.Position
            self.StartPosition = element.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.Dragging = false
                end
            end)
        end
    end)

    element.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            self.DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == self.DragInput and self.Dragging then
            local delta = input.Position - self.DragStart
            element.Position = UDim2.new(
                self.StartPosition.X.Scale,
                self.StartPosition.X.Offset + delta.X,
                self.StartPosition.Y.Scale,
                self.StartPosition.Y.Offset + delta.Y
            )
        end
    end)
end

function HallowHub:CreateWindowControls()
    self.CloseButton = self:CreateElement("TextButton", {
        Text = "X",
        Size = self:ScaleUDim2(UDim2.new(0, 30, 0, 30)),
        Position = UDim2.new(1, -35 * self.ScaleFactor, 0, 10 * self.ScaleFactor),
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 18 * self.ScaleFactor,
        Font = Enum.Font.SourceSansBold,
    }, self.MainFrame)

    self:AddUICorner(self.CloseButton, CORNER_RADIUS)

    self.CloseButton.MouseButton1Click:Connect(function()
        self:DestroyUI()
    end)

    self.MinimizeButton = self:CreateElement("TextButton", {
        Text = "-",
        Size = self:ScaleUDim2(UDim2.new(0, 30, 0, 30)),
        Position = UDim2.new(1, -70 * self.ScaleFactor, 0, 10 * self.ScaleFactor),
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 18 * self.ScaleFactor,
        Font = Enum.Font.SourceSansBold,
    }, self.MainFrame)

    self:AddUICorner(self.MinimizeButton, CORNER_RADIUS)

    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.ReopenButton.Visible = true
    end)
end

function HallowHub:CreateReopenButton()
    self.ReopenButton = self:CreateElement("TextButton", {
        Size = self:ScaleUDim2(UDim2.new(0, 50, 0, 50)),
        Position = UDim2.new(0.5, 0, 0, 10 * self.ScaleFactor),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(112, 41, 99),
        Text = "🎃",
        TextSize = 36 * self.ScaleFactor,
        Font = Enum.Font.SourceSansBold,
        Visible = false
    }, self.ScreenGui)

    self:AddUICorner(self.ReopenButton, 0.5, true)
    self:AddUIStroke(self.ReopenButton, Color3.fromRGB(255, 68, 0), 2)

    self.ReopenButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = true
        self.ReopenButton.Visible = false
    end)

    self:MakeDraggable(self.ReopenButton)
end

function HallowHub:PlayLoadingAnimation()
    print("PlayLoadingAnimation started")

    -- Safety timeout to ensure loading screen disappears
    local safetyTimeout = task.delay(10, function()
        if self.LoadingFrame and self.LoadingFrame.Parent then
            self.LoadingFrame:Destroy()
        end
        if self.MainFrame then
            self.MainFrame.Visible = true
        end
        warn("Loading animation safety timeout triggered")
    end)

    -- Text Animation
    local textTween = TweenService:Create(self.LoadingText, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        TextSize = 60 * self.ScaleFactor,
        TextTransparency = 0
    })
    textTween:Play()
    textTween.Completed:Wait()
    print("Text animation completed")

    -- Dot Animation
    for _ = 1, 2 do
        for i = 1, 3 do
            self.LoadingDots.Text = string.rep(".", i)
            task.wait(0.3)
        end
        self.LoadingDots.Text = ""
        task.wait(0.3)
    end
    print("Dot animation completed")

    -- Pumpkin Animation
    self.Pumpkin.Visible = true
    local pumpkinTween = TweenService:Create(self.Pumpkin, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200 * self.ScaleFactor, 0, 200 * self.ScaleFactor),
        TextTransparency = 0
    })
    pumpkinTween:Play()
    pumpkinTween.Completed:Wait()
    print("Pumpkin animation completed")

    -- Final transition
    task.wait(0.5) -- Short pause for visual effect

    -- Cleanup loading screen
    if self.LoadingFrame then
        self.LoadingFrame:Destroy()
    end

    -- Ensure MainFrame is visible
    if self.MainFrame then
        self.MainFrame.Visible = true
    end

    -- Cancel safety timeout
    task.cancel(safetyTimeout)
    print("Loading animation completed successfully")
end

function HallowHub:DestroyUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- New UI element creation functions
-- Updated CreateButton function with proper styling and spacing
function HallowHub:CreateButton(tab, properties)
    local defaultProps = {
        Size = UDim2.new(1, -20 * self.ScaleFactor, 0, 40 * self.ScaleFactor),
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 18 * self.ScaleFactor,
        Font = Enum.Font.SourceSansBold,
        AutoButtonColor = true,
        LayoutOrder = #tab.Elements + 1
    }
    
    -- Merge user properties with defaults
    local mergedProps = {}
    for k, v in pairs(defaultProps) do mergedProps[k] = v end
    for k, v in pairs(properties or {}) do mergedProps[k] = v end
    
    local button = self:CreateElement("TextButton", mergedProps, tab.Content)
    self:AddUICorner(button, CORNER_RADIUS)
    self:AddUIStroke(button, COLORS.STROKE, STROKE_THICKNESS)
    
    -- Add internal padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12 * self.ScaleFactor)
    padding.PaddingRight = UDim.new(0, 12 * self.ScaleFactor)
    padding.Parent = button
    
    table.insert(tab.Elements, button)
    return button
end

-- Updated CreateLabel function with proper text alignment
function HallowHub:CreateLabel(tab, properties)
    local defaultProps = {
        Size = UDim2.new(1, -20 * self.ScaleFactor, 0, 24 * self.ScaleFactor),
        BackgroundTransparency = 1,
        TextColor3 = COLORS.TEXT,
        TextSize = 16 * self.ScaleFactor,
        Font = Enum.Font.SourceSansSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = #tab.Elements + 1
    }
    
    -- Merge properties
    local mergedProps = {}
    for k, v in pairs(defaultProps) do mergedProps[k] = v end
    for k, v in pairs(properties or {}) do mergedProps[k] = v end
    
    local label = self:CreateElement("TextLabel", mergedProps, tab.Content)
    
    -- Add label padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10 * self.ScaleFactor)
    padding.PaddingRight = UDim.new(0, 10 * self.ScaleFactor)
    padding.Parent = label
    
    table.insert(tab.Elements, label)
    return label
end

function HallowHub:CreateTextBox(tab, properties)
    local textBox = self:CreateElement("TextBox", properties, tab.Content)
    table.insert(tab.Elements, textBox)
    return textBox
end

function HallowHub:CreateSlider(tab, properties)
    local slider = Instance.new("Frame")
    for prop, value in pairs(properties) do
        slider[prop] = value
    end
    slider.Parent = tab.Content

    local background = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0.2, 0),
        BackgroundColor3 = COLORS.SECONDARY,
        Position = UDim2.new(0, 0, 0.4, 0),
        BorderSizePixel = 0,
    }, slider)

    local thumb = self:CreateElement("Frame", {
        Size = UDim2.new(0, 20, 1, 0),
        BackgroundColor3 = COLORS.ACCENT,
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Draggable = true,
    }, background)

    -- Implement slider drag functionality here
    -- Update the slider's value based on the thumb's position

    table.insert(tab.Elements, slider)
    return slider
end

function HallowHub:CreateDropdown(tab, properties, options)
    local dropdown = self:CreateElement("Frame", properties, tab.Content)

    local button = self:CreateElement("TextButton", {
        Size = UDim2.new(1, 0, 0.2, 0),
        BackgroundColor3 = COLORS.SECONDARY,
        Text = "Select Option",
        Font = Enum.Font.SourceSansBold,
        TextSize = 14,
    }, dropdown)

    local list = self:CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0.8, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = COLORS.SECONDARY,
        Visible = false,
        ScrollBarThickness = 4,
    }, dropdown)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = list
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)

    local isOpen = false
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        list.Visible = isOpen
    end)

    for i, option in ipairs(options) do
        local item = self:CreateElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = COLORS.HOVER,
            Text = option,
            Font = Enum.Font.SourceSansBold,
            TextSize = 14,
        }, list)

        item.MouseButton1Click:Connect(function()
            button.Text = option
            isOpen = false
            list.Visible = false
        end)
    end

    table.insert(tab.Elements, dropdown)
    return dropdown
end

function HallowHub:CreateToggle(tab, properties, callback)
    local toggle = self:CreateElement("TextButton", properties, tab.Content)
    local isOn = false
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Grey color
            toggle.Text = "On" -- Customize the text
        else
            toggle.BackgroundColor3 = COLORS.SECONDARY
            toggle.Text = "Off" -- Customize the text
        end
        if callback then
            callback(isOn)
        end
    end)

    table.insert(tab.Elements, toggle)
    return toggle
end

return HallowHub
