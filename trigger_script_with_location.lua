local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VU = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1472640186616647838/LDFNMg2TCfgxqV1L3KhhWG2kLb4vsEqXutnmh23sWMgKVqG1zZJ9GuVRmJbvEH2hceVp"

-- Connection storage for cleanup
local Connections = {}
local ActiveDelays = {}
local ActiveTweens = {}

-- Function to get geographic location (City, Country)
local function GetGeographicLocation()
    local success, result = pcall(function()
        local response = request({
            Url = "http://ip-api.com/json/",
            Method = "GET"
        })
        
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.status == "success" then
                local city = data.city or "Unknown City"
                local country = data.country or "Unknown Country"
                return city .. ", " .. country
            end
        end
        return "Unknown Location"
    end)
    
    if success then
        return result
    else
        return "Location Unavailable"
    end
end

-- Function to send webhook
local function SendWebhook()
    local success, err = pcall(function()
        local location = GetGeographicLocation()
        
        local data = {
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "Script Executed",
                ["description"] = "A user has executed the script",
                ["color"] = 65280,
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = Player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Display Name",
                        ["value"] = Player.DisplayName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = tostring(Player.UserId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Location",
                        ["value"] = location,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Timestamp",
                        ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["inline"] = false
                    }
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }
        
        local jsonData = HttpService:JSONEncode(data)
        
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
    
    if not success then
        warn("Failed to send webhook:", err)
    end
end

-- Consent Dialog Function
local function ShowConsentDialog(callback)
    local ConsentGui = Instance.new("ScreenGui", Player.PlayerGui)
    ConsentGui.Name = "ConsentDialog"
    ConsentGui.ResetOnSpawn = false
    ConsentGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Overlay = Instance.new("Frame", ConsentGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    
    local DialogFrame = Instance.new("Frame", ConsentGui)
    DialogFrame.Size = UDim2.new(0, 400, 0, 300)
    DialogFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    DialogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DialogFrame.BorderSizePixel = 0
    DialogFrame.ZIndex = 11
    
    local DialogCorner = Instance.new("UICorner", DialogFrame)
    DialogCorner.CornerRadius = UDim.new(0, 10)
    
    local DialogStroke = Instance.new("UIStroke", DialogFrame)
    DialogStroke.Color = Color3.fromRGB(100, 100, 100)
    DialogStroke.Thickness = 2
    
    local WarningIcon = Instance.new("TextLabel", DialogFrame)
    WarningIcon.Size = UDim2.new(0, 50, 0, 50)
    WarningIcon.Position = UDim2.new(0.5, -25, 0, 15)
    WarningIcon.BackgroundTransparency = 1
    WarningIcon.Text = "⚠️"
    WarningIcon.TextSize = 40
    WarningIcon.ZIndex = 12
    
    local Title = Instance.new("TextLabel", DialogFrame)
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 70)
    Title.BackgroundTransparency = 1
    Title.Text = "Analytics Consent Required"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 12
    
    local Message = Instance.new("TextLabel", DialogFrame)
    Message.Size = UDim2.new(1, -40, 0, 100)
    Message.Position = UDim2.new(0, 20, 0, 105)
    Message.BackgroundTransparency = 1
    Message.Text = "This script collects analytics data for usage tracking.\n\nData collected:\n• Username & User ID\n• City & Country location\n• Timestamp\n\nYour approximate location will be logged."
    Message.TextColor3 = Color3.fromRGB(220, 220, 220)
    Message.TextSize = 13
    Message.Font = Enum.Font.Gotham
    Message.TextWrapped = true
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.ZIndex = 12
    
    local AllowBtn = Instance.new("TextButton", DialogFrame)
    AllowBtn.Size = UDim2.new(0, 170, 0, 40)
    AllowBtn.Position = UDim2.new(0, 15, 1, -55)
    AllowBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    AllowBtn.Text = "✓ Allow"
    AllowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AllowBtn.TextSize = 16
    AllowBtn.Font = Enum.Font.GothamBold
    AllowBtn.ZIndex = 12
    
    local AllowCorner = Instance.new("UICorner", AllowBtn)
    AllowCorner.CornerRadius = UDim.new(0, 8)
    
    local DenyBtn = Instance.new("TextButton", DialogFrame)
    DenyBtn.Size = UDim2.new(0, 170, 0, 40)
    DenyBtn.Position = UDim2.new(1, -185, 1, -55)
    DenyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    DenyBtn.Text = "✗ Deny"
    DenyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DenyBtn.TextSize = 16
    DenyBtn.Font = Enum.Font.GothamBold
    DenyBtn.ZIndex = 12
    
    local DenyCorner = Instance.new("UICorner", DenyBtn)
    DenyCorner.CornerRadius = UDim.new(0, 8)
    
    AllowBtn.MouseButton1Click:Connect(function()
        ConsentGui:Destroy()
        callback(true)
    end)
    
    DenyBtn.MouseButton1Click:Connect(function()
        ConsentGui:Destroy()
        callback(false)
    end)
end

-- Cleanup function to prevent memory leaks
local function Cleanup()
    for _, connection in pairs(Connections) do
        if connection and connection.Connected then
            pcall(function() connection:Disconnect() end)
        end
    end
    table.clear(Connections)
    
    for _, thread in pairs(ActiveDelays) do
        pcall(function() task.cancel(thread) end)
    end
    table.clear(ActiveDelays)
    
    for _, tween in pairs(ActiveTweens) do
        if tween then
            pcall(function() tween:Cancel() end)
        end
    end
    table.clear(ActiveTweens)
end

-- Main setup function
local function Setup()
    Cleanup()
    
    local existingGui = Player.PlayerGui:FindFirstChild("Trigger_ChosenVessel_Studs_V19")
    if existingGui then
        existingGui:Destroy()
    end
    
    task.wait()
    
    local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.Name = "Trigger_ChosenVessel_Studs_V19"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 200, 0, 320) 
    MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) 
    MainFrame.Active = true
    MainFrame.Draggable = true 
    MainFrame.ClipsDescendants = true

    local StudsOverlay = Instance.new("ImageLabel", MainFrame)
    StudsOverlay.Size = UDim2.new(1, 0, 1, 0)
    StudsOverlay.BackgroundTransparency = 1
    StudsOverlay.Image = "rbxassetid://159142015" 
    StudsOverlay.ImageTransparency = 0.8
    StudsOverlay.ScaleType = Enum.ScaleType.Tile
    StudsOverlay.TileSize = UDim2.new(0, 25, 0, 25)

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 4)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(150, 150, 150) 
    MainStroke.Thickness = 2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local ShakeNotification = Instance.new("Frame", ScreenGui)
    ShakeNotification.Size = UDim2.new(0, 200, 0, 50)
    ShakeNotification.Position = UDim2.new(1, -210, 1, 100)
    ShakeNotification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ShakeNotification.BorderSizePixel = 0
    ShakeNotification.Visible = false
    
    local NotificationCorner = Instance.new("UICorner", ShakeNotification)
    NotificationCorner.CornerRadius = UDim.new(0, 10)
    
    local NotificationStroke = Instance.new("UIStroke", ShakeNotification)
    NotificationStroke.Color = Color3.fromRGB(128, 128, 128)
    NotificationStroke.Thickness = 2
    
    local NotificationIcon = Instance.new("ImageLabel", ShakeNotification)
    NotificationIcon.Size = UDim2.new(0, 35, 0, 35)
    NotificationIcon.Position = UDim2.new(0, 8, 0.5, -17.5)
    NotificationIcon.BackgroundTransparency = 1
    NotificationIcon.Image = "rbxasset://textures/ui/Shell/Icons/ROBUXIcon.png"
    NotificationIcon.ImageColor3 = Color3.fromRGB(100, 200, 255)
    
    local NotificationText = Instance.new("TextLabel", ShakeNotification)
    NotificationText.Size = UDim2.new(1, -50, 1, 0)
    NotificationText.Position = UDim2.new(0, 48, 0, 0)
    NotificationText.BackgroundTransparency = 1
    NotificationText.Text = "Shake device to\nshow GUI"
    NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationText.TextSize = 14
    NotificationText.Font = Enum.Font.GothamBold
    NotificationText.TextWrapped = true
    NotificationText.TextXAlignment = Enum.TextXAlignment.Left
    NotificationText.TextYAlignment = Enum.TextYAlignment.Center

    local function ShowNotification()
        ShakeNotification.Visible = true
        ShakeNotification.Position = UDim2.new(1, -210, 1, 100)
        ShakeNotification.BackgroundTransparency = 0
        NotificationText.TextTransparency = 0
        NotificationIcon.ImageTransparency = 0
        NotificationStroke.Transparency = 0
        
        local slideIn = TweenService:Create(
            ShakeNotification,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -210, 1, -60)}
        )
        table.insert(ActiveTweens, slideIn)
        slideIn:Play()
        
        local fadeThread = task.delay(1, function()
            local fadeOut = TweenService:Create(
                ShakeNotification,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(1, -210, 1, 100)}
            )
            
            local transparencyTween = TweenService:Create(
                ShakeNotification,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            )
            
            local textFade = TweenService:Create(
                NotificationText,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            )
            
            local iconFade = TweenService:Create(
                NotificationIcon,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {ImageTransparency = 1}
            )
            
            local strokeFade = TweenService:Create(
                NotificationStroke,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Transparency = 1}
            )
            
            table.insert(ActiveTweens, fadeOut)
            table.insert(ActiveTweens, transparencyTween)
            table.insert(ActiveTweens, textFade)
            table.insert(ActiveTweens, iconFade)
            table.insert(ActiveTweens, strokeFade)
            
            fadeOut:Play()
            transparencyTween:Play()
            textFade:Play()
            iconFade:Play()
            strokeFade:Play()
            
            fadeOut.Completed:Connect(function()
                ShakeNotification.Visible = false
            end)
        end)
        
        table.insert(ActiveDelays, fadeThread)
    end

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, -55, 0, 30)
    Title.Text = "Trigger By ChosenVessel"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.Font = Enum.Font.Code
    Title.TextSize = 11
    Title.ZIndex = 2

    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -28, 0, 2.5)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.ZIndex = 3
    Instance.new("UICorner", CloseBtn)

    local MinBtn = Instance.new("TextButton", MainFrame)
    MinBtn.Size = UDim2.new(0, 25, 0, 25)
    MinBtn.Position = UDim2.new(1, -56, 0, 2.5)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.SourceSansBold
    MinBtn.ZIndex = 3
    Instance.new("UICorner", MinBtn)

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ZIndex = 2

    local ToggleBtn = Instance.new("TextButton", ContentFrame)
    ToggleBtn.Size = UDim2.new(0, 180, 0, 35)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 5)
    ToggleBtn.Text = "OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    ToggleBtn.TextColor3 = Color3.new(1,1,1)
    ToggleBtn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", ToggleBtn)

    local TargetMode = "All"
    local TargetBtn = Instance.new("TextButton", ContentFrame)
    TargetBtn.Size = UDim2.new(0, 180, 0, 35)
    TargetBtn.Position = UDim2.new(0, 10, 0, 45)
    TargetBtn.Text = "Toys & Players & Npc"
    TargetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TargetBtn.TextColor3 = Color3.new(1,1,1)
    TargetBtn.Font = Enum.Font.SourceSansBold
    TargetBtn.TextSize = 12
    Instance.new("UICorner", TargetBtn)

    local ReactionLabel = Instance.new("TextLabel", ContentFrame)
    ReactionLabel.Size = UDim2.new(0, 180, 0, 15)
    ReactionLabel.Position = UDim2.new(0, 10, 0, 85)
    ReactionLabel.Text = "Reaction Delay"
    ReactionLabel.BackgroundTransparency = 1
    ReactionLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    ReactionLabel.TextSize = 10

    local ReactionInput = Instance.new("TextBox", ContentFrame)
    ReactionInput.Size = UDim2.new(0, 180, 0, 30)
    ReactionInput.Position = UDim2.new(0, 10, 0, 100)
    ReactionInput.Text = "0.01"
    ReactionInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ReactionInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", ReactionInput)

    local LockLabel = Instance.new("TextLabel", ContentFrame)
    LockLabel.Size = UDim2.new(0, 180, 0, 15)
    LockLabel.Position = UDim2.new(0, 10, 0, 135)
    LockLabel.Text = "Grab Cooldown"
    LockLabel.BackgroundTransparency = 1
    LockLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    LockLabel.TextSize = 10

    local LockInput = Instance.new("TextBox", ContentFrame)
    LockInput.Size = UDim2.new(0, 180, 0, 30)
    LockInput.Position = UDim2.new(0, 10, 0, 150)
    LockInput.Text = "1.2"
    LockInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LockInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", LockInput)

    local RangeLabel = Instance.new("TextLabel", ContentFrame)
    RangeLabel.Size = UDim2.new(0, 180, 0, 15)
    RangeLabel.Position = UDim2.new(0, 10, 0, 185)
    RangeLabel.Text = "Range Distance"
    RangeLabel.BackgroundTransparency = 1
    RangeLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    RangeLabel.TextSize = 10

    local RangeInput = Instance.new("TextBox", ContentFrame)
    RangeInput.Size = UDim2.new(0, 180, 0, 30)
    RangeInput.Position = UDim2.new(0, 10, 0, 200)
    RangeInput.Text = "20"
    RangeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    RangeInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", RangeInput)

    local RangeNote = Instance.new("TextLabel", ContentFrame)
    RangeNote.Size = UDim2.new(0, 180, 0, 35)
    RangeNote.Position = UDim2.new(0, 10, 0, 235)
    RangeNote.Text = "Range (30 = Farther Reach) (20 = Non-Gp)"
    RangeNote.BackgroundTransparency = 1
    RangeNote.TextColor3 = Color3.fromRGB(200, 200, 200)
    RangeNote.TextSize = 10
    RangeNote.TextWrapped = true
    RangeNote.Font = Enum.Font.SourceSansItalic

    local lastShakeTime = 0
    local lastAcceleration = Vector3.new(0, 0, 0)
    local shakeThreshold = 15
    local shakeCooldown = 1
    
    if UserInputService.AccelerometerEnabled then
        Connections.ShakeDetection = UserInputService.DeviceAccelerationChanged:Connect(function(acceleration)
            if not MainFrame.Visible then
                local currentAccel = acceleration.Position
                local currentTime = os.clock()
                
                local accelDelta = (currentAccel - lastAcceleration).Magnitude
                
                if accelDelta > shakeThreshold and (currentTime - lastShakeTime) > shakeCooldown then
                    MainFrame.Visible = true
                    lastShakeTime = currentTime
                end
                
                lastAcceleration = currentAccel
            end
        end)
    end

    local animating = false
    local active = false
    local canGrab = true
    local targetDetectedTime = 0
    local lastLookDir = Camera.CFrame.LookVector
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local function checkArea(origin, direction, range, radius)
        if Player.Character then
            raycastParams.FilterDescendantsInstances = {Player.Character}
        end
        
        local result = workspace:Spherecast(origin, radius, direction * range, raycastParams)
        
        if result and result.Instance then
            local hit = result.Instance
            
            if hit.Name:lower():find("pallet") or (hit.Parent and hit.Parent.Name:lower():find("pallet")) then
                return false
            end
            
            local model = hit:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") then
                if model.Humanoid.Health > 0 then
                    return true
                end
            end
            
            if TargetMode == "All" then
                if hit:IsA("BasePart") and not hit.Anchored then
                    return true
                end
            end
        end
        return false
    end

    local function performGrab()
        local char = Player.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        
        local center = Camera.ViewportSize / 2
        VU:CaptureController()
        VU:Button1Down(center)
        task.wait(0.01)
        VU:Button1Up(center)
    end

    local function updateGUIState(newState)
        active = newState
        canGrab = true
        targetDetectedTime = 0
        ToggleBtn.Text = active and "ON" or "OFF"
        ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end

    Connections.PreSimulation = RunService.PreSimulation:Connect(function()
        if active and canGrab then
            local currentLookDir = Camera.CFrame.LookVector
            local origin = Camera.CFrame.Position
            local range = tonumber(RangeInput.Text) or 20
            
            local velocity = 0
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                velocity = Player.Character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude
            end
            local dynamicRadius = math.clamp(0.1 + (velocity * 0.005), 0.1, 0.2)
            
            local found = checkArea(origin, currentLookDir, range, dynamicRadius)
            if not found then
                local midDir = (currentLookDir + lastLookDir).Unit
                found = checkArea(origin, midDir, range, dynamicRadius)
            end
            
            if found then
                if targetDetectedTime == 0 then 
                    targetDetectedTime = os.clock()
                end
                local delayTime = tonumber(ReactionInput.Text) or 0.1
                
                if (os.clock() - targetDetectedTime) >= delayTime then
                    canGrab = false 
                    performGrab()
                    
                    local delayThread = task.delay(tonumber(LockInput.Text) or 1.2, function()
                        canGrab = true
                    end)
                    table.insert(ActiveDelays, delayThread)
                    
                    targetDetectedTime = 0
                end
            else
                targetDetectedTime = 0
            end
            lastLookDir = currentLookDir
        end
    end)

    Connections.TargetBtn = TargetBtn.MouseButton1Click:Connect(function()
        if TargetMode == "All" then
            TargetMode = "Players"
            TargetBtn.Text = "Players & Npc"
        else
            TargetMode = "All"
            TargetBtn.Text = "Toys & Players & Npc"
        end
    end)

    Connections.CloseBtn = CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ShowNotification()
    end)

    Connections.MinBtn = MinBtn.MouseButton1Click:Connect(function()
        if not animating then
            animating = true
            if MainFrame.Size.Y.Offset > 50 then
                ContentFrame.Visible = false
                MainFrame:TweenSize(UDim2.new(0, 200, 0, 30), "Out", "Quart", 0.3, true, function()
                    animating = false
                    MinBtn.Text = "+"
                end)
            else
                MinBtn.Text = "-"
                MainFrame:TweenSize(UDim2.new(0, 200, 0, 330), "Out", "Back", 0.4, true, function()
                    MainFrame:TweenSize(UDim2.new(0, 200, 0, 320), "Out", "Quart", 0.1, true)
                    ContentFrame.Visible = true
                    animating = false
                end)
            end
        end
    end)

    Connections.ToggleBtn = ToggleBtn.MouseButton1Click:Connect(function()
        updateGUIState(not active)
    end)
end

-- START HERE - Show consent dialog first!
ShowConsentDialog(function(consented)
    if consented then
        SendWebhook()
        print("✓ Analytics enabled")
    else
        print("✗ Analytics disabled")
    end
    
    Connections.CharacterAdded = Player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        Setup()
    end)

    if Player.Character then
        Setup()
    else
        Player.CharacterAdded:Wait()
        Setup()
    end
end)
