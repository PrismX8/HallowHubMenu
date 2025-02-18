--new
local library = {}

for i, v in pairs(game.CoreGui:GetDescendants()) do
	if v.Name == "shadow" then
        getgenv().con:Disconnect()
		v.Parent.Parent:Destroy()
	end
end

getgenv().con = nil

local function MakeDraggable(gui) 
    local UserInputService = game:GetService("UserInputService")
    local runService = (game:GetService("RunService"));
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    function Lerp(a, b, m)
        return a + (b - a) * m
    end;
    
    local lastMousePos
    local lastGoalPos
    local DRAG_SPEED = (9)
    function Update(dt)
        if not (startPos) then return end;
        if not (dragging) and (lastGoalPos) then
            gui.Parent.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Parent.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Parent.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
            return 
        end;
    
        local delta = (lastMousePos - UserInputService:GetMouseLocation())
        local xGoal = (startPos.X.Offset - delta.X);
        local yGoal = (startPos.Y.Offset - delta.Y);
        lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
        gui.Parent.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Parent.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Parent.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
    end;
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Parent.Position
            lastMousePos = UserInputService:GetMouseLocation()
    
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    getgenv().con = runService.Heartbeat:Connect(Update)
end

local function GetXY(obj)
	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local Max, May = obj.AbsoluteSize.X,obj.AbsoluteSize.Y
	local Px, Py = math.clamp(Mouse.X - obj.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - obj.AbsolutePosition.Y, 0, May)
	return Px/Max, Py/May
end

function Ripple(obj)
	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local TweenService = game:GetService("TweenService")
	spawn(function()
		local PX, PY = GetXY(obj)
		local Circle = Instance.new("ImageLabel")
		Circle.Name = "Circle"
		Circle.Parent = obj
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1.000
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(210,210,210)
		Circle.ImageTransparency = 0.6
		local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = obj.AbsoluteSize.X
		TweenService:Create(Circle, TweenInfo.new(1), {Position = UDim2.fromScale(PX,PY) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, Size = UDim2.fromOffset(Size,Size)}):Play()
		spawn(function()
			wait(1.2)
			Circle:Destroy()
		end)
	end)
end

function library:Destroy()
    for i, v in pairs(game.CoreGui:GetDescendants()) do
        if v.Name == "shadow" then
            getgenv().con:Disconnect()
            v.Parent.Parent:Destroy()
        end
    end
end

function library:Window(grad1, grad2, name)
	-- Configuration
    local ACCENT_COLOR = Color3.fromRGB(140, 116, 255)
    local BACKGROUND_COLOR = Color3.fromRGB(25, 25, 25)
    local TEXT_COLOR = Color3.fromRGB(240, 240, 240)

    -- Main Window Setup
    local OrbitLibraryClean = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local gradientFrame = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local title = Instance.new("TextLabel")
    local closeBtn = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local Navigation = Instance.new("ScrollingFrame")
    local navContent = Instance.new("Frame")
    local navLayout = Instance.new("UIListLayout")
    local shadow = Instance.new("ImageLabel")
    local blurEffect = Instance.new("BlurEffect")

    OrbitLibraryClean.Name = "ModernUI"
    OrbitLibraryClean.Parent = game.CoreGui
    OrbitLibraryClean.ResetOnSpawn = false

    -- Blur Effect
    blurEffect.Size = 12
    blurEffect.Parent = OrbitLibraryClean

    Main.Name = "Main"
    Main.Parent = OrbitLibraryClean
    Main.BackgroundColor3 = BACKGROUND_COLOR
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Size = UDim2.new(0, 500, 0, 400)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.ClipsDescendants = true

    -- Modern Shadow Effect
    shadow.Name = "shadow"
    shadow.Parent = Main
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://8573778321"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    -- Top Bar with Glassmorphism Effect
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = BACKGROUND_COLOR
    TopBar.BackgroundTransparency = 0.3
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    -- Gradient Line
    gradientFrame.Parent = TopBar
    gradientFrame.BackgroundColor3 = ACCENT_COLOR
    gradientFrame.BorderSizePixel = 0
    gradientFrame.Size = UDim2.new(1, 0, 0, 2)
    gradientFrame.Position = UDim2.new(0, 0, 1, -2)

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, grad1 or ACCENT_COLOR),
        ColorSequenceKeypoint.new(1, grad2 or Color3.fromRGB(100, 80, 220))
    }
    UIGradient.Rotation = -15
    UIGradient.Parent = gradientFrame

    -- Modern Title Text
    title.Parent = TopBar
    title.Text = name or "Modern UI Library"
    title.Font = Enum.Font.GothamSemibold
    title.TextColor3 = TEXT_COLOR
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.03, 0, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)

    -- Stylish Close Button
    closeBtn.Name = "closeBtn"
    closeBtn.Parent = TopBar
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageRectOffset = Vector2.new(924, 724)
    closeBtn.ImageRectSize = Vector2.new(36, 36)
    closeBtn.ImageColor3 = TEXT_COLOR
    closeBtn.BackgroundTransparency = 1

    -- Hover effects
    closeBtn.MouseEnter:Connect(function()
        game.TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            ImageColor3 = ACCENT_COLOR,
            Rotation = 90
        }):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        game.TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            ImageColor3 = TEXT_COLOR,
            Rotation = 0
        }):Play()
    end)

    -- Navigation Panel
    Navigation.Parent = Main
    Navigation.BackgroundTransparency = 1
    Navigation.ScrollBarThickness = 4
    Navigation.ScrollBarImageColor3 = ACCENT_COLOR
    Navigation.Position = UDim2.new(0, 0, 0, 40)
    Navigation.Size = UDim2.new(0, 160, 1, -40)

    navContent.Parent = Navigation
    navContent.BackgroundTransparency = 1
    navContent.Size = UDim2.new(1, 0, 1, 0)

    navLayout.Parent = navContent
    navLayout.Padding = UDim.new(0, 8)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Corner Radius
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    -- Animation Effects
    Main.Size = UDim2.new(0, 0, 0, 0)
    game.TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 500, 0, 400)
    }):Play()

    local function ALERD355_fake_script()
        local script = Instance.new('LocalScript', Main)
        game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.5), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    end
    coroutine.wrap(ALERD355_fake_script)()


    local function ALERD_fake_script()
        local script = Instance.new('LocalScript', Navigation)

        local se = Instance.new("BoolValue")
        se.Value = true
        se.Parent = script
        se.Name = "SmoothingEnabled"

        local iff = Instance.new("ObjectValue")
        iff.Parent = script
        iff.Name = "InputFrame"

        local sf = Instance.new("NumberValue")
        sf.Parent = script
        sf.Value = 0.14
        sf.Name = "SmoothingFactor"

        local content = script.Parent
        content.ScrollingEnabled = not script.SmoothingEnabled.Value 
        
        local input = content:Clone()
        input:ClearAllChildren()
        input.BackgroundTransparency = 1
        input.ScrollBarImageTransparency = 1
        input.ZIndex = content.ZIndex + 1
        input.Name = "_smoothinputframe"
        input.ScrollingEnabled = script.SmoothingEnabled.Value 
        input.Parent = content.Parent
        
        script.SmoothingEnabled:GetPropertyChangedSignal("Value"):Connect(function()
            if script.SmoothingEnabled.Value then
                input.CanvasPosition = content.CanvasPosition
            end
            content.ScrollingEnabled = not script.SmoothingEnabled.Value 
            input.ScrollingEnabled = script.SmoothingEnabled.Value 
        end)
        
        input:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if not script.SmoothingEnabled.Value then
                content.CanvasPosition = input.CanvasPosition
            end
        end)
        
        script.InputFrame.Value = input

        local function syncProperty(prop)
            content:GetPropertyChangedSignal(prop):Connect(function()
                if prop == "ZIndex" then
                    input[prop] = content[prop] + 1
                else
                    input[prop] = content[prop]
                end
            end)
        end
        
        syncProperty "CanvasSize"
        syncProperty "Position"
        syncProperty "Rotation"
        syncProperty "ScrollingDirection"
        syncProperty "ScrollBarThickness"
        syncProperty "BorderSizePixel"
        syncProperty "ElasticBehavior"
        syncProperty "SizeConstraint"
        syncProperty "ZIndex"
        syncProperty "BorderColor3"
        syncProperty "Size"
        syncProperty "AnchorPoint"
        syncProperty "Visible"
        
        local smoothConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if script.SmoothingEnabled.Value then
                local a = content.CanvasPosition
                local b = input.CanvasPosition
                local c = script.SmoothingFactor.Value
                local d = (b - a) * c + a
                content.CanvasPosition = d
            end
        end)
        
        content.AncestryChanged:Connect(function()
            if content.Parent == nil then
                input:Destroy()
                smoothConnection:Disconnect()
            end
        end)
    end
    coroutine.wrap(ALERD_fake_script)()

    function tabHandler:NewTab(name, icon)
        local FrameTAB = Instance.new("Frame")
        local Active = Instance.new("TextLabel")
        local UIPadding = Instance.new("UIPadding")
        local ImageLabel = Instance.new("ImageLabel")
        local Inactive = Instance.new("TextLabel")
        local UIPadding_2 = Instance.new("UIPadding")
        local ImageLabel_2 = Instance.new("ImageLabel")
        local UICorner_3 = Instance.new("UICorner")
        local UIListLayout = Instance.new("UIListLayout")
        local MainArea = Instance.new("ScrollingFrame")
        local windowHandler = {}

        MainArea.Name = name
        MainArea.Parent = Main
        MainArea.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        MainArea.BorderColor3 = Color3.fromRGB(27, 42, 53)
        MainArea.ScrollBarImageColor3 = Color3.fromRGB(61, 61, 61)
        MainArea.BorderSizePixel = 0
        MainArea.Position = UDim2.new(0, 137, 0, 33)
        MainArea.Selectable = false
        MainArea.Size = UDim2.new(0, 338, 0, 260)
        MainArea.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        MainArea.ScrollBarThickness = 3
        MainArea.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

        local function PSGUYO_fake_script()
            local script = Instance.new('LocalScript', MainArea)
    
            local se = Instance.new("BoolValue")
            se.Value = true
            se.Parent = script
            se.Name = "SmoothingEnabled"
    
            local iff = Instance.new("ObjectValue")
            iff.Parent = script
            iff.Name = "InputFrame"
    
            local sf = Instance.new("NumberValue")
            sf.Parent = script
            sf.Value = 0.14
            sf.Name = "SmoothingFactor"
    
            local content = script.Parent
            content.ScrollingEnabled = not script.SmoothingEnabled.Value 
            
            local input = content:Clone()
            input:ClearAllChildren()
            input.BackgroundTransparency = 1
            input.ScrollBarImageTransparency = 1
            input.ZIndex = content.ZIndex + 1
            input.Name = "_smoothinputframe"
            input.ScrollingEnabled = script.SmoothingEnabled.Value 
            input.Parent = content.Parent
            
            script.SmoothingEnabled:GetPropertyChangedSignal("Value"):Connect(function()
                if script.SmoothingEnabled.Value then
                    input.CanvasPosition = content.CanvasPosition
                end
                content.ScrollingEnabled = not script.SmoothingEnabled.Value 
                input.ScrollingEnabled = script.SmoothingEnabled.Value 
            end)
            
            input:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if not script.SmoothingEnabled.Value then
                    content.CanvasPosition = input.CanvasPosition
                end
            end)
            
            script.InputFrame.Value = input
    
            local function syncProperty(prop)
                content:GetPropertyChangedSignal(prop):Connect(function()
                    if prop == "ZIndex" then
                        input[prop] = content[prop] + 1
                    else
                        input[prop] = content[prop]
                    end
                end)
            end
            
            syncProperty "CanvasSize"
            syncProperty "Position"
            syncProperty "Rotation"
            syncProperty "ScrollingDirection"
            syncProperty "ScrollBarThickness"
            syncProperty "BorderSizePixel"
            syncProperty "ElasticBehavior"
            syncProperty "SizeConstraint"
            syncProperty "ZIndex"
            syncProperty "BorderColor3"
            syncProperty "Size"
            syncProperty "AnchorPoint"
            syncProperty "Visible"
            
            local smoothConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if script.SmoothingEnabled.Value then
                    local a = content.CanvasPosition
                    local b = input.CanvasPosition
                    local c = script.SmoothingFactor.Value
                    local d = (b - a) * c + a
                    content.CanvasPosition = d
                end
            end)
            
            content.AncestryChanged:Connect(function()
                if content.Parent == nil then
                    input:Destroy()
                    smoothConnection:Disconnect()
                end
            end)
        end
        coroutine.wrap(PSGUYO_fake_script)()
    
        UIListLayout.Parent = MainArea
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 1)
    
        UICorner_3.Parent = MainArea
    
        FrameTAB.Parent = Frame_3
        FrameTAB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FrameTAB.BackgroundTransparency = 1.000
        FrameTAB.Size = UDim2.new(0, 141, 0, 17)
        FrameTAB.Name = name
        FrameTAB.ClipsDescendants = true

        Active.Name = "Active"
        Active.Parent = FrameTAB
        Active.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
        Active.BackgroundTransparency = 1.000
        Active.Position = UDim2.new(0.275709212, 0, -0.053628359, 0)
        Active.Size = UDim2.new(0, 84, 0, 17)
        Active.Font = Enum.Font.GothamMedium
        Active.Text = name
        Active.TextColor3 = Color3.fromRGB(255, 255, 255)
        Active.TextSize = 14.000
        Active.TextXAlignment = Enum.TextXAlignment.Left
        Active.Visible = false

        UIPadding.Parent = Active
        UIPadding.PaddingLeft = UDim.new(0, 8)

        ImageLabel.Parent = Active
        ImageLabel.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
        ImageLabel.BackgroundTransparency = 1.000
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Position = UDim2.new(-0.41367501, 0, -0.121324055, 0)
        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        if icon then
            ImageLabel.Image = icon
        else
            ImageLabel.Image = "rbxassetid://4370345144"
        end

        Inactive.Name = "Inactive"
        Inactive.Parent = FrameTAB
        Inactive.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
        Inactive.BackgroundTransparency = 1.000
        Inactive.Position = UDim2.new(0.275709212, 0, -0.053628359, 0)
        Inactive.Size = UDim2.new(0, 84, 0, 17)
        Inactive.Visible = false
        Inactive.Font = Enum.Font.Gotham
        Inactive.Text = name
        Inactive.TextColor3 = Color3.fromRGB(211, 211, 211)
        Inactive.TextSize = 14.000
        Inactive.TextXAlignment = Enum.TextXAlignment.Left
        Inactive.Visible = true

        UIPadding_2.Parent = Inactive
        UIPadding_2.PaddingLeft = UDim.new(0, 8)

        ImageLabel_2.Parent = Inactive
        ImageLabel_2.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
        ImageLabel_2.BackgroundTransparency = 1.000
        ImageLabel_2.BorderSizePixel = 0
        ImageLabel_2.Position = UDim2.new(-0.41367501, 0, -0.121324055, 0)
        ImageLabel_2.Size = UDim2.new(0, 20, 0, 20)
        if icon then
            ImageLabel_2.Image = icon
        else
            ImageLabel_2.Image = "rbxassetid://4370345144"
        end
        ImageLabel_2.ImageColor3 = Color3.fromRGB(211, 211, 211)

        FrameTAB.MouseEnter:Connect(function()
            if Inactive.Visible == true then
                game:GetService("TweenService"):Create(Inactive, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end)

        FrameTAB.MouseLeave:Connect(function()
            if Inactive.Visible == true then
                game:GetService("TweenService"):Create(Inactive, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(211, 211, 211)}):Play()
            end
        end)

        FrameTAB.InputBegan:Connect(
            function(InputObject)
                if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    Ripple(FrameTAB)

                    -- disable text 
                    for i, v in pairs(Frame_3:GetChildren()) do
                        if v:IsA("Frame") then
                            v:FindFirstChild("Inactive").Visible = true
                            v:FindFirstChild("Inactive").TextColor3 = Color3.fromRGB(211, 211, 211)
                            v:FindFirstChild("Active").Visible = false
                        end
                    end

                    -- disable windows
                    for i, v in pairs(Main:GetChildren()) do
                        if v:IsA("ScrollingFrame") and v.Name ~= "Navigation" and v.Name ~= "_smoothinputframe" then
                            v.Visible = false
                        end
                    end

                    -- activate our window
                    Main:FindFirstChild(name).Visible = true

                    -- activate our text

                    Active.Visible = true
                    Inactive.Visible = false
                end
            end
        )

        function windowHandler:Button(text, callback)
            local Button = Instance.new("Frame")
            local FRAME23 = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local ImageLabel = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local UiStroke = Instance.new("UIStroke")

            UiStroke.Parent = FRAME23
            UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UiStroke.LineJoinMode = Enum.LineJoinMode.Round
            UiStroke.Thickness = 1
            UiStroke.Color = Color3.fromRGB(58, 58, 58)

            Button.Name = "Button"
            Button.Parent = MainArea
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 1.000
            Button.Position = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
            Button.Size = UDim2.new(0.958999991, 0, 0.0659999996, 0)

            FRAME23.Parent = Button
            FRAME23.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            FRAME23.BackgroundTransparency = 0.700
            FRAME23.BorderColor3 = Color3.fromRGB(27, 42, 53)
            FRAME23.Position = UDim2.new(0.0240000896, 0, 0.218843535, 0)
            FRAME23.Size = UDim2.new(0.982564449, 0, 0.811266065, 0)
            FRAME23.ClipsDescendants = true

            UIPadding.Parent = FRAME23
            UIPadding.PaddingLeft = UDim.new(0, 8)

            ImageLabel.Parent = FRAME23
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1.000
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Position = UDim2.new(0.899999976, 0, 0.16951263, 0)
            ImageLabel.Size = UDim2.new(0, 20, 0, 20)
            ImageLabel.Image = "rbxassetid://3610247188"

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = FRAME23

            TextLabel.Parent = FRAME23
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0281283092, 0, 0.202652007, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)

            FRAME23.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(FRAME23, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end)
            FRAME23.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(FRAME23, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            end)

            FRAME23.InputBegan:Connect(
                function(InputObject)
                    if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                        Ripple(FRAME23)
                        callback()
                    end
                end
            )
    
        end

        function windowHandler:Info(text)
            local Info = Instance.new("Frame")
            local Frame = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local ImageLabel = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local UiStroke = Instance.new("UIStroke")

            UiStroke.Parent = Frame
            UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UiStroke.LineJoinMode = Enum.LineJoinMode.Round
            UiStroke.Thickness = 1
            UiStroke.Color = Color3.fromRGB(58, 58, 58)

            Info.Name = "Info"
            Info.Parent = MainArea
            Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Info.BackgroundTransparency = 1.000
            Info.Position = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
            Info.Size = UDim2.new(0.958999991, 0, 0.0659999996, 0)

            Frame.Parent = Info
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Frame.BackgroundTransparency = 0.700
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(0.0240000896, 0, 0.218843535, 0)
            Frame.Size = UDim2.new(0.982564449, 0, 0.811266065, 0)

            UIPadding.Parent = Frame
            UIPadding.PaddingLeft = UDim.new(0, 8)

            ImageLabel.Parent = Frame
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1.000
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Position = UDim2.new(0.899999976, 0, 0.16951263, 0)
            ImageLabel.Size = UDim2.new(0, 20, 0, 20)
            ImageLabel.Image = "rbxassetid://3944670656"

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0281283092, 0, 0.202652007, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)
        end

        function windowHandler:Label(text)
            local Label = Instance.new("Frame")
            local Frame = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local ImageLabel = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local UiStroke = Instance.new("UIStroke")

            UiStroke.Parent = Frame
            UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UiStroke.LineJoinMode = Enum.LineJoinMode.Round
            UiStroke.Thickness = 1
            UiStroke.Color = Color3.fromRGB(58, 58, 58)

            Label.Name = "Label"
            Label.Parent = MainArea
            Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1.000
            Label.Position = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
            Label.Size = UDim2.new(0.958999991, 0, 0.0659999996, 0)

            Frame.Parent = Label
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Frame.BackgroundTransparency = 0.700
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(0.0240000896, 0, 0.218843535, 0)
            Frame.Size = UDim2.new(0.982564449, 0, 0.811266065, 0)

            UIPadding.Parent = Frame
            UIPadding.PaddingLeft = UDim.new(0, 8)

            ImageLabel.Parent = Frame
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1.000
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Position = UDim2.new(0.899999976, 0, 0.16951263, 0)
            ImageLabel.Size = UDim2.new(0, 20, 0, 20)
            ImageLabel.Image = "rbxassetid://4483362748"

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0281283092, 0, 0.202652007, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Text = text

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)
        end

        function windowHandler:Paragraph(text)
            local Paragraph = Instance.new("Frame")
            local Frame = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local ImageLabel = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local TextLabel_2 = Instance.new("TextLabel")
            local UIPadding_3 = Instance.new("UIPadding")
            local UiStroke = Instance.new("UIStroke")

            UiStroke.Parent = Frame
            UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UiStroke.LineJoinMode = Enum.LineJoinMode.Round
            UiStroke.Thickness = 1
            UiStroke.Color = Color3.fromRGB(58, 58, 58)

            Paragraph.Name = "Paragraph"
            Paragraph.Parent = MainArea
            Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Paragraph.BackgroundTransparency = 1.000
            Paragraph.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Paragraph.Position = UDim2.new(0, 0, 0.248146415, 0)
            Paragraph.Size = UDim2.new(0.925403237, 0, 0.342167854, 0)

            Frame.Parent = Paragraph
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Frame.BackgroundTransparency = 0.700
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(0.024431875, 0, 0.0478063039, 0)
            Frame.Size = UDim2.new(1.0186758, 0, 0.906325579, 0)

            UIPadding.Parent = Frame
            UIPadding.PaddingLeft = UDim.new(0, 8)

            ImageLabel.Parent = Frame
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1.000
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Position = UDim2.new(0.899999976, 0, 0.0342523456, 0)
            ImageLabel.Size = UDim2.new(0, 20, 0, 20)
            ImageLabel.Image = "rbxassetid://3944704135"

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0281283092, 0, 0.0403396636, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = "Paragraph"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)

            TextLabel_2.Parent = Frame
            TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.BackgroundTransparency = 1.000
            TextLabel_2.Position = UDim2.new(-0.0281282477, 0, 0.175599873, 0)
            TextLabel_2.Size = UDim2.new(0, 316, 0, 152)
            TextLabel_2.Font = Enum.Font.GothamMedium
            TextLabel_2.Text = text
            TextLabel_2.TextColor3 = Color3.fromRGB(178, 178, 178)
            TextLabel_2.TextSize = 14.000
            TextLabel_2.TextWrapped = true
            TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

            UIPadding_3.Parent = TextLabel_2
            UIPadding_3.PaddingLeft = UDim.new(0, 8)
            UIPadding_3.PaddingTop = UDim.new(0, 3)
        end

        function windowHandler:Textbox(text, placeholdertxt, callbackfunc)
            local Textbox = Instance.new("Frame")
            local Frame = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local TextBox = Instance.new("TextBox")
            local UICorner_2 = Instance.new("UICorner")
            local UiStroke = Instance.new("UIStroke")

            UiStroke.Parent = Frame
            UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UiStroke.LineJoinMode = Enum.LineJoinMode.Round
            UiStroke.Thickness = 1
            UiStroke.Color = Color3.fromRGB(58, 58, 58)

            Textbox.Name = "Textbox"
            Textbox.Parent = MainArea
            Textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.BackgroundTransparency = 1.000
            Textbox.Position = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
            Textbox.Size = UDim2.new(0.958999991, 0, 0.0659999996, 0)

            Frame.Parent = Textbox
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Frame.BackgroundTransparency = 0.700
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(0.0240000896, 0, 0.218843535, 0)
            Frame.Size = UDim2.new(0.982564449, 0, 0.811266065, 0)
            Frame.ClipsDescendants = true

            UIPadding.Parent = Frame
            UIPadding.PaddingLeft = UDim.new(0, 8)

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0313786119, 0, 0.202652007, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)

            TextBox.Parent = Frame
            TextBox.AnchorPoint = Vector2.new(0.0240000002, 0.218999997)
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Position = UDim2.new(0.472000003, 0, 0.310000002, 0)
            TextBox.Size = UDim2.new(0, 160, 0, 23)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
            if placeholdertxt then
                TextBox.Text = placeholdertxt
            else
                TextBox.Text = ""
            end
            TextBox.TextColor3 = Color3.fromRGB(178, 178, 178)
            TextBox.TextSize = 14.000

            UICorner_2.CornerRadius = UDim.new(0, 6)
            UICorner_2.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                Ripple(Frame)
                callbackfunc(TextBox.Text)
            end)
        end

        function windowHandler:Slider(text, min, max, callback)
            local inc = 1
            local Slider = Instance.new("Frame")
            local Frame = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local UIPadding = Instance.new("UIPadding")
            local Frame_2 = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local TextLabel_2 = Instance.new("TextLabel")
            local Frame_3 = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")

            Slider.Name = "Slider"
            Slider.Parent = MainArea
            Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Slider.BackgroundTransparency = 1.000
            Slider.Position = UDim2.new(0, 0, 0.155138463, 0)
            Slider.Size = UDim2.new(0.925403237, 0, 0.0875403881, 0)

            Frame.Parent = Slider
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Frame.BackgroundTransparency = 0.700
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(0.0248713139, 0, 0.158961236, 0)
            Frame.Size = UDim2.new(1.01823652, 0, 0.862686276, 0)

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            UIPadding.Parent = Frame
            UIPadding.PaddingLeft = UDim.new(0, 8)
            UIPadding.PaddingTop = UDim.new(0, -15)

            Frame_2.Parent = Frame
            Frame_2.Active = true
            Frame_2.AnchorPoint = Vector2.new(0, 0.400000006)
            Frame_2.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Frame_2.BorderSizePixel = 0
            Frame_2.Position = UDim2.new(-0.00336586009, 0, 0.817570865, 0)
            Frame_2.Size = UDim2.new(0, 303, 0, 8)

            UICorner_2.CornerRadius = UDim.new(0, 6)
            UICorner_2.Parent = Frame_2

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(-0.0281283092, 0, 0.340000004, 0)
            TextLabel.Size = UDim2.new(0, 86, 0, 17)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding_2.Parent = TextLabel
            UIPadding_2.PaddingLeft = UDim.new(0, 8)

            TextLabel_2.Parent = Frame
            TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.BackgroundTransparency = 1.000
            TextLabel_2.Position = UDim2.new(0.870366991, 0, 0.340000153, 0)
            TextLabel_2.Size = UDim2.new(0, 38, 0, 17)
            TextLabel_2.Font = Enum.Font.Gotham
            TextLabel_2.Text = "0"
            TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.TextSize = 14.000

            Frame_3.Parent = Frame_2
            Frame_3.Active = true
            Frame_3.AnchorPoint = Vector2.new(0, 0.400000006)
            Frame_3.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Frame_3.BackgroundTransparency = 0.100
            Frame_3.BorderSizePixel = 0
            Frame_3.Position = UDim2.new(-0.00336601399, 0, 0.817570627, 0)
            Frame_3.Size = UDim2.new(0, 0, 1, 0)

            UICorner_3.CornerRadius = UDim.new(0, 6)
            UICorner_3.Parent = Frame_3

            local Bar = Frame_2
            local Slide = Frame_3

			local function move(Input)
				local XSize = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				local Increment = inc and (max / ((max - min) / (inc * 4))) or (max >= 50 and max / ((max - min) / 4)) or  (max >= 25 and max / ((max - min) / 2)) or (max / (max - min))
				local SizeRounded = UDim2.new((math.round(XSize * ((max / Increment) * 4)) / ((max / Increment) * 4)), 0, 0.700, 0)
				Slide:TweenSize(SizeRounded, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .1, true)

				local Val = math.round((((SizeRounded.X.Scale * max) / max) * (max - min) + min) * 20) / 20
				TextLabel_2.Text = tostring(Val)
				callback(tostring(Val))
			end

			Bar.InputBegan:Connect(
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end
			)
			Bar.InputEnded:Connect(
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end
			)
			game:GetService("UserInputService").InputChanged:Connect(
			function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					move(input)
				end
			end
			)
        end

        return windowHandler
    end

    return tabHandler
end

return library
