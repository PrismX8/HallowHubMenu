local HallowHub = {
    _version = "1.0.0"
}

-- Import necessary services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Constructor function for creating a new instance of the library
function HallowHub.new()
    local self = setmetatable({}, {__index = HallowHub})
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub"
    self.ScreenGui.ResetOnSpawn = false
    return self
end

-- Initialize the UI
function HallowHub:Init()
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Create a new window
function HallowHub:CreateWindow(title)
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = UDim2.new(0, 400, 0, 300)
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    window.Parent = self.ScreenGui
    
    -- Add title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Parent = window
    
    return window
end

-- Create a new tab in the window
function HallowHub:CreateTab(window, name)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, -30)
    tab.Position = UDim2.new(0, 0, 0, 30)
    tab.BackgroundTransparency = 1
    tab.Parent = window
    
    return tab
end

-- Create a button in a tab
function HallowHub:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 30)
    button.Position = UDim2.new(0.5, -100, 0, #tab:GetChildren() * 40)
    button.Text = text
    button.Parent = tab
    
    -- Connect the button click to the callback function
    button.MouseButton1Click:Connect(callback)
    
    return button
end

return HallowHub
