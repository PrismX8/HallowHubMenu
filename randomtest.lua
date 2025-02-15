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

-- Default styles for UI elements
local DEFAULT_STYLES = {
    Button = {
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true,
    },
    Label = {
        BackgroundTransparency = 1,
        TextColor3 = COLORS.TEXT,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    },
    TextBox = {
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7),
        TextSize = 14,
        Font = Enum.Font.Gotham,
    },
    Toggle = {
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
    },
    Dropdown = {
        BackgroundColor3 = COLORS.SECONDARY,
        TextColor3 = COLORS.TEXT,
        TextSize = 14,
        Font = Enum.Font.Gotham,
    },
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

-- Create a UI element with default styles
function HallowHub:CreateElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    
    -- Apply default styles based on element type
    local defaultStyle = DEFAULT_STYLES[elementType] or {}
    for prop, value in pairs(defaultStyle) do
        element[prop] = value
    end
    
    -- Apply user-provided properties (override defaults)
    for prop, value in pairs(properties or {}) do
        element[prop] = value
    end
    
    element.Parent = parent or self.ScreenGui
    return element
end

-- Create a button with consistent styling
function HallowHub:CreateButton(tab, properties)
    local button = self:CreateElement("TextButton", properties, tab.Content)
    self:AddUICorner(button, CORNER_RADIUS)
    self:AddUIStroke(button, COLORS.STROKE, STROKE_THICKNESS)
    table.insert(tab.Elements, button)
    return button
end

-- Create a label with consistent styling
function HallowHub:CreateLabel(tab, properties)
    local label = self:CreateElement("TextLabel", properties, tab.Content)
    table.insert(tab.Elements, label)
    return label
end

-- Create a text box with consistent styling
function HallowHub:CreateTextBox(tab, properties)
    local textBox = self:CreateElement("TextBox", properties, tab.Content)
    self:AddUICorner(textBox, CORNER_RADIUS)
    self:AddUIStroke(textBox, COLORS.STROKE, STROKE_THICKNESS)
    table.insert(tab.Elements, textBox)
    return textBox
end

-- Create a toggle button with consistent styling
function HallowHub:CreateToggle(tab, properties, callback)
    local toggle = self:CreateElement("TextButton", properties, tab.Content)
    self:AddUICorner(toggle, CORNER_RADIUS)
    self:AddUIStroke(toggle, COLORS.STROKE, STROKE_THICKNESS)
    
    local isOn = false
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.BackgroundColor3 = isOn and COLORS.ACCENT or COLORS.SECONDARY
        toggle.Text = isOn and "On" or "Off"
        if callback then
            callback(isOn)
        end
    end)
    
    table.insert(tab.Elements, toggle)
    return toggle
end

-- Create a dropdown with consistent styling
function HallowHub:CreateDropdown(tab, properties, options)
    local dropdown = self:CreateElement("Frame", properties, tab.Content)
    self:AddUICorner(dropdown, CORNER_RADIUS)
    self:AddUIStroke(dropdown, COLORS.STROKE, STROKE_THICKNESS)
    
    local button = self:CreateElement("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = COLORS.SECONDARY,
        Text = "Select Option",
        TextColor3 = COLORS.TEXT,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
    }, dropdown)
    
    local list = self:CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = COLORS.SECONDARY,
        Visible = false,
        ScrollBarThickness = 4,
    }, dropdown)
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = list
    
    local isOpen = false
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        list.Visible = isOpen
    end)
    
    for _, option in ipairs(options) do
        local item = self:CreateElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = COLORS.HOVER,
            Text = option,
            TextColor3 = COLORS.TEXT,
            TextSize = 14,
            Font = Enum.Font.Gotham,
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

-- Add rounded corners to an element
function HallowHub:AddUICorner(element, cornerRadius, isCircle)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, cornerRadius)
    corner.Parent = element
end

-- Add a stroke to an element
function HallowHub:AddUIStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = element
end

return HallowHub
