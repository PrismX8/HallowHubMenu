local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Constants
local ACCENT = Color3.fromRGB(255, 85, 127)
local BACKGROUND = Color3.fromRGB(25, 25, 25)
local GRADIENT_TOP = Color3.fromRGB(40, 40, 40)
local GRADIENT_BOTTOM = Color3.fromRGB(20, 20, 20)
local EASING = Enum.EasingStyle.Quint
local TRANSITION_TIME = 0.3

function Library:CreateWindow(title)
    local window = setmetatable({}, Library)

    -- Main Container
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "NeonUI"
    window.gui.ResetOnSpawn = false
    window.gui.Parent = game:GetService("CoreGui")

    -- Blur Effect (Glassmorphism)
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game.Lighting

    -- Main Frame
    window.main = Instance.new("Frame")
    window.main.Size = UDim2.new(0, 450, 0, 350)
    window.main.Position = UDim2.new(0.5, -225, 0.5, -175)
    window.main.AnchorPoint = Vector2.new(0.5, 0.5)
    window.main.BackgroundColor3 = BACKGROUND
    window.main.BackgroundTransparency = 0.15
    window.main.BorderSizePixel = 0
    window.main.Parent = window.gui

    -- Rounded Corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = window.main

    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, GRADIENT_TOP),
        ColorSequenceKeypoint.new(1, GRADIENT_BOTTOM)
    }
    gradient.Parent = window.main

    -- Top Bar
    window.topBar = Instance.new("Frame")
    window.topBar.Size = UDim2.new(1, 0, 0, 40)
    window.topBar.BackgroundTransparency = 1
    window.topBar.Parent = window.main

    -- Make the window draggable
    window:Draggable(window.topBar)

    -- Title
    window.title = Instance.new("TextLabel")
    window.title.Text = title
    window.title.Font = Enum.Font.Ubuntu
    window.title.TextColor3 = Color3.new(1, 1, 1)
    window.title.TextSize = 18
    window.title.Size = UDim2.new(0.7, 0, 1, 0)
    window.title.Position = UDim2.new(0.05, 0, 0, 0)
    window.title.TextXAlignment = Enum.TextXAlignment.Left
    window.title.BackgroundTransparency = 1
    window.title.Parent = window.topBar

    -- Tab System (Sidebar)
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

function Library:CreateTab(name, iconId)
    local tab = {}
    tab.name = name

    -- Tab Button
    tab.button = Instance.new("TextButton")
    tab.button.Size = UDim2.new(0.9, 0, 0, 35)
    tab.button.Position = UDim2.new(0.05, 0, 0, #self.tabHolder:GetChildren() * 40)
    tab.button.BackgroundColor3 = BACKGROUND
    tab.button.TextColor3 = Color3.new(1, 1, 1)
    tab.button.Font = Enum.Font.Gotham
    tab.button.TextSize = 14
    tab.button.Text = name
    tab.button.Parent = self.tabHolder

    -- Rounded Corners for Button
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tab.button

    -- Icon for Tab
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://" .. iconId
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.05, 0, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Parent = tab.button
    end

    -- Tab Content
    tab.content = Instance.new("ScrollingFrame")
    tab.content.Size = UDim2.new(1, 0, 1, 0)
    tab.content.BackgroundTransparency = 1
    tab.content.ScrollBarThickness = 4
    tab.content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.content.Visible = false
    tab.content.Parent = self.content

    -- First tab activates automatically
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

    -- Rounded Corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    -- Hover Effect
    button.MouseEnter:Connect(function()
        self:Tween(button, {BackgroundColor3 = ACCENT:Lerp(Color3.new(1,1,1), 0.1)})
    end)

    button.MouseLeave:Connect(function()
        self:Tween(button, {BackgroundColor3 = BACKGROUND})
    end)

    -- Click Effect
    button.MouseButton1Click:Connect(function()
        callback()
    end)

    return button
end

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
    frame.Active = true
    frame.Draggable = true
end

return Library
