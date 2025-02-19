local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Constants
local ACCENT = Color3.fromRGB(255, 85, 127)
local BACKGROUND = Color3.fromRGB(25, 25, 25)
local EASING = Enum.EasingStyle.Quint
local TRANSITION_TIME = 0.25

function Library:CreateWindow(title)
    local window = setmetatable({}, Library)
    
    -- Main Container
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "NeonUI"
    window.gui.ResetOnSpawn = false
    window.gui.Parent = game:GetService("CoreGui")

    -- Main Frame
    window.main = Instance.new("Frame")
    window.main.Size = UDim2.new(0, 450, 0, 350)
    window.main.Position = UDim2.new(0.5, -225, 0.5, -175)
    window.main.AnchorPoint = Vector2.new(0.5, 0.5)
    window.main.BackgroundColor3 = BACKGROUND
    window.main.Parent = window.gui

    -- Add modern effects
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://8573778321"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.ZIndex = -1
    shadow.Parent = window.main

    -- Top Bar
    window.topBar = Instance.new("Frame")
    window.topBar.Size = UDim2.new(1, 0, 0, 40)
    window.topBar.BackgroundColor3 = BACKGROUND
    window.topBar.Parent = window.main

    -- Add draggable functionality
    window:Draggable(window.topBar)

    -- Title
    window.title = Instance.new("TextLabel")
    window.title.Text = title
    window.title.Font = Enum.Font.GothamBold
    window.title.TextColor3 = Color3.new(1, 1, 1)
    window.title.TextSize = 18
    window.title.Size = UDim2.new(0.7, 0, 1, 0)
    window.title.Position = UDim2.new(0.05, 0, 0, 0)
    window.title.TextXAlignment = Enum.TextXAlignment.Left
    window.title.BackgroundTransparency = 1
    window.title.Parent = window.topBar

    -- Tab System
    window.tabHolder = Instance.new("ScrollingFrame")
    window.tabHolder.Size = UDim2.new(0.25, 0, 1, -40)
    window.tabHolder.Position = UDim2.new(0, 0, 0, 40)
    window.tabHolder.BackgroundTransparency = 1
    window.tabHolder.ScrollBarThickness = 4
    window.tabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    window.tabHolder.Parent = window.main

    -- Content Area
    window.content = Instance.new("Frame")
    window.content.Size = UDim2.new(0.75, 0, 1, -40)
    window.content.Position = UDim2.new(0.25, 0, 0, 40)
    window.content.BackgroundTransparency = 1
    window.content.Parent = window.main

    return window
end

function Library:CreateTab(name)
    local tab = {}
    tab.name = name
    
    -- Tab Button
    tab.button = Instance.new("TextButton")
    tab.button.Text = name
    tab.button.Size = UDim2.new(0.9, 0, 0, 35)
    tab.button.Position = UDim2.new(0.05, 0, 0, #self.tabHolder:GetChildren() * 40)
    tab.button.BackgroundColor3 = BACKGROUND
    tab.button.TextColor3 = Color3.new(1, 1, 1)
    tab.button.Font = Enum.Font.Gotham
    tab.button.TextSize = 14
    tab.button.Parent = self.tabHolder

    -- Tab Content
    tab.content = Instance.new("ScrollingFrame")
    tab.content.Size = UDim2.new(1, 0, 1, 0)
    tab.content.BackgroundTransparency = 1
    tab.content.ScrollBarThickness = 4
    tab.content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.content.Visible = false
    tab.content.Parent = self.content

    -- Activate first tab
    if #self.tabHolder:GetChildren() == 1 then
        tab.content.Visible = true
        tab.button.BackgroundColor3 = ACCENT
    end

    -- Tab switching logic
    tab.button.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.content:GetChildren()) do
            otherTab.Visible = false
        end
        tab.content.Visible = true
        
        -- Animate button colors
        self:Tween(tab.button, {BackgroundColor3 = ACCENT})
        for _, btn in pairs(self.tabHolder:GetChildren()) do
            if btn ~= tab.button then
                self:Tween(btn, {BackgroundColor3 = BACKGROUND})
            end
        end
    end)

    return tab
end

function Library:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, #tab.content:GetChildren() * 40)
    button.BackgroundColor3 = BACKGROUND
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = tab.content

    -- Hover effects
    button.MouseEnter:Connect(function()
        self:Tween(button, {BackgroundColor3 = ACCENT:Lerp(Color3.new(1,1,1), 0.1)})
    end)
    
    button.MouseLeave:Connect(function()
        self:Tween(button, {BackgroundColor3 = BACKGROUND})
    end)

    -- Click handler
    button.MouseButton1Click:Connect(function()
        self:Tween(button, {Size = UDim2.new(0.85, 0, 0, 35)}, {
            easing = Enum.EasingStyle.Back,
            direction = Enum.EasingDirection.Out,
            time = 0.2
        }, function()
            self:Tween(button, {Size = UDim2.new(0.9, 0, 0, 35)})
        end)
        
        callback()
    end)

    return button
end

-- Add other element creation functions (Toggle, Slider, etc.)

function Library:Tween(object, properties, config, callback)
    local tweenInfo = TweenInfo.new(
        config and config.time or TRANSITION_TIME,
        config and config.easing or EASING,
        config and config.direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
end

function Library:Draggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

return Library
