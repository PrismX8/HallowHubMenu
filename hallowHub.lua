local HallowHub = {}
HallowHub.__index = HallowHub

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
    self:DestroyUI()
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub_" .. self.WindowName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui

    local viewportSize = workspace.CurrentCamera.ViewportSize
    scaleFactor = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    isPhone = (viewportSize.Y <= 500)

    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 800 * scaleFactor, 0, 500 * scaleFactor),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Visible = false
    }, self.ScreenGui)

    self:AddUICorner(self.MainFrame, 10)
    self:AddUIStroke(self.MainFrame, Color3.new(1, 0, 0), 2)

    self.TabContainer = self:CreateElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }, self.MainFrame)

    self.ContentContainer = self:CreateElement("ScrollingFrame", {
        Name = "ContentContainer",
        Size = UDim2.new(0.75, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, self.MainFrame)

    self:CreateWindowControls()
    self:MakeDraggable(self.MainFrame)
end

function HallowHub:MakeDraggable(element)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        element.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    element.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
end

function HallowHub:CreateWindowControls()
    self.CloseButton = self:CreateElement("TextButton", {
        Text = "X",
        Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor),
        Position = UDim2.new(1, -35 * scaleFactor, 0, 10 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)

    self.CloseButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(self.MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        self:DestroyUI()
    end)

    self.MinimizeButton = self:CreateElement("TextButton", {
        Text = "-",
        Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor),
        Position = UDim2.new(1, -70 * scaleFactor, 0, 10 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)

    self.MinimizeButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(self.MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
    end)
end

function HallowHub:SetLoadingScreenEnabled(enabled)
    if enabled then
        self.LoadingFrame = self:CreateElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }, self.ScreenGui)

        local loadingText = self:CreateElement("TextLabel", {
            Size = UDim2.new(1, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Text = "HallowHub",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 96 * scaleFactor,
            Font = Enum.Font.GothamBold,
            TextStrokeTransparency = 0
        }, self.LoadingFrame)

        local loadingDots = self:CreateElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 100 * scaleFactor),
            Position = UDim2.new(0, 0, 0.35, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 100 * scaleFactor,
            Font = Enum.Font.GothamBold,
            TextStrokeTransparency = 0.3
        }, self.LoadingFrame)

        local pumpkin = self:CreateElement("TextLabel", {
            Text = "🎃",
            TextSize = 100,
            TextTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }, self.LoadingFrame)

        local pumpkinTween = TweenService:Create(pumpkin, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            TextTransparency = 0.5,
            Rotation = 360
        })
        pumpkinTween:Play()

        local dots = {"", ".", "..", "..."}
        local currentDot = 1
        while self.LoadingFrame.Parent do
            loadingDots.Text = dots[currentDot]
            currentDot = currentDot % 4 + 1
            wait(0.5)
        end
    else
        if self.LoadingFrame then
            self.LoadingFrame:Destroy()
        end
    end
end

function HallowHub:AddTab(tabName)
    local tab = {
        Name = tabName,
        Elements = {},
        Content = nil,
        Button = nil,
        
        AddButton = function(self, buttonName, callback)
            local button = HallowHub:CreateElement("TextButton", {
                Text = buttonName,
                Size = UDim2.new(0.9, 0, 0, 40 * scaleFactor),
                Position = UDim2.new(0.05, 0, 0, #self.Elements * 50 * scaleFactor),
                BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16 * scaleFactor
            }, self.Content)

            HallowHub:AddUICorner(button, 8)
            button.MouseButton1Click:Connect(callback)

            table.insert(self.Elements, button)
            HallowHub:UpdateContentSize(self.Content)
            return button
        end
    }

    tab.Button = self:CreateElement("TextButton", {
        Text = tabName,
        Size = UDim2.new(1, -20 * scaleFactor, 0, 40 * scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18 * scaleFactor
    }, self.TabContainer)

    tab.Content = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, self.ContentContainer)

    local yPosition = 120 * scaleFactor + (#self.Tabs * 50 * scaleFactor)
    tab.Button.Position = UDim2.new(0, 10 * scaleFactor, 0, yPosition)

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

function HallowHub:UpdateContentSize(contentFrame)
    if not contentFrame:IsA("ScrollingFrame") then
        return
    end
    
    local totalHeight = 0
    for _, element in pairs(contentFrame:GetChildren()) do
        if element:IsA("GuiObject") then
            totalHeight = totalHeight + element.AbsoluteSize.Y + 10 * scaleFactor
        end
    end
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
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

function HallowHub:DestroyUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return HallowHub
