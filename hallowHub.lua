-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove default loading screen
ReplicatedFirst:RemoveDefaultLoadingScreen()

-- Destroy existing UI
local function destroyExistingUI()
    local existingUI = playerGui:FindFirstChild("HallowHub")
    if existingUI then
        existingUI:Destroy()
    end
end

destroyExistingUI()

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HallowHub"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Get screen size
local viewportSize = workspace.CurrentCamera.ViewportSize
local isPhone = (viewportSize.Y <= 500)

-- Scale factor based on screen size
local scaleFactor = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)

-- Function to scale UDim2 values
local function scaleUDim2(udim2)
    return UDim2.new(udim2.X.Scale, udim2.X.Offset * scaleFactor, udim2.Y.Scale, udim2.Y.Offset * scaleFactor)
end

-- Create loading screen
local function createLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundTransparency = 1
    loadingFrame.Parent = screenGui

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0.5, 0)
    loadingText.Position = UDim2.new(0, 0, 0.2, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "HallowHub"
    loadingText.TextColor3 = Color3.new(255,165,0)
    loadingText.TextSize = 96 * scaleFactor
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextStrokeColor3 = Color3.new(0, 0, 0)
    loadingText.TextStrokeTransparency = 0
    loadingText.Parent = loadingFrame

    local loadingDots = Instance.new("TextLabel")
    loadingDots.Size = UDim2.new(1, 0, 0, 100 * scaleFactor)
    loadingDots.Position = UDim2.new(0, 0, 0.35, 0)
    loadingDots.BackgroundTransparency = 1
    loadingDots.Text = ""
    loadingDots.TextColor3 = Color3.new(1, 1, 1)
    loadingDots.TextSize = 100 * scaleFactor
    loadingDots.Font = Enum.Font.GothamBold
    loadingDots.TextStrokeColor3 = Color3.fromRGB(114, 0, 88)
    loadingDots.TextStrokeTransparency = 0.3
    loadingDots.Parent = loadingFrame

    local pumpkin = Instance.new("TextLabel")
    pumpkin.Text = "🎃"
    pumpkin.TextSize = 100
    pumpkin.TextTransparency = 1
    pumpkin.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the pumpkin
    pumpkin.Position = UDim2.new(0.5, 0, 0.5, 0)
    pumpkin.Visible = false

    return loadingFrame, loadingText, loadingDots, pumpkin
end

local loadingFrame, loadingText, loadingDots, pumpkin = createLoadingScreen()

-- Create main UI
local function createMainUI()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 1213 * scaleFactor, 0, 653 * scaleFactor) 
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10 * scaleFactor)
    corner.Parent = mainFrame

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(255, 0, 0)
    outline.Thickness = 2 * scaleFactor
    outline.Parent = mainFrame

    -- Create left side (tab section)
    local leftSide = Instance.new("Frame")
    leftSide.Name = "LeftSide"
    leftSide.Size = UDim2.new(0.25, 0, 1, 0)
    leftSide.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    leftSide.BorderSizePixel = 0
    leftSide.Parent = mainFrame

    local leftSideCorner = Instance.new("UICorner")
    leftSideCorner.CornerRadius = UDim.new(0, 10 * scaleFactor)
    leftSideCorner.Parent = leftSide

    -- Create title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50 * scaleFactor)
    title.BackgroundTransparency = 1
    title.Text = "HallowHub"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24 * scaleFactor
    title.Font = Enum.Font.GothamBold
    title.Parent = leftSide

    -- Create user info
    local userInfo = Instance.new("Frame")
    userInfo.Size = UDim2.new(1, 0, 0, 60 * scaleFactor)
    userInfo.Position = UDim2.new(0, 0, 0, 50 * scaleFactor)
    userInfo.BackgroundTransparency = 1
    userInfo.Parent = leftSide

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 40 * scaleFactor, 0, 40 * scaleFactor)
    avatar.Position = UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
    avatar.BackgroundTransparency = 1
    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    avatar.Parent = userInfo

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -60 * scaleFactor, 0, 20 * scaleFactor)
    displayName.Position = UDim2.new(0, 60 * scaleFactor, 0, 10 * scaleFactor)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.TextColor3 = Color3.new(1, 1, 1)
    displayName.TextSize = 18 * scaleFactor
    displayName.Font = Enum.Font.GothamSemibold
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.Parent = userInfo

    local username = Instance.new("TextLabel")
    username.Size = UDim2.new(1, -60 * scaleFactor, 0, 20 * scaleFactor)
    username.Position = UDim2.new(0, 60 * scaleFactor, 0, 30 * scaleFactor)
    username.BackgroundTransparency = 1
    username.Text = "@" .. player.Name
    username.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    username.TextSize = 14 * scaleFactor
    username.Font = Enum.Font.Gotham
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.Parent = userInfo

    -- Create content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(0.75, 0, 1, 0)
    contentArea.Position = UDim2.new(0.25, 0, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    -- Create minimize and exit buttons
    local function createTopBarButton(name, position, symbol)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = symbol
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 18 * scaleFactor
        button.Font = Enum.Font.SourceSansBold
        button.Parent = mainFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5 * scaleFactor)
        buttonCorner.Parent = button

        return button
    end

    local minimizeButton = createTopBarButton("MinimizeButton", UDim2.new(1, -70 * scaleFactor, 0, 10 * scaleFactor), "-")
    local exitButton = createTopBarButton("ExitButton", UDim2.new(1, -35 * scaleFactor, 0, 10 * scaleFactor), "X")

    -- Create reopen button
    local reopenButton = Instance.new("TextButton")
    reopenButton.Size = UDim2.new(0, 50 * scaleFactor, 0, 50 * scaleFactor)
    reopenButton.Position = UDim2.new(0.5, 0, 0, 10 * scaleFactor)
    reopenButton.AnchorPoint = Vector2.new(0.5, 0)
    reopenButton.BackgroundColor3 = Color3.fromRGB(112, 41, 99)
    reopenButton.Text = "🎃"
    reopenButton.TextSize = 36 * scaleFactor
    reopenButton.Font = Enum.Font.SourceSansBold
    reopenButton.Visible = false
    reopenButton.Parent = screenGui

    local reopenCorner = Instance.new("UICorner")
    reopenCorner.CornerRadius = UDim.new(0.5, 0)
    reopenCorner.Parent = reopenButton

    local reopenStroke = Instance.new("UIStroke")
    reopenStroke.Thickness = 2 * scaleFactor
    reopenStroke.Color = Color3.fromRGB(255, 68, 0)
    reopenStroke.Parent = reopenButton

    return mainFrame, minimizeButton, exitButton, reopenButton, leftSide, contentArea
end


local mainFrame, minimizeButton, exitButton, reopenButton, leftSide, contentArea = createMainUI()

-- UI functionality
local function onMinimizeClick()
    mainFrame.Visible = false
    reopenButton.Visible = true
end

local function onReopenClick()
    mainFrame.Visible = true
    reopenButton.Visible = false
end

minimizeButton.MouseButton1Click:Connect(onMinimizeClick)
exitButton.MouseButton1Click:Connect(onExitClick)
reopenButton.MouseButton1Click:Connect(onReopenClick)

-- Make frames draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )

    frame.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                dragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position =
                    UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    )
end

makeDraggable(mainFrame)
makeDraggable(reopenButton)

-- Create tabs and content
local function createTab(name, yOffset)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(1, -20 * scaleFactor, 0, 40 * scaleFactor)
    tab.Position = UDim2.new(0, 10 * scaleFactor, 0, yOffset)
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.TextSize = 18 * scaleFactor
    tab.Font = Enum.Font.SourceSansBold
    tab.Parent = leftSide

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8 * scaleFactor)
    tabCorner.Parent = tab

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = contentArea

    return tab, content
end

-- Create the "Home" tab
local homeTab, homeContent = createTab("Home", 120 * scaleFactor)

-- Player reference
local player = game.Players.LocalPlayer

-- Set WalkSpeed Function
local function setWalkSpeed(speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speed
end

-- Create TextInput for custom walk speed
local speedInput = Instance.new("TextBox")
speedInput.Name = "speedInput"
speedInput.Size = UDim2.new(0, 200 * scaleFactor, 0, 40 * scaleFactor)
speedInput.Position = UDim2.new(0.5, 0, 0.05, 0)
speedInput.AnchorPoint = Vector2.new(0.5, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.PlaceholderText = "Enter Speed"
speedInput.TextSize = 18 * scaleFactor
speedInput.Font = Enum.Font.SourceSansBold
speedInput.ClearTextOnFocus = false
speedInput.Text = ""

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10 * scaleFactor)
corner.Parent = speedInput

speedInput.Parent = homeContent

-- Create the WalkSpeed Toggle
local walkSpeedToggle = Instance.new("Frame")
walkSpeedToggle.Name = "walkSpeedToggle"
walkSpeedToggle.Size = UDim2.new(0, 200 * scaleFactor, 0, 50 * scaleFactor)
walkSpeedToggle.Position = UDim2.new(0.5, 0, 0.15, 0)
walkSpeedToggle.AnchorPoint = Vector2.new(0.5, 0)
walkSpeedToggle.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10 * scaleFactor)
toggleCorner.Parent = walkSpeedToggle

local toggleText = Instance.new("TextLabel")
toggleText.Size = UDim2.new(0.7, 0, 1, 0)
toggleText.Position = UDim2.new(0, 10 * scaleFactor, 0, 0)
toggleText.BackgroundTransparency = 1
toggleText.Text = "WalkSpeed"
toggleText.TextColor3 = Color3.new(1, 1, 1)
toggleText.TextSize = 18 * scaleFactor
toggleText.Font = Enum.Font.SourceSansBold
toggleText.TextXAlignment = Enum.TextXAlignment.Left
toggleText.Parent = walkSpeedToggle

local toggleButton = Instance.new("Frame")
toggleButton.Size = UDim2.new(0, 40 * scaleFactor, 0, 20 * scaleFactor)
toggleButton.Position = UDim2.new(1, -50 * scaleFactor, 0.5, 0)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.Parent = walkSpeedToggle

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(1, 0)
toggleButtonCorner.Parent = toggleButton

local toggleIndicator = Instance.new("Frame")
toggleIndicator.Size = UDim2.new(0, 16 * scaleFactor, 0, 16 * scaleFactor)
toggleIndicator.Position = UDim2.new(0, 2 * scaleFactor, 0.5, 0)
toggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
toggleIndicator.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
toggleIndicator.Parent = toggleButton

local toggleIndicatorCorner = Instance.new("UICorner")
toggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
toggleIndicatorCorner.Parent = toggleIndicator

walkSpeedToggle.Parent = homeContent

-- Handle WalkSpeed Toggle click event
local isWalkSpeedEnabled = false
local defaultWalkSpeed = 16

walkSpeedToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isWalkSpeedEnabled = not isWalkSpeedEnabled
        if isWalkSpeedEnabled then
            local customSpeed = tonumber(speedInput.Text)
            if customSpeed and customSpeed > 0 then
                setWalkSpeed(customSpeed)
                toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                toggleIndicator:TweenPosition(UDim2.new(1, -18 * scaleFactor, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            else
                isWalkSpeedEnabled = false
                toggleText.Text = "Invalid Speed"
                wait(1)
                toggleText.Text = "WalkSpeed"
            end
        else
            setWalkSpeed(defaultWalkSpeed)
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            toggleIndicator:TweenPosition(UDim2.new(0, 2 * scaleFactor, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
end)


local function switchTab(selectedTab, selectedContent)
    for _, child in pairs(leftSide:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end
    selectedTab.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

    -- Update content area visib
    for _, content in pairs(contentArea:GetChildren()) do
        if content:IsA("Frame") then
            content.Visible = false
        end
    end
    selectedContent.Visible = true

    -- Toggle visib
    speedInput.Visible = (selectedTab == homeTab)
    walkSpeedToggle.Visible = (selectedTab == homeTab)

    -- Toggle mainFrame visib
    if selectedTab == settingsTab then
        mainFrame.Visible = false
        reopenButton.Visible = true
    else
        mainFrame.Visible = true
        reopenButton.Visible = false
    end
end



speedInput.Parent = homeContent 
walkSpeedToggle.Parent = homeContent 


switchTab(homeTab, homeContent)

-- Create another tab 
local settingsTab, settingsContent = createTab("Settings", 170 * scaleFactor)

homeTab.MouseButton1Click:Connect(
    function()
        switchTab(homeTab, homeContent)
    end
)

settingsTab.MouseButton1Click:Connect(
    function()
        switchTab(settingsTab, settingsContent)
    end
)

local function exitAnimation()
    for i = 1, 50 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(5, 20), 0, math.random(5, 20))
        particle.Position = UDim2.new(0.5, 0, 0.5, 0)
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.BackgroundColor3 = Color3.fromRGB(math.random(200, 255), math.random(100, 200), 0)
        particle.BorderSizePixel = 0
        particle.Parent = mainFrame

        local angle = math.random() * math.pi * 2
        local distance = math.random(100, 300)
        local duration = math.random(5, 10) / 10

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween =
            TweenService:Create(
            particle,
            tweenInfo,
            {
                Position = UDim2.new(
                    0.5 + math.cos(angle) * distance / 400,
                    0,
                    0.5 + math.sin(angle) * distance / 300,
                    0
                ),
                Size = UDim2.new(0, 0, 0, 0),
                Rotation = math.random(-360, 360)
            }
        )
        tween:Play()

        tween.Completed:Connect(
            function()
                particle:Destroy()
            end
        )
    end

    local shrinkTween =
        TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }
    )
    shrinkTween:Play()

    shrinkTween.Completed:Connect(
        function()
            screenGui:Destroy()
        end
    )
end

exitButton.MouseButton1Click:Connect(exitAnimation)

reopenButton.MouseButton1Click:Connect(
    function()
        mainFrame.Visible = true
        reopenButton.Visible = false
    end
)

local textTween =
    TweenService:Create(
    loadingText,
    TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    {
        TextSize = 60,
        Rotation = 360
    }
)
textTween:Play()

TweenService:Create(
    loadingText,
    TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    {TextSize = 60 * scaleFactor, TextTransparency = 0}
):Play()
textTween.Completed:Connect(
    function()
        for _ = 1, 2 do
            for i = 1, 3 do
                loadingDots.Text = string.rep(".", i)
                wait(0.16)
            end
            loadingDots.Text = ""
            wait(0.16)
        end

        local fadeOutTween =
            TweenService:Create(
            loadingText,
            TweenInfo.new(0.5),
            {
                TextTransparency = 1
            }
        )
        local dotsFadeOutTween =
            TweenService:Create(
            loadingDots,
            TweenInfo.new(0.5),
            {
                TextTransparency = 1
            }
        )
        fadeOutTween:Play()
        dotsFadeOutTween:Play()

        fadeOutTween.Completed:Connect(
            function()
                loadingText:Destroy()
                loadingDots:Destroy()

                -- Make the pumpkin emoji visible
                pumpkin.Visible = true
                local pumpkinTween =
                    TweenService:Create(
                    pumpkin,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        Size = UDim2.new(2, 0, 2, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0), -- Center the pumpkin
                        TextTransparency = 0
                    }
                )
                pumpkinTween:Play()

                pumpkinTween.Completed:Connect(
                    function()
                        pumpkin:Destroy()
                        mainFrame.Visible = true
                    end
                )
            end
        )
    end
)

local function playExplosionAnimation(position)
    local explosion = createExplosionEffect(position)

    delay(
        0.1,
        function()
            explosion.ParticleEmitter.Enabled = false
        end
    )

    game:GetService("Debris"):AddItem(explosion, 2)
end

local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

loadingFrame.Visible = true
mainFrame.Visible = false

local loadingComplete = Instance.new("BindableEvent")


local function playLoadingAnimation()
    -- Text animation
    local textTween =
        TweenService:Create(
        loadingText,
        TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        {
            TextSize = 60 * scaleFactor,
            TextTransparency = 0
        }
    )
    textTween:Play()
    textTween.Completed:Wait()

    -- Dots animation
    for _ = 1, 2 do
        for i = 1, 3 do
            loadingDots.Text = string.rep(".", i)
            task.wait(0.16)
        end
        loadingDots.Text = ""
        task.wait(0.16)
    end

    -- Fade out loading screen
    local fadeOutTween = TweenService:Create(loadingText, TweenInfo.new(0.5), {TextTransparency = 1})
    local dotsFadeOutTween = TweenService:Create(loadingDots, TweenInfo.new(0.5), {TextTransparency = 1})
    fadeOutTween:Play()
    dotsFadeOutTween:Play()

    fadeOutTween.Completed:Wait()
    loadingComplete:Fire() -- Signal that loading is done
end

playLoadingAnimation()


loadingComplete.Event:Wait()

-- Clean up loading screen and show main menu
loadingFrame:Destroy()
mainFrame.Visible = true

-- Adjust UI for different screen sizes
local function adjustUIForScreenSize()
    local topbarInset = GuiService:GetGuiInset().Y
    reopenButton.Position = UDim2.new(0.5, 0, 0, topbarInset + 10 * scaleFactor)
end

adjustUIForScreenSize()

-- Listen for screen size changes
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adjustUIForScreenSize)
