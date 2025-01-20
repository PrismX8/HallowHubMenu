-- HallowHubLib
local HallowHub = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

-- Helper function: Destroy existing UI
local function destroyExistingUI(playerGui, uiName)
    local existingUI = playerGui:FindFirstChild(uiName)
    if existingUI then
        existingUI:Destroy()
    end
end

-- Helper function: Create UI elements
local function createTextButton(props)
    local button = Instance.new("TextButton")
    button.Size = props.Size or UDim2.new(0, 100, 0, 50)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(45, 45, 45)
    button.Text = props.Text or "Button"
    button.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
    button.TextSize = props.TextSize or 18
    button.Font = props.Font or Enum.Font.SourceSansBold
    button.Parent = props.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    -- Add hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = props.HoverBackgroundColor3 or Color3.fromRGB(65, 65, 65)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(45, 45, 45)
        }):Play()
    end)

    return button
end

-- Main function: Create the UI
function HallowHub.createUI(player, options)
    local playerGui = player:WaitForChild("PlayerGui")
    destroyExistingUI(playerGui, options.Name or "HallowHub")

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = options.Name or "HallowHub"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = options.Size or UDim2.new(0, 400, 0, 300)
    mainFrame.Position = options.Position or UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = options.BackgroundColor3 or Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- Create header text
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0.2, 0)
    header.Text = options.HeaderText or "HallowHub"
    header.TextColor3 = Color3.new(1, 1, 1)
    header.TextSize = 24
    header.Font = Enum.Font.GothamBold
    header.BackgroundTransparency = 1
    header.Parent = mainFrame

    -- Add buttons
    local buttonY = 100
    for _, buttonText in ipairs(options.Buttons or {"Home", "Settings", "Credits"}) do
        createTextButton({
            Text = buttonText,
            Position = UDim2.new(0.05, 0, 0, buttonY),
            Parent = mainFrame
        })
        buttonY = buttonY + 50
    end

    return screenGui
end

-- Function to destroy the UI
function HallowHub.destroyUI(player, uiName)
    local playerGui = player:WaitForChild("PlayerGui")
    destroyExistingUI(playerGui, uiName)
end

return HallowHub
