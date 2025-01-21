local UILibrary = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

function UILibrary.new(name)
    local lib = {}
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Destroy existing UI
    local existingUI = playerGui:FindFirstChild(name)
    if existingUI then
        existingUI:Destroy()
    end
    
    -- Remove default loading screen
    ReplicatedFirst:RemoveDefaultLoadingScreen()
    
    -- Create main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 800, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Add UI elements
    function lib:addTab(name, callback)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(0, 180, 0, 40)
        tab.Position = UDim2.new(0, 10, 0, #mainFrame:GetChildren() * 50)
        tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tab.Text = name
        tab.TextColor3 = Color3.new(1, 1, 1)
        tab.Parent = mainFrame
        
        if callback then
            tab.MouseButton1Click:Connect(callback)
        end
        
        return tab
    end
    
    function lib:addButton(text, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 150, 0, 40)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Parent = mainFrame
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end
    
    function lib:addToggle(default, position, callback)
        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0, 60, 0, 30)
        toggle.Position = position
        toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        toggle.Parent = mainFrame
        
        local state = default or false
        
        -- Add toggle functionality
        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                if callback then
                    callback(state)
                end
            end
        end)
        
        return toggle
    end
    
    return lib
end

return UILibrary
