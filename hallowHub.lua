local HallowHubLibrary = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

function HallowHubLibrary.createLoadingScreen(screenGui)
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0.5, 0)
    loadingText.Position = UDim2.new(0, 0, 0.2, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "HallowHub"
    loadingText.TextColor3 = Color3.new(1, 1, 1)
    loadingText.TextSize = 96
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextStrokeColor3 = Color3.new(0, 0, 0)
    loadingText.TextStrokeTransparency = 0
    loadingText.Parent = screenGui

    local loadingDots = Instance.new("TextLabel")
    loadingDots.Size = UDim2.new(1, 0, 0, 100)
    loadingDots.Position = UDim2.new(0, 0, 0.35, 0)
    loadingDots.BackgroundTransparency = 1
    loadingDots.Text = ""
    loadingDots.TextColor3 = Color3.new(1, 1, 1)
    loadingDots.TextSize = 100
    loadingDots.Font = Enum.Font.GothamBold
    loadingDots.TextStrokeColor3 = Color3.fromRGB(114, 0, 88)
    loadingDots.TextStrokeTransparency = 0.3
    loadingDots.Parent = screenGui

    local pumpkin = Instance.new("TextLabel")
    pumpkin.Size = UDim2.new(0, 100, 0, 100)
    pumpkin.Position = UDim2.new(0.5, -50, 0.5, -50)
    pumpkin.BackgroundTransparency = 1
    pumpkin.Text = "🎃"
    pumpkin.TextSize = 0
    pumpkin.TextScaled = true
    pumpkin.Font = Enum.Font.GothamBold
    pumpkin.Visible = false
    pumpkin.Parent = screenGui

    return loadingText, loadingDots, pumpkin
end

function HallowHubLibrary.createMainFrame(screenGui)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(255, 0, 0)
    outline.Thickness = 2
    outline.Parent = mainFrame

    return mainFrame, outline
end

function HallowHubLibrary.createLeftSide(mainFrame)
    local leftSide = Instance.new("Frame")
    leftSide.Name = "LeftSide"
    leftSide.Size = UDim2.new(0.5, 0, 1, 0)
    leftSide.Position = UDim2.new(0, 0, 0, 0)
    leftSide.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    leftSide.BorderSizePixel = 0
    leftSide.Parent = mainFrame

    local leftSideCorner = Instance.new("UICorner")
    leftSideCorner.CornerRadius = UDim.new(0, 10)
    leftSideCorner.Parent = leftSide

    return leftSide
end

function HallowHubLibrary.createLeftColumnButton(text, yOffset, leftSide)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansBold
    button.Parent = leftSide

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    return button
end

function HallowHubLibrary.createReopenButton(screenGui)
    local reopenButton = Instance.new("TextButton")
    reopenButton.Size = UDim2.new(0, 50, 0, 50)
    reopenButton.Position = UDim2.new(0.5, -25, 0, 10)
    reopenButton.BackgroundColor3 = Color3.fromRGB(112, 41, 99)
    reopenButton.Text = "🎃"
    reopenButton.TextSize = 36
    reopenButton.Font = Enum.Font.SourceSansBold
    reopenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    reopenButton.Visible = false
    reopenButton.Parent = screenGui

    local reopenCorner = Instance.new("UICorner")
    reopenCorner.CornerRadius = UDim.new(0.5, 0)
    reopenCorner.Parent = reopenButton

    local reopenStroke = Instance.new("UIStroke")
    reopenStroke.Thickness = 2
    reopenStroke.Color = Color3.fromRGB(255, 68, 0)
    reopenStroke.Parent = reopenButton

    return reopenButton
end

function HallowHubLibrary.applyHoverEffect(button)
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
end

function HallowHubLibrary.changeOutlineColor(outline)
    while true do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local tween1 = TweenService:Create(outline, tweenInfo, {Color = Color3.fromRGB(0, 255, 0)})
        local tween2 = TweenService:Create(outline, tweenInfo, {Color = Color3.fromRGB(0, 0, 255)})
        local tween3 = TweenService:Create(outline, tweenInfo, {Color = Color3.fromRGB(255, 0, 0)})

        tween1:Play()
        wait(2)
        tween2:Play()
        wait(2)
        tween3:Play()
        wait(2)
    end
end
function playLoadingAnimation(loadingText, loadingDots, pumpkin, mainFrame)
    local textTween = TweenService:Create(loadingText, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        TextSize = 60,
        Rotation = 360
    })
    textTween:Play()

    textTween.Completed:Connect(function()
        for _ = 1, 2 do
            for i = 1, 3 do
                loadingDots.Text = string.rep(".", i)
                wait(0.16)
            end
            loadingDots.Text = ""
            wait(0.16)
        end
        
        local fadeOutTween = TweenService:Create(loadingText, TweenInfo.new(0.5), {
            TextTransparency = 1
        })
        local dotsFadeOutTween = TweenService:Create(loadingDots, TweenInfo.new(0.5), {
            TextTransparency = 1
        })
        fadeOutTween:Play()
        dotsFadeOutTween:Play()
        
        fadeOutTween.Completed:Connect(function()
            loadingText:Destroy()
            loadingDots:Destroy()
            
            pumpkin.Visible = true
            pumpkin.TextSize = 100
            local pumpkinTween = TweenService:Create(pumpkin, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(2, 0, 2, 0),
                Position = UDim2.new(-0.5, 0, -0.5, 0),
                TextTransparency = 1
            })
            pumpkinTween:Play()
            
            pumpkinTween.Completed:Connect(function()
                pumpkin:Destroy()
                mainFrame.Visible = true
            end)
        end)
    end)
end

return HallowHubLibrary
