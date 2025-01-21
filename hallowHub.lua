-- UI Library

local UI = {}
UI.__index = UI

function UI.new()
    local instance = setmetatable({}, UI)
    instance:CreateUI()
    return instance
end

function UI:CreateUI()
    -- Create ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "MyUI"
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    -- Create Main Frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, 800, 0, 500)
    self.mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    self.mainFrame.Visible = false
    self.mainFrame.Parent = self.screenGui

    -- Create Left Side
    self.leftSide = Instance.new("Frame")
    self.leftSide.Name = "LeftSide"
    self.leftSide.Size = UDim2.new(0, 200, 1, 0)
    self.leftSide.Position = UDim2.new(0, 0, 0, 0)
    self.leftSide.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.leftSide.BorderSizePixel = 0
    self.leftSide.Parent = self.mainFrame

    -- Create Divider
    self.divider = Instance.new("Frame")
    self.divider.Name = "Divider"
    self.divider.Size = UDim2.new(0, 2, 1, 0)
    self.divider.Position = UDim2.new(0, 200, 0, 0)
    self.divider.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    self.divider.BorderSizePixel = 0
    self.divider.Parent = self.mainFrame

    -- Create Minimize Button
    self.minimizeButton = Instance.new("TextButton")
    self.minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    self.minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    self.minimizeButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    self.minimizeButton.Text = "-"
    self.minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    self.minimizeButton.TextSize = 24
    self.minimizeButton.Font = Enum.Font.SourceSansBold
    self.minimizeButton.Parent = self.mainFrame

    -- Create Exit Button
    self.exitButton = Instance.new("TextButton")
    self.exitButton.Size = UDim2.new(0, 30, 0, 30)
    self.exitButton.Position = UDim2.new(1, -35, 0, 5)
    self.exitButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    self.exitButton.Text = "X"
    self.exitButton.TextColor3 = Color3.new(1, 1, 1)
    self.exitButton.TextSize = 18
    self.exitButton.Font = Enum.Font.SourceSansBold
    self.exitButton.Parent = self.mainFrame

    -- Create Reopen Button
    self.reopenButton = Instance.new("TextButton")
    self.reopenButton.Size = UDim2.new(0, 50, 0, 50)
    self.reopenButton.Position = UDim2.new(0.5, -25, 0, 10)
    self.reopenButton.BackgroundColor3 = Color3.fromRGB(112, 41, 99)
    self.reopenButton.Text = "🎃"
    self.reopenButton.TextSize = 36
    self.reopenButton.Font = Enum.Font.SourceSansBold
    self.reopenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    self.reopenButton.Visible = false
    self.reopenButton.Parent = self.screenGui

    -- Create Loading Text
    self.loadingText = Instance.new("TextLabel")
    self.loadingText.Size = UDim2.new(1, 0, 0.5, 0)
    self.loadingText.Position = UDim2.new(0, 0, 0.2, 0)
    self.loadingText.BackgroundTransparency = 1
    self.loadingText.Text = "MyUI"
    self.loadingText.TextColor3 = Color3.new(1, 1, 1)
    self.loadingText.TextSize = 96
    self.loadingText.Font = Enum.Font.GothamBold
    self.loadingText.TextStrokeColor3 = Color3.new(0, 0, 0)
    self.loadingText.TextStrokeTransparency = 0
    self.loadingText.Parent = self.screenGui

    -- Create Loading Dots
    self.loadingDots = Instance.new("TextLabel")
    self.loadingDots.Size = UDim2.new(1, 0, 0, 100)
    self.loadingDots.Position = UDim2.new(0, 0, 0.35, 0)
    self.loadingDots.BackgroundTransparency = 1
    self.loadingDots.Text = ""
    self.loadingDots.TextColor3 = Color3.new(1, 1, 1)
    self.loadingDots.TextSize = 100
    self.loadingDots.Font = Enum.Font.GothamBold
    self.loadingDots.TextStrokeColor3 = Color3.fromRGB(114, 0, 88)
    self.loadingDots.TextStrokeTransparency = 0.3
    self.loadingDots.Parent = self.screenGui

    -- Create Pumpkin
    self.pumpkin = Instance.new("TextLabel")
    self.pumpkin.Size = UDim2.new(0, 100, 0, 100)
    self.pumpkin.Position = UDim2.new(0.5, -50, 0.5, -50)
    self.pumpkin.BackgroundTransparency = 1
    self.pumpkin.Text = "🎃"
    self.pumpkin.TextSize = 0
    self.pumpkin.TextScaled = true
    self.pumpkin.Font = Enum.Font.GothamBold
    self.pumpkin.Visible = false
    self.pumpkin.Parent = self.screenGui

    -- Connect Events
    self.minimizeButton.MouseButton1Click:Connect(function()
        self.mainFrame.Visible = false
        self.reopenButton.Visible = true
    end)

    self.exitButton.MouseButton1Click:Connect(function()
        self:ExitAnimation()
    end)

    self.reopenButton.MouseButton1Click:Connect(function()
        self.mainFrame.Visible = true
        self.reopenButton.Visible = false
    end)

    -- Animate Loading Text
    local textTween = TweenService:Create(self.loadingText, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        TextSize = 60,
        Rotation = 360
    })
    textTween:Play()

    textTween.Completed:Connect(function()
        for _ = 1, 2 do
            for i = 1, 3 do
                self.loadingDots.Text = string.rep(".", i)
                wait(0.16)
            end
            self.loadingDots.Text = ""
            wait(0.16)
        end

        local fadeOutTween = TweenService:Create(self.loadingText, TweenInfo.new(0.5), {
            TextTransparency = 1
        })
        local dotsFadeOutTween = TweenService:Create(self.loadingDots, TweenInfo.new(0.5), {
            TextTransparency = 1
        })
        fadeOutTween:Play()
        dotsFadeOutTween:Play()

        fadeOutTween.Completed:Connect(function()
            self.loadingText:Destroy()
            self.loadingDots:Destroy()

            self.pumpkin.Visible = true
            self.pumpkin.TextSize = 100
            local pumpkinTween = TweenService:Create(self.pumpkin, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(2, 0, 2, 0),
                Position = UDim2.new(-0.5, 0, -0.5, 0),
                TextTransparency = 1
            })
            pumpkinTween:Play()

            pumpkinTween.Completed:Connect(function()
                self.pumpkin:Destroy()
                self.mainFrame.Visible = true
            end)
        end)
    end)
end

function UI:ExitAnimation()
    for i = 1, 50 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(5, 20), 0, math.random(5, 20))
        particle.Position = UDim2.new(0.5, 0, 0.5, 0)
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.BackgroundColor3 = Color3.fromRGB(math.random(200, 255), math.random(100, 200), 0)
        particle.BorderSizePixel = 0
        particle.Parent = self.mainFrame

        local angle = math.random() * math.pi * 2
        local distance = math.random(100, 300)
        local duration = math.random(5, 10) / 10

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(particle, tweenInfo, {
            Position = UDim2.new(0.5 + math.cos(angle) * distance / 400, 0, 0.5 + math.sin(angle) * distance / 300, 0),
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = math.random(-360, 360)
        })
        tween:Play()

        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end

    local shrinkTween = TweenService:Create(self.mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    shrinkTween:Play()

    shrinkTween.Completed:Connect(function()
        self.screenGui:Destroy()
    end)
end

function UI:CreateTab(text, yOffset, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansBold
    button.Parent = self.leftSide

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(65, 65, 65),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    if callback then
        button.MouseButton1Click:Connect(callback)
    end

    return button
end

function UI:CreateButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    if callback then
        button.MouseButton1Click:Connect(callback)
    end

    return button
end

function UI:CreateSlider(parent, position, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 200, 0, 20)
    slider.Position = position
    slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    slider.Parent = parent

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(75, 75, 255)
    fill.Parent = slider

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = fill

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 20, 1, 0)
    handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0, 0)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = slider

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle

    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    handle:GetPropertyChangedSignal("Position"):Connect(function()
        fill.Size = UDim2.new(handle.Position.X.Scale, 0, 1, 0)
        local value = min + (max - min) * handle.Position.X.Scale
        if callback then
            callback(value)
        end
    end)

    return slider
end

function UI:CreateToggle(parent, position, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = position
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggle.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 28, 0, 28)
    knob.Position = default and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
    knob.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    knob.Parent = toggle

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = default

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            knob:TweenPosition(state and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14), "Out", "Quad", 0.2, true)
            knob.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if callback then
                callback(state)
            end
        end
    end)

    return toggle
end

function UI:CreateLabel(text, size, position, parent)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(0, 200, 0, 50)
    label.Position = position or UDim2.new(0.5, -100, 0.5, -25)
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    label.Text = text or "Label"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 18
    label.Font = Enum.Font.SourceSansBold
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Parent = parent or self.mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label

    label.MouseEnter:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        }):Play()
    end)
    label.MouseLeave:Connect(function()
        TweenService:Create(label, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
    end)

    return label
end

return UI
