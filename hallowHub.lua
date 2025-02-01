-- HallowHub UI Library v1.0
local HallowHub = {}
HallowHub.__index = HallowHub

-- Internal services and variables
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local scaleFactor = 1
local isPhone = false

function HallowHub.NewWindow(windowName)
    local self = setmetatable({}, HallowHub)
    
    self.WindowName = windowName
    self.Tabs = {}
    self.CurrentTab = nil
    self.UIComponents = {}
    
    self:InitializeUI()
    return self
end

function HallowHub:InitializeUI()
    -- Remove existing UI
    self:DestroyUI()
    
    -- Create screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub_" .. self.WindowName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui
    
    -- Calculate scaling
    local viewportSize = workspace.CurrentCamera.ViewportSize
    scaleFactor = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    isPhone = (viewportSize.Y <= 500)
    
    -- Create main container
    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 800 * scaleFactor, 0, 500 * scaleFactor),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Visible = false
    }, self.ScreenGui)
    
    -- Add window styling
    self:AddUICorner(self.MainFrame, 10)
    self:AddUIStroke(self.MainFrame, Color3.new(1, 0, 0), 2)
    
    -- Create tab area
    self.TabContainer = self:CreateElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }, self.MainFrame)
    
    -- Create content area
    self.ContentContainer = self:CreateElement("ScrollingFrame", {
        Name = "ContentContainer",
        Size = UDim2.new(0.75, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, self.MainFrame)
    
    -- Add window controls
    self:CreateWindowControls()
    self:MakeDraggable(self.MainFrame)
end

function HallowHub:AddTab(tabName)
    local tab = {
        Name = tabName,
        Buttons = {},
        Elements = {}
    }
    
    -- Create tab button
    tab.Button = self:CreateElement("TextButton", {
        Text = tabName,
        Size = UDim2.new(1, -20 * scaleFactor, 0, 40 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18 * scaleFactor
    }, self.TabContainer)
    
    -- Create content frame
    tab.Content = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, self.ContentContainer)
    
    -- Position tab button
    local yPosition = 120 * scaleFactor + (#self.Tabs * 50 * scaleFactor)
    tab.Button.Position = UDim2.new(0, 10 * scaleFactor, 0, yPosition)
    
    -- Add tab interaction
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
        tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tab.Content.Visible = false
    end
    
    selectedTab.Button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    selectedTab.Content.Visible = true
    self.CurrentTab = selectedTab
end

function HallowHub:AddButton(tab, buttonName, callback)
    local button = self:CreateElement("TextButton", {
        Text = buttonName,
        Size = UDim2.new(0.9, 0, 0, 40 * scaleFactor),
        Position = UDim2.new(0.05, 0, 0, #tab.Elements * 50 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(65, 65, 65),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16 * scaleFactor
    }, tab.Content)
    
    self:AddUICorner(button, 8)
    button.MouseButton1Click:Connect(callback)
    
    table.insert(tab.Elements, button)
    self:UpdateContentSize(tab.Content)
    return button
end

function HallowHub:UpdateContentSize(contentFrame)
    local totalHeight = 0
    for _, element in pairs(contentFrame:GetChildren()) do
        if element:IsA("GuiObject") then
            totalHeight += element.AbsoluteSize.Y + 10 * scaleFactor
        end
    end
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function HallowHub:CreateWindowControls()
    -- Close button
    self.CloseButton = self:CreateElement("TextButton", {
        Text = "X",
        Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor),
        Position = UDim2.new(1, -35 * scaleFactor, 0, 10 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:DestroyUI()
    end)
    
    -- Minimize button
    self.MinimizeButton = self:CreateElement("TextButton", {
        Text = "-",
        Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor),
        Position = UDim2.new(1, -70 * scaleFactor, 0, 10 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        -- Add reopen button logic if needed
    end)
end

function HallowHub:CreateElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

function HallowHub:AddUICorner(element, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius * scaleFactor)
    corner.Parent = element
end

function HallowHub:AddUIStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness * scaleFactor
    stroke.Parent = element
end

function HallowHub:MakeDraggable(element)
    -- Draggable implementation from original code
end

function HallowHub:SetLoadingScreenEnabled(enabled)
    if enabled then
        -- Implement loading screen from original code
    end
end

function HallowHub:DestroyUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return HallowHub
