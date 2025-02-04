local HallowHub = {}
HallowHub.__index = HallowHub

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

ReplicatedFirst:RemoveDefaultLoadingScreen()

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
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui") -- Wait for PlayerGui

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub_" .. self.WindowName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HallowHub_" .. self.WindowName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = playerGui

    local viewportSize = workspace.CurrentCamera.ViewportSize
    self.scaleFactor = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    self.isPhone = (viewportSize.Y <= 500)

    self:CreateLoadingScreen()
    self:CreateMainUI()
    self:CreateReopenButton()
    self:PlayLoadingAnimation()
end

function HallowHub:CreateLoadingScreen()
    self.LoadingFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    }, self.ScreenGui)

    self.LoadingText = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundTransparency = 1,
        Text = "HallowHub",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 96 * self.scaleFactor,
        Font = Enum.Font.GothamBold,
        TextStrokeTransparency = 0
    }, self.LoadingFrame)

    self.LoadingDots = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 100 * self.scaleFactor),
        Position = UDim2.new(0, 0, 0.35, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 100 * self.scaleFactor,
        Font = Enum.Font.GothamBold
    }, self.LoadingFrame)

    self.Pumpkin = self:CreateElement("TextLabel", {
        Text = "🎃",
        TextSize = 100,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, self.LoadingFrame)
end

function HallowHub:CreateMainUI()
    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = self:ScaleUDim2(UDim2.new(0, 800, 0, 500)),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Visible = false
    }, self.ScreenGui)

    self:AddUICorner(self.MainFrame, 10)
    self:AddUIStroke(self.MainFrame, Color3.fromRGB(255, 0, 0), 2)

    self.LeftSide = self:CreateElement("Frame", {
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }, self.MainFrame)

    self:CreateUserInfo()

    self.ContentArea = self:CreateElement("Frame", {
        Size = UDim2.new(0.75, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        BackgroundTransparency = 1
    }, self.MainFrame)

    self:CreateWindowControls()
    self:MakeDraggable(self.MainFrame)
end

function HallowHub:CreateUserInfo()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Verify player exists
    if not player or not player:IsDescendantOf(Players) then
        warn("Player not found!")
        return
    end

    -- Wait for UserId
    local success, errorMsg = pcall(function()
        player:WaitForChild("UserId")
    end)
    if not success then
        warn("UserId error:", errorMsg)
        return
    end

    -- Create user info frame
    local userInfo = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 60 * self.scaleFactor),
        BackgroundTransparency = 1
    }, self.LeftSide)

    -- Get thumbnail with error handling
    local thumbnailSuccess, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)

    -- Create avatar
    local avatar = self:CreateElement("ImageLabel", {
        Size = UDim2.new(0, 40 * self.scaleFactor, 0, 40 * self.scaleFactor),
        Position = UDim2.new(0, 10 * self.scaleFactor, 0, 10 * self.scaleFactor),
        Image = thumbnailSuccess and thumbnail or "rbxasset://textures/ui/LuaApp/graphic/gr-default-avatar.png"
    }, userInfo)
    self:AddUICorner(avatar, 1, true)

    -- Display name label
    self:CreateElement("TextLabel", {
        Text = player.DisplayName or player.Name,
        Size = UDim2.new(1, -60 * self.scaleFactor, 0, 20 * self.scaleFactor),
        Position = UDim2.new(0, 60 * self.scaleFactor, 0, 10 * self.scaleFactor),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 18 * self.scaleFactor,
        Font = Enum.Font.GothamSemibold
    }, userInfo)

    -- Username label
    self:CreateElement("TextLabel", {
        Text = "@" .. player.Name,
        Size = UDim2.new(1, -60 * self.scaleFactor, 0, 20 * self.scaleFactor),
        Position = UDim2.new(0, 60 * self.scaleFactor, 0, 30 * self.scaleFactor),
        TextColor3 = Color3.new(0.7, 0.7, 0.7),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 14 * self.scaleFactor,
        Font = Enum.Font.Gotham
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
        Size = UDim2.new(1, -20 * self.scaleFactor, 0, 40 * self.scaleFactor),
        Position = UDim2.new(0, 10 * self.scaleFactor, 0, 120 * self.scaleFactor + (#self.Tabs * 50 * self.scaleFactor)),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        TextSize = 18 * self.scaleFactor,
        Font = Enum.Font.SourceSansBold
    }, self.LeftSide)
    self:AddUICorner(tab.Button, 8)

    tab.Content = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, self.ContentArea)

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

function HallowHub:CreateElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

function HallowHub:AddUICorner(element, cornerRadius, isCircle)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, cornerRadius * self.scaleFactor)
    corner.Parent = element
end

function HallowHub:AddUIStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness * self.scaleFactor
    stroke.Parent = element
end

function HallowHub:ScaleUDim2(udim2)
    return UDim2.new(udim2.X.Scale, udim2.X.Offset * self.scaleFactor, udim2.Y.Scale, udim2.Y.Offset * self.scaleFactor)
end

function HallowHub:MakeDraggable(element)
    local dragging, dragInput, dragStart, startPos

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
            local delta = input.Position - dragStart
            element.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function HallowHub:CreateWindowControls()
    self.CloseButton = self:CreateElement("TextButton", {
        Text = "X",
        Size = self:ScaleUDim2(UDim2.new(0, 30, 0, 30)),
        Position = UDim2.new(1, -35 * self.scaleFactor, 0, 10 * self.scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)

    self.CloseButton.MouseButton1Click:Connect(function()
        self:DestroyUI()
    end)

    self.MinimizeButton = self:CreateElement("TextButton", {
        Text = "-",
        Size = self:ScaleUDim2(UDim2.new(0, 30, 0, 30)),
        Position = UDim2.new(1, -70 * self.scaleFactor, 0, 10 * self.scaleFactor),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, self.MainFrame)

    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.ReopenButton.Visible = true
    end)
end

function HallowHub:CreateReopenButton()
    self.ReopenButton = self:CreateElement("TextButton", {
        Size = self:ScaleUDim2(UDim2.new(0, 50, 0, 50)),
        Position = UDim2.new(0.5, 0, 0, 10 * self.scaleFactor),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(112, 41, 99),
        Text = "🎃",
        TextSize = 36 * self.scaleFactor,
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
    print("Animation started")
    
    -- Initial text animation
    local textTween = TweenService:Create(self.LoadingText, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        TextSize = 60 * self.scaleFactor,
        TextTransparency = 0
    })
    textTween:Play()
    textTween.Completed:Wait()
    
    print("Text animation completed")

    -- Dot animation
    coroutine.wrap(function()
        for _ = 1, 2 do
            for i = 1, 3 do
                self.LoadingDots.Text = string.rep(".", i)
                task.wait(0.3)
            end
            self.LoadingDots.Text = ""
            task.wait(0.3)
        end
        print("Dot animation completed")
    end)()

    -- Wait for dot animation to finish
    task.wait(2)

    -- Fade out text and dots
    local fadeOutTween = TweenService:Create(self.LoadingText, TweenInfo.new(0.5), {TextTransparency = 1})
    local dotsFadeOutTween = TweenService:Create(self.LoadingDots, TweenInfo.new(0.5), {TextTransparency = 1})
    
    fadeOutTween:Play()
    dotsFadeOutTween:Play()
    
    fadeOutTween.Completed:Wait()
    dotsFadeOutTween.Completed:Wait()
    
    print("Fade out completed")

    -- Pumpkin animation
    self.Pumpkin.Visible = true
    local pumpkinTween = TweenService:Create(self.Pumpkin, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200 * self.scaleFactor, 0, 200 * self.scaleFactor),
        TextTransparency = 0
    })
    pumpkinTween:Play()
    pumpkinTween.Completed:Wait()
    
    print("Pumpkin animation completed")

    -- Final cleanup
    task.wait(0.5)  -- Short pause for visual effect
    self.LoadingFrame:Destroy()
    self.MainFrame.Visible = true
    
    print("Animation finished, main UI visible")
end



function HallowHub:DestroyUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return HallowHub
