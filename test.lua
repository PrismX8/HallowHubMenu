-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Hallow-Hub/main/games/PetStarSim.lua",true))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Hallow Hub | Pet Star Simulator!",
    Icon = 17091459839,
    LoadingTitle = "Hallow Hub",
    LoadingSubtitle = "By Moligrafi",
    Theme = "Amethyst"
})

-- Values
getgenv().AutoColStars = false
getgenv().AutoHatch = false
getgenv().SelectedEgg = nil
_G.selectedMap = nil
-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local isAutoCollecting = false
local currentMap = "SPAWN"
local selectedMap = "SPAWN"

local function AutoCollectStars(mapName)
    if isAutoCollecting then
        print("Already collecting on map " .. currentMap .. ", stopping current collection.")
        return
    end

    isAutoCollecting = true
    currentMap = mapName  

    while getgenv().AutoColStars == true do
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        if not character or not character:FindFirstChild("HumanoidRootPart") then
            warn("Character or HumanoidRootPart not found!")
            wait(1) 
            continue
        end

        local localStars = Workspace:FindFirstChild("LocalStars")
        local spawnFolder = localStars and localStars:FindFirstChild(mapName)

        if not localStars or not spawnFolder then
            warn("Map " .. mapName .. " or SPAWN folder not found in LocalStars!")
            wait(1)
            continue
        end

        local stars = spawnFolder:GetChildren()
        if #stars == 0 then
            warn("No stars found in SPAWN folder!")
            wait(1)
            continue
        end

        for _, star in ipairs(stars) do
            local primaryPart = star:FindFirstChild("Primary")
            if primaryPart and primaryPart:IsA("BasePart") then
                local touchInterest = primaryPart:FindFirstChild("TouchInterest")
                if touchInterest and touchInterest:IsA("TouchTransmitter") then
                    -- Simulate touch event with the TouchInterest
                    if touchInterest and touchInterest.Parent then
                        firetouchinterest(character.HumanoidRootPart, touchInterest.Parent, 0)
                        task.wait()  -- Use task.wait() for a shorter, more consistent wait
                        if touchInterest and touchInterest.Parent then
                            firetouchinterest(character.HumanoidRootPart, touchInterest.Parent, 1)
                            
                            print("Touched star's TouchInterest in map " .. mapName .. ": " .. star.Name)

                            local collectStarRemote = ReplicatedStorage:FindFirstChild("Core") and ReplicatedStorage.Core:FindFirstChild("Remote") and ReplicatedStorage.Core.Remote:FindFirstChild("collectStar")
                            if collectStarRemote then
                                collectStarRemote:FireServer(star)  
                                print("Collected star: " .. star.Name)
                            else
                                warn("RemoteEvent 'collectStar' not found in ReplicatedStorage.Core.Remote!")
                            end
                        end
                    end
                    
                    task.wait(0.05)
                else
                    warn("TouchInterest not found in Primary part of star: " .. star.Name)
                end
            else
                warn("Primary part not found in star: " .. star.Name)
            end
        end

        task.wait(0.01) 
    end

    isAutoCollecting = false
end


local function teleport(location, title, message)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    humanoidRootPart.CFrame = location

    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = 5
    })
end

-- Movement
local WalkSpeedText = 16
local JumpPowerText = 50
_G.SetWalkSpeed = false
_G.SetJumpPower = false
_G.InfJump = false
_G.NoClip = false
local function SetWalkSpeed()
	while _G.SetWalkSpeed == true do
		if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed ~= WalkSpeedText then
			game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = WalkSpeedText
		end
		wait(0.01)
	end
	if _G.SetWalkSpeed == false then
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
	end
end
local function SetJumpPower()
	while _G.SetJumpPower == true do
		if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower ~= JumpPowerText then
			game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = JumpPowerText
		end
		wait(0.01)
		end
	if _G.SetJumpPower == false then
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = 50
	end
end
local function InfJump()
	while _G.InfJump == true do
		game:GetService("UserInputService").JumpRequest:connect(function()
			if _G.InfJump == true then
				game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
			end
		end)
		wait(0.1)
	end
end
local function NoClip()
	while _G.NoClip == true do
		for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				if _G.NoClip then
					part.CanCollide = false
				else
					part.CanCollide = true
				end
			end
		end
		wait(0.1)
	end
end

getgenv().AutoColRewards = false
local iscollecting = false

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local rewardsFolder = game.Workspace:FindFirstChild("CollectRewards")
local virtualInputManager = game:GetService("VirtualInputManager")

local function CollectRE()
    if iscollecting or not rewardsFolder then return end
    iscollecting = true

    local rewards = rewardsFolder:GetChildren()
    if #rewards == 0 then
		Rayfield:Notify({
			Title = "No Collectables",
			Content = "Couldn't find a Collectable :(.",
			Duration = 6.5,
			Image = 4483362458,
			Actions = {
				Ignore = {
					Name = "Okay!",
					Callback = function()
						print("The user tapped Okay!")
					end
				},
			},
		})
        iscollecting = false
        return 
    end

    while getgenv().AutoColRewards do
        for _, reward in ipairs(rewardsFolder:GetChildren()) do
            if not getgenv().AutoColRewards then break end
            if reward:IsA("Model") then
                local descendants = reward:GetDescendants()

                local prompt
                for _, descendant in ipairs(descendants) do
                    if descendant:IsA("ProximityPrompt") then
                        prompt = descendant
                    end
                wait(0.1)
                end

                if prompt then
                    fireproximityprompt(prompt)

                    task.wait(0.1)
                end
            end
        wait(1)
        end
    end

    iscollecting = false
end




local mapPositions = {
    ["SPAWN"] = CFrame.new(13.6210747, 4.00057125, -563.520813, 0.847098291, -9.54145136e-08, 0.531436265, 7.91322776e-08, 1, 5.34056461e-08, -0.531436265, -3.1860703e-09, 0.847098291),
    ["Autumn Forest"] = CFrame.new(9.3673954, 3.9999578, -758.91449, 0.999615431, 3.39384449e-08, -0.0277317464, -3.39598323e-08, 1, -3.00279579e-10, 0.0277317464, 1.24192956e-09, 0.999615431),
    ["Flower Garden"] = CFrame.new(8.04845238, 3.9999578, -954.51532, 0.85444808, 4.35373231e-08, -0.519536793, -3.85188983e-08, 1, 2.04507611e-08, 0.519536793, 2.53787125e-09, 0.85444808),
    ["Snow Forest"] = CFrame.new(8.96513653, 4.01302624, -1148.30078, 0.999520063, 4.09274143e-08, 0.0309788994, -4.40184849e-08, 1, 9.9097953e-08, -0.0309788994, -1.00414034e-07, 0.999520063),
    ["Tropical Palms"] = CFrame.new(9.11476231, 4.00638866, -1343.58887, 0.994337261, 1.19500756e-08, 0.106270239, -1.67945888e-08, 1, 4.469182e-08, -0.106270239, -4.62235086e-08, 0.994337261),
    ["Mine Shaft"] = CFrame.new(9.55875301, 3.9999578, -1539.07959, 0.998662055, 1.6683753e-08, 0.0517115854, -1.9181174e-08, 1, 4.77989346e-08, -0.0517115854, -4.87268714e-08, 0.998662055),
    ["Diamond Mine"] = CFrame.new(8.39960861, 3.9999578, -1733.69385, 0.999885857, -1.27159751e-07, -0.0151077257, 1.2689209e-07, 1, -1.86757685e-08, 0.0151077257, 1.67565855e-08, 0.999885857),
    ["Magical Forest"] = CFrame.new(8.94233418, 3.9999578, -1931.28259, 0.999978125, -7.19709403e-10, 0.00661586365, 8.80404194e-10, 1, -2.42863987e-08, -0.00661586365, 2.42916922e-08, 0.999978125),
    ["Sakura Forest"] = CFrame.new(9.63525772, 3.9999578, -2126.64038, 0.998708427, -4.76508255e-09, 0.0508081615, 3.2844083e-10, 1, 8.73297878e-08, -0.0508081615, -8.72003056e-08, 0.998708427),
    ["Sakura Ravine"] = CFrame.new(10.4414206, 3.99438834, -2321.14819, 0.997639, 5.84764166e-08, -0.0686761737, -6.19572944e-08, 1, -4.85553642e-08, 0.0686761737, 5.26957145e-08, 0.997639),
    ["Magma Ravine"] = CFrame.new(8.24645805, 3.97864127, -2515.40601, 0.999063671, -2.30366226e-10, -0.0432639308, 4.2857784e-10, 1, 4.57217642e-09, 0.0432639308, -4.58643745e-09, 0.999063671),
    ["Cloud Road"] = CFrame.new(11.6605415, 3.99617362, -2709.56128, 0.915485322, -1.99193924e-08, 0.402351379, 7.09648607e-09, 1, 3.33605499e-08, -0.402351379, -2.76858128e-08, 0.915485322),
    ["Heaven"] = CFrame.new(8.83816242, 4.01350689, -2904.34009, 0.455204368, 8.88061038e-08, -0.890386999, -1.81342088e-08, 1, 9.0467779e-08, 0.890386999, -2.50348648e-08, 0.455204368),
    ["Toxic Wasteland"] = CFrame.new(9.13585186, 3.86399436, -3100.13184, 0.954481244, 1.05871003e-07, -0.298270911, -1.03311663e-07, 1, 2.43468374e-08, 0.298270911, 7.57626406e-09, 0.954481244),
    ["Sandy Star Bay"] = CFrame.new(6.66705036, 3.91395926, -3312.83228, -0.7931813, 1.77182642e-08, -0.608985543, -1.03644213e-08, 1, 4.25939959e-08, 0.608985543, 4.00965448e-08, -0.7931813),
	["EVENT"] = CFrame.new(1506.11047, 3.89311576, -495.028564, 0.940592825, -3.48910234e-08, 0.339536667, 2.05151398e-08, 1, 4.5929152e-08, -0.339536667, -3.62349866e-08, 0.940592825),
	["Heart Forest"] = CFrame.new(1509.57422, 3.89311576, -677.701721, 0.878487349, 4.45530794e-08, -0.47776562, 5.2216973e-09, 1, 1.02854351e-07, 0.47776562, -9.28509962e-08, 0.878487349),
	["Blue Heart Forest"] = CFrame.new(1511.8042, 3.89311576, -862.257019, 0.993979871, 2.82322166e-08, 0.109562635, -2.65968776e-08, 1, -1.63874674e-08, -0.109562635, 1.33747893e-08, 0.993979871),
	["Green Heart Forest"] = CFrame.new(1510.2428, 3.89311576, -1044.17224, 0.999533057, 4.79872071e-08, -0.0305560995, -4.7111218e-08, 1, 2.93880742e-08, 0.0305560995, -2.79348153e-08, 0.999533057),
}


local function TeleportMap()
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    if character and character:FindFirstChild("HumanoidRootPart") then
        if selectedMap == nil then
            Rayfield:Notify({
                Title = "No Map selected.",
                Content = "You have to select it before you teleport.",
                Duration = 2.5,
                Image = 17091459839,
            })
            return 
        end

        local teleportPosition = mapPositions[selectedMap]
        if teleportPosition then
            character.HumanoidRootPart.CFrame = teleportPosition
            Rayfield:Notify({
                Title = selectedMap,
                Content = "Teleported to " .. selectedMap .. "!",
                Duration = 2.5,
                Image = 17091459839,
            })
        end
    end
end

local function autoOpenEgg(eggType)
    local args = {
        [1] = eggType,
        [2] = "Auto Open"
    }

    local hatchRemote = game:GetService("ReplicatedStorage"):WaitForChild("PetSystem"):WaitForChild("Remote"):WaitForChild("Hatch")
    
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if self == hatchRemote and method == "InvokeServer" then
            return true
        end
        
        return oldNamecall(self, ...)
    end)

    hatchRemote:InvokeServer(unpack(args))
end
local isAutoHatching = false

local function stopAllAutoHatches()
    isAutoHatching = false
    getgenv().AutoHatch = false
end
	
local Menu = Window:CreateTab("Main", "home")
local Divider = Menu:CreateDivider()
local Section = Menu:CreateSection("Auto collect stars")

local ToggleEnabled = false 

local Dropdown = Menu:CreateDropdown({
    Name = "Select Map (If not unlocked it will NOT work.)",
    Options = {"SPAWN", "Autumn Forest", "Flower Garden", "Snow Forest", "Tropical Palms", "Mine Shaft", "Diamond Mine", "Magical Forest", "Sakura Forest", "Sakura Ravine", "Magma Ravine", "Cloud Road", "Heaven","Toxic Wasteland", "Sandy Star Bay", "EVENT", "Heart Forest", "Blue Heart Forest", "Green Heart Forest"},
    CurrentOption = {"SPAWN"},
    MultipleOptions = false,
    Callback = function(Options)
        if getgenv().AutoColStars then 
            Rayfield:Notify({
                Title = "Action Blocked",
                Content = "Cannot change the map while Auto Collect Stars is enabled. Please disable it first.",
                Duration = 2.5,
                Image = 17091459839,
            })
            return
        end

        selectedMap = Options[1]
        TeleportMap()
    end,
})


local Section = Menu:CreateSection("PICK MAP FIRST BEFORE TOGGLEING ON!!!!!!!!!!")


local Toggle = Menu:CreateToggle({
    Name = "Toggle Auto Collect Stars",
    CurrentValue = false,
    Flag = "AutoCollectStarsToggle",
    Callback = function(Value)
        getgenv().AutoColStars = Value
        if Value then
            AutoCollectStars(selectedMap)
        else
            isAutoCollecting = false
        end
    end
})

local Divider = Menu:CreateDivider()

local Toggle = Menu:CreateToggle({
	Name = "Toggle Auto-Collect Collectables",
	CurrentValue = false,
	Flag = "Autorewards", 
	Callback = function(Value)
		getgenv().AutoColRewards = Value
		if Value then			
			CollectRE()
		else
			iscollecting = false
		end
	end
 })

local Section = Menu:CreateSection("Player", "person-standing")

local Input = Menu:CreateInput({
   Name = "Player Walk Speed",
   CurrentValue = "16",
   Flag = "WalkSpeedInput",
   PlaceholderText = "Default Walk Speed = 16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   	WalkSpeedText = Text
   end,
})
local Toggle = Menu:CreateToggle({
   Name = "Toggle Walk Speed",
   CurrentValue = false,
   Flag = "WalkSpeedToggle", 
   Callback = function(Value)
   	_G.SetWalkSpeed = Value
   	SetWalkSpeed()
   end,
})
local Toggle = Menu:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(Value)
   	_G.NoClip = Value
   	NoClip()
   end,
})
local Section = Menu:CreateSection("Jump")
local Input = Menu:CreateInput({
   Name = "Player Jump Power",
   CurrentValue = "",
   Flag = "JumpPowerInput",
   PlaceholderText = "Default Jump Power = 50",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
   	JumpPowerText = Text
   end,
})
local Toggle = Menu:CreateToggle({
   Name = "Toggle Jump Power",
   CurrentValue = false,
   Flag = "JumpPowerToggle",
   Callback = function(Value)
   	_G.SetJumpPower = Value
   	SetJumpPower()
   end,
})
local Toggle = Menu:CreateToggle({
   Name = "Inf Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
   	_G.InfJump = Value
   	InfJump()
   end,
})


local TP = Window:CreateTab("Teleports", "shell")
local Section = TP:CreateSection("Egg Teleports")

local selectedEgg = nil

local function Teleport()
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    if character and character:FindFirstChild("HumanoidRootPart") then
        if selectedEgg == nil then
            Rayfield:Notify({
                Title = "No egg selected.",
                Content = "You have to select it before you teleport.",
                Duration = 2.5,
                Image = 17091459839,
            })
            return 
        end

        local teleportPosition
        if selectedEgg == "Basic Egg" then
            teleportPosition = CFrame.new(72.3426514, 4.49999952, -617.722229)
        elseif selectedEgg == "Autumn Egg" then
            teleportPosition = CFrame.new(72.9331055, 4.49999952, -808.936035)
        elseif selectedEgg == "Bee Egg" then
            teleportPosition = CFrame.new(72.6726074, 4.49999952, -1007.59424)
        elseif selectedEgg == "Snow Egg" then
            teleportPosition = CFrame.new(70.7977753, 4.49999952, -1200.2113)
        elseif selectedEgg == "Tropical Egg" then
            teleportPosition = CFrame.new(72.4018021, 4.49999952, -1392.255)
        elseif selectedEgg == "Mine Egg" then
            teleportPosition = CFrame.new(72.2127914, 4.49999952, -1586.75415)
        elseif selectedEgg == "Diamond Egg" then
            teleportPosition = CFrame.new(70.951973, 4.49999952, -1785.34338)
        elseif selectedEgg == "Magical Egg" then
            teleportPosition = CFrame.new(73.3748856, 4.49999952, -1979.67188)
        elseif selectedEgg == "Sakura Egg" then
            teleportPosition = CFrame.new(71.8911285, 4.49999952, -2173.75244)
        elseif selectedEgg == "Split Egg" then
            teleportPosition = CFrame.new(71.7752457, 4.50232172, -2372.65015)
        elseif selectedEgg == "Devil Egg" then
            teleportPosition = CFrame.new(72.6531219, 4.50232172, -2563.57422)
        elseif selectedEgg == "Cloud Egg" then
            teleportPosition = CFrame.new(72.6568451, 4.50232172, -2762.99146)
        elseif selectedEgg == "Heaven Egg" then
            teleportPosition = CFrame.new(73.6565552, 4.50232172, -2957.67847)
        elseif selectedEgg == "Nuclear Egg" then
            teleportPosition = CFrame.new(70.2078857, 4.36399746, -3151.0415)
        elseif selectedEgg == "Beach Egg" then
            teleportPosition = CFrame.new(70.0440216, 4.41396236, -3347.3291)
        end

        character.HumanoidRootPart.CFrame = teleportPosition
        Rayfield:Notify({
            Title = selectedEgg,
            Content = "Teleported to " .. selectedEgg .. "!",
            Duration = 2.5,
            Image = 17091459839,
        })
    end
end

TP:CreateDropdown({
    Name = "Select Egg",
    Options = {
        "Basic Egg",
        "Autumn Egg",
        "Bee Egg",
        "Snow Egg",
        "Tropical Egg",
        "Mine Egg",
        "Diamond Egg",
        "Magical Egg",
        "Sakura Egg",
        "Split Egg",
        "Devil Egg",
        "Cloud Egg",
        "Heaven Egg",
        "Nuclear Egg",
        "Beach Egg"
    },
    CurrentOption = "Basic Egg",
    MultipleOptions = false,
    Callback = function(Options)
        selectedEgg = Options[1]  
        Teleport()  
    end,
})
local Section = TP:CreateSection("Map Teleports")

local Dropdown = TP:CreateDropdown({
    Name = "Map Teleports",
    Options = {"SPAWN", "Autumn Forest", "Flower Garden", "Snow Forest", "Tropical Palms", "Mine Shaft", "Diamond Mine", "Magical Forest", "Sakura Forest", "Sakura Ravine", "Magma Ravine", "Cloud Road", "Heaven","Toxic Wasteland", "Sandy Star Bay", "EVENT", "Heart Forest", "Blue Heart Forest", "Green Heart Forest"},
    CurrentOption = {"SPAWN"},
    MultipleOptions = false,
    Callback = function(Options)
        if getgenv().AutoColStars then 
            Rayfield:Notify({
                Title = "Action Blocked",
                Content = "You messed somthing up",
                Duration = 2.5,
                Image = 17091459839,
            })
            return
        end

        selectedMap = Options[1]
        TeleportMap()
    end,
})

local Pet = Window:CreateTab("Pets", "bone")
local Section = Pet:CreateSection("Auto Hatch")
