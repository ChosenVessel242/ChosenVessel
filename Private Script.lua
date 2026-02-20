-- ╔══════════════════════════════════════╗
-- ║   PASSWORD GATE — ChosenVessel V19   ║
-- ╚══════════════════════════════════════╝

local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local CORRECT_PASSWORD = "Chosen X Antarctica"

-- ── Blur Effect (replaces black overlay) ─────────────────────────────────────
local BlurEffect = Instance.new("BlurEffect", Lighting)
BlurEffect.Size = 20

-- ── Password Screen ───────────────────────────────────────────────────────────
local PasswordGui = Instance.new("ScreenGui", Player.PlayerGui)
PasswordGui.Name = "CV_PasswordGate"
PasswordGui.ResetOnSpawn = false
PasswordGui.DisplayOrder = 999
PasswordGui.IgnoreGuiInset = true

-- Very light tint (not a solid overlay)
local Tint = Instance.new("Frame", PasswordGui)
Tint.Size = UDim2.new(1, 0, 1, 0)
Tint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Tint.BackgroundTransparency = 0.6
Tint.BorderSizePixel = 0

-- Card (centered, AnchorPoint so position math is clean)
local Card = Instance.new("Frame", PasswordGui)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Size = UDim2.new(0, 300, 0, 355)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Card.BorderSizePixel = 0
Card.ZIndex = 2

Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(100, 65, 200)
CardStroke.Thickness = 1.5
CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ── X button (top-right, permanently closes without unlocking) ────────────────
local XBtn = Instance.new("TextButton", Card)
XBtn.Size = UDim2.new(0, 28, 0, 28)
XBtn.Position = UDim2.new(1, -36, 0, 10)
XBtn.Text = "✕"
XBtn.TextSize = 14
XBtn.Font = Enum.Font.GothamBold
XBtn.TextColor3 = Color3.fromRGB(180, 160, 220)
XBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
XBtn.BorderSizePixel = 0
XBtn.ZIndex = 10
Instance.new("UICorner", XBtn).CornerRadius = UDim.new(0, 8)

XBtn.MouseEnter:Connect(function()
    TweenService:Create(XBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
end)
XBtn.MouseLeave:Connect(function()
    TweenService:Create(XBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 35, 55)}):Play()
end)

-- Lock emoji
local LockIcon = Instance.new("TextLabel", Card)
LockIcon.Size = UDim2.new(0, 42, 0, 42)
LockIcon.Position = UDim2.new(0.5, -21, 0, 22)
LockIcon.BackgroundTransparency = 1
LockIcon.Text = "🔒"
LockIcon.TextSize = 32
LockIcon.Font = Enum.Font.GothamBold
LockIcon.ZIndex = 3

local TitleLabel = Instance.new("TextLabel", Card)
TitleLabel.Size = UDim2.new(1, -24, 0, 28)
TitleLabel.Position = UDim2.new(0, 12, 0, 74)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ChosenVessel V19"
TitleLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.ZIndex = 3

local SubLabel = Instance.new("TextLabel", Card)
SubLabel.Size = UDim2.new(1, -24, 0, 20)
SubLabel.Position = UDim2.new(0, 12, 0, 104)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Enter your access password"
SubLabel.TextColor3 = Color3.fromRGB(120, 100, 170)
SubLabel.TextSize = 12
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Center
SubLabel.ZIndex = 3

local Divider = Instance.new("Frame", Card)
Divider.Size = UDim2.new(0, 240, 0, 1)
Divider.Position = UDim2.new(0.5, -120, 0, 134)
Divider.BackgroundColor3 = Color3.fromRGB(60, 45, 100)
Divider.BorderSizePixel = 0
Divider.ZIndex = 3

local FieldLabel = Instance.new("TextLabel", Card)
FieldLabel.Size = UDim2.new(0, 256, 0, 18)
FieldLabel.Position = UDim2.new(0.5, -128, 0, 148)
FieldLabel.BackgroundTransparency = 1
FieldLabel.Text = "PASSWORD"
FieldLabel.TextColor3 = Color3.fromRGB(140, 100, 255)
FieldLabel.TextSize = 10
FieldLabel.Font = Enum.Font.GothamBold
FieldLabel.TextXAlignment = Enum.TextXAlignment.Left
FieldLabel.ZIndex = 3

-- ── Input field ───────────────────────────────────────────────────────────────
local InputBG = Instance.new("Frame", Card)
InputBG.Size = UDim2.new(0, 256, 0, 44)
InputBG.Position = UDim2.new(0.5, -128, 0, 168)
InputBG.BackgroundColor3 = Color3.fromRGB(28, 26, 42)
InputBG.BorderSizePixel = 0
InputBG.ZIndex = 3
Instance.new("UICorner", InputBG).CornerRadius = UDim.new(0, 10)

local InputStroke = Instance.new("UIStroke", InputBG)
InputStroke.Color = Color3.fromRGB(75, 55, 135)
InputStroke.Thickness = 1.5
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- THE FIX: TextBox holds the real text but is INVISIBLE.
-- We render a separate TextLabel overlay with masked/plain text.
-- This avoids the 1-letter bug caused by writing back to .Text inside a change signal.
local PasswordBox = Instance.new("TextBox", InputBG)
PasswordBox.Size = UDim2.new(1, -50, 1, 0)
PasswordBox.Position = UDim2.new(0, 12, 0, 0)
PasswordBox.BackgroundTransparency = 1
PasswordBox.Text = ""
PasswordBox.TextTransparency = 1  -- text invisible; we use DisplayLabel instead
PasswordBox.PlaceholderText = ""
PasswordBox.TextSize = 15
PasswordBox.Font = Enum.Font.Gotham
PasswordBox.ClearTextOnFocus = false
PasswordBox.ZIndex = 6  -- highest so it captures all input events

-- Display label (renders masked or plaintext)
local DisplayLabel = Instance.new("TextLabel", InputBG)
DisplayLabel.Size = UDim2.new(1, -50, 1, 0)
DisplayLabel.Position = UDim2.new(0, 12, 0, 0)
DisplayLabel.BackgroundTransparency = 1
DisplayLabel.Text = ""
DisplayLabel.TextColor3 = Color3.fromRGB(210, 200, 255)
DisplayLabel.TextSize = 16
DisplayLabel.Font = Enum.Font.Gotham
DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayLabel.ZIndex = 4

-- Placeholder (shown when empty)
local PlaceholderLabel = Instance.new("TextLabel", InputBG)
PlaceholderLabel.Size = UDim2.new(1, -50, 1, 0)
PlaceholderLabel.Position = UDim2.new(0, 12, 0, 0)
PlaceholderLabel.BackgroundTransparency = 1
PlaceholderLabel.Text = "Type password..."
PlaceholderLabel.TextColor3 = Color3.fromRGB(90, 75, 130)
PlaceholderLabel.TextSize = 14
PlaceholderLabel.Font = Enum.Font.Gotham
PlaceholderLabel.TextXAlignment = Enum.TextXAlignment.Left
PlaceholderLabel.ZIndex = 4

-- Eye toggle — ZIndex above TextBox so tap hits button not textbox
local EyeBtn = Instance.new("TextButton", InputBG)
EyeBtn.Size = UDim2.new(0, 36, 0, 36)
EyeBtn.Position = UDim2.new(1, -42, 0.5, -18)
EyeBtn.BackgroundTransparency = 1
EyeBtn.Text = "👁"
EyeBtn.TextSize = 20
EyeBtn.Font = Enum.Font.GothamBold
EyeBtn.ZIndex = 8  -- above PasswordBox so it wins the tap

-- ── Masking logic (Heartbeat poll — no re-entry, works on mobile) ─────────────
local isHidden = true
local lastSeen = ""

RunService.Heartbeat:Connect(function()
    local cur = PasswordBox.Text
    if cur == lastSeen then return end
    lastSeen = cur
    PlaceholderLabel.Visible = (#cur == 0)
    DisplayLabel.Text = isHidden and string.rep("•", #cur) or cur
end)

EyeBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    EyeBtn.Text = isHidden and "👁" or "🙈"
    local cur = PasswordBox.Text
    DisplayLabel.Text = isHidden and string.rep("•", #cur) or cur
end)

-- Focus highlight
PasswordBox.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 90, 255)}):Play()
end)
PasswordBox.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(75, 55, 135)}):Play()
end)

-- Status
local StatusLabel = Instance.new("TextLabel", Card)
StatusLabel.Size = UDim2.new(0, 256, 0, 20)
StatusLabel.Position = UDim2.new(0.5, -128, 0, 220)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.ZIndex = 3

-- Submit button
local SubmitBtn = Instance.new("TextButton", Card)
SubmitBtn.Size = UDim2.new(0, 256, 0, 44)
SubmitBtn.Position = UDim2.new(0.5, -128, 0, 248)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(95, 50, 195)
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.ZIndex = 3
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

SubmitBtn.MouseEnter:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(125, 75, 240)}):Play()
end)
SubmitBtn.MouseLeave:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(95, 50, 195)}):Play()
end)

local CreditLabel = Instance.new("TextLabel", Card)
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 1, -26)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by ChosenVessel • private build"
CreditLabel.TextColor3 = Color3.fromRGB(65, 55, 95)
CreditLabel.TextSize = 10
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.ZIndex = 3

-- ── Card shake ────────────────────────────────────────────────────────────────
local function shakeCard()
    local offsets = {-10, 9, -7, 5, -3, 2, 0}
    local i = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        i = i + 1
        if offsets[i] then
            Card.Position = UDim2.new(0.5, offsets[i], 0.5, 0)
        else
            Card.Position = UDim2.new(0.5, 0, 0.5, 0)
            conn:Disconnect()
        end
    end)
end

-- ── Destroy everything ────────────────────────────────────────────────────────
local function destroyPasswordScreen()
    BlurEffect:Destroy()
    PasswordGui:Destroy()
end

-- ── X button: close permanently without unlocking ────────────────────────────
XBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(Tint, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.35), {Size = 0}):Play()
    task.delay(0.4, destroyPasswordScreen)
end)

-- ── Unlock ────────────────────────────────────────────────────────────────────
local unlocked = false
local attempts = 0

local function onUnlock()
    if unlocked then return end
    unlocked = true

    TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 220, 120)}):Play()
    StatusLabel.TextColor3 = Color3.fromRGB(60, 220, 120)
    StatusLabel.Text = "✓ Access granted!"
    SubmitBtn.Active = false

    task.wait(0.7)

    TweenService:Create(Card, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(Tint, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 0}):Play()

    task.wait(0.55)
    destroyPasswordScreen()

    -- ══════════════════════════════════════════════════════════════════════
    -- MAIN SCRIPT (only runs after correct password)
    -- ══════════════════════════════════════════════════════════════════════
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local VU = game:GetService("VirtualUser")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local Connections = {}
    local ActiveDelays = {}
    local ActiveTweens = {}

    local function Cleanup()
        for _, c in pairs(Connections) do
            if c and c.Connected then pcall(function() c:Disconnect() end) end
        end
        table.clear(Connections)
        for _, t in pairs(ActiveDelays) do pcall(function() task.cancel(t) end) end
        table.clear(ActiveDelays)
        for _, t in pairs(ActiveTweens) do if t then pcall(function() t:Cancel() end) end end
        table.clear(ActiveTweens)
    end

    local function Setup()
        Cleanup()
        local existingGui = Player.PlayerGui:FindFirstChild("Trigger_ChosenVessel_Studs_V19")
        if existingGui then existingGui:Destroy() end
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

        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)
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
        Instance.new("UICorner", ShakeNotification).CornerRadius = UDim.new(0, 10)
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
            local si = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -60)})
            table.insert(ActiveTweens, si); si:Play()
            local ft = task.delay(1, function()
                local t1 = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -210, 1, 100)})
                local t2 = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                local t3 = TweenService:Create(NotificationText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                local t4 = TweenService:Create(NotificationIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
                local t5 = TweenService:Create(NotificationStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                for _, t in ipairs({t1,t2,t3,t4,t5}) do table.insert(ActiveTweens, t); t:Play() end
                t1.Completed:Connect(function() ShakeNotification.Visible = false end)
            end)
            table.insert(ActiveDelays, ft)
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
        CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.SourceSansBold; CloseBtn.ZIndex = 3
        Instance.new("UICorner", CloseBtn)

        local MinBtn = Instance.new("TextButton", MainFrame)
        MinBtn.Size = UDim2.new(0, 25, 0, 25)
        MinBtn.Position = UDim2.new(1, -56, 0, 2.5)
        MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = Enum.Font.SourceSansBold; MinBtn.ZIndex = 3
        Instance.new("UICorner", MinBtn)

        local ContentFrame = Instance.new("Frame", MainFrame)
        ContentFrame.Size = UDim2.new(1, 0, 1, -30)
        ContentFrame.Position = UDim2.new(0, 0, 0, 30)
        ContentFrame.BackgroundTransparency = 1; ContentFrame.ZIndex = 2

        local ToggleBtn = Instance.new("TextButton", ContentFrame)
        ToggleBtn.Size = UDim2.new(0, 180, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0, 5)
        ToggleBtn.Text = "OFF"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
        ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", ToggleBtn)

        local TargetMode = "All"
        local TargetBtn = Instance.new("TextButton", ContentFrame)
        TargetBtn.Size = UDim2.new(0, 180, 0, 35); TargetBtn.Position = UDim2.new(0, 10, 0, 45)
        TargetBtn.Text = "Toys & Players & Npc"; TargetBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TargetBtn.TextColor3 = Color3.new(1,1,1); TargetBtn.Font = Enum.Font.SourceSansBold
        TargetBtn.TextSize = 12
        Instance.new("UICorner", TargetBtn)

        local function makeLabel(parent, pos, text)
            local l = Instance.new("TextLabel", parent)
            l.Size = UDim2.new(0, 180, 0, 15); l.Position = pos
            l.Text = text; l.BackgroundTransparency = 1
            l.TextColor3 = Color3.new(0.9,0.9,0.9); l.TextSize = 10
            return l
        end
        local function makeInput(parent, pos, default)
            local b = Instance.new("TextBox", parent)
            b.Size = UDim2.new(0, 180, 0, 30); b.Position = pos
            b.Text = default; b.BackgroundColor3 = Color3.fromRGB(40,40,40)
            b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b)
            return b
        end

        makeLabel(ContentFrame, UDim2.new(0,10,0,85), "Reaction Delay")
        local ReactionInput = makeInput(ContentFrame, UDim2.new(0,10,0,100), "0.01")
        makeLabel(ContentFrame, UDim2.new(0,10,0,135), "Grab Cooldown")
        local LockInput = makeInput(ContentFrame, UDim2.new(0,10,0,150), "1.2")
        makeLabel(ContentFrame, UDim2.new(0,10,0,185), "Range Distance")
        local RangeInput = makeInput(ContentFrame, UDim2.new(0,10,0,200), "20")

        local RangeNote = Instance.new("TextLabel", ContentFrame)
        RangeNote.Size = UDim2.new(0,180,0,35); RangeNote.Position = UDim2.new(0,10,0,235)
        RangeNote.Text = "Range (30 = Farther Reach) (20 = Non-Gp)"
        RangeNote.BackgroundTransparency = 1; RangeNote.TextColor3 = Color3.fromRGB(200,200,200)
        RangeNote.TextSize = 10; RangeNote.TextWrapped = true; RangeNote.Font = Enum.Font.SourceSansItalic

        if UserInputService.AccelerometerEnabled then
            local lastShakeTime = 0
            local lastAcceleration = Vector3.new(0,0,0)
            Connections.ShakeDetection = UserInputService.DeviceAccelerationChanged:Connect(function(acceleration)
                if not MainFrame.Visible then
                    local currentAccel = acceleration.Position
                    local currentTime = tick()
                    local delta = (currentAccel - lastAcceleration).Magnitude
                    if delta > 15 and (currentTime - lastShakeTime) > 1 then
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
            if Player.Character then raycastParams.FilterDescendantsInstances = {Player.Character} end
            local result = workspace:Spherecast(origin, radius, direction * range, raycastParams)
            if result and result.Instance then
                local hit = result.Instance
                if hit.Name:lower():find("pallet") or (hit.Parent and hit.Parent.Name:lower():find("pallet")) then return false end
                local model = hit:FindFirstAncestorOfClass("Model")
                if model and model:FindFirstChildOfClass("Humanoid") and model.Humanoid.Health > 0 then return true end
                if TargetMode == "All" and hit:IsA("BasePart") and not hit.Anchored then return true end
            end
            return false
        end

        local function performGrab()
            local char = Player.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            local center = Camera.ViewportSize / 2
            VU:CaptureController(); VU:Button1Down(center); task.wait(0.01); VU:Button1Up(center)
        end

        local function updateGUIState(newState)
            active = newState; canGrab = true; targetDetectedTime = 0
            ToggleBtn.Text = active and "ON" or "OFF"
            ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
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
                if not found then found = checkArea(origin, (currentLookDir + lastLookDir).Unit, range, dynamicRadius) end
                if found then
                    if targetDetectedTime == 0 then targetDetectedTime = tick() end
                    if (tick() - targetDetectedTime) >= (tonumber(ReactionInput.Text) or 0.1) then
                        canGrab = false; performGrab()
                        local dt = task.delay(tonumber(LockInput.Text) or 1.2, function() canGrab = true end)
                        table.insert(ActiveDelays, dt)
                        targetDetectedTime = 0
                    end
                else
                    targetDetectedTime = 0
                end
                lastLookDir = currentLookDir
            end
        end)

        Connections.TargetBtn = TargetBtn.MouseButton1Click:Connect(function()
            if TargetMode == "All" then TargetMode = "Players"; TargetBtn.Text = "Players & Npc"
            else TargetMode = "All"; TargetBtn.Text = "Toys & Players & Npc" end
        end)
        Connections.CloseBtn = CloseBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = false; ShowNotification()
        end)
        Connections.MinBtn = MinBtn.MouseButton1Click:Connect(function()
            if not animating then
                animating = true
                if MainFrame.Size.Y.Offset > 50 then
                    ContentFrame.Visible = false
                    MainFrame:TweenSize(UDim2.new(0,200,0,30),"Out","Quart",0.3,true,function()
                        animating = false; MinBtn.Text = "+"
                    end)
                else
                    MinBtn.Text = "-"
                    MainFrame:TweenSize(UDim2.new(0,200,0,330),"Out","Back",0.4,true,function()
                        MainFrame:TweenSize(UDim2.new(0,200,0,320),"Out","Quart",0.1,true)
                        ContentFrame.Visible = true; animating = false
                    end)
                end
            end
        end)
        Connections.ToggleBtn = ToggleBtn.MouseButton1Click:Connect(function()
            updateGUIState(not active)
        end)
    end

    Connections.CharacterAdded = Player.CharacterAdded:Connect(function()
        task.wait(0.5); Setup()
    end)
    if Player.Character then Setup() else Player.CharacterAdded:Wait(); Setup() end
end

-- ── Submit ────────────────────────────────────────────────────────────────────
local function tryPassword()
    if unlocked then return end
    local entered = PasswordBox.Text

    if entered == CORRECT_PASSWORD then
        onUnlock()
    else
        attempts = attempts + 1
        shakeCard()
        TweenService:Create(CardStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 60, 60)}):Play()
        task.delay(0.5, function()
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 65, 200)}):Play()
        end)
        TweenService:Create(InputBG, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 18, 18)}):Play()
        task.delay(0.45, function()
            TweenService:Create(InputBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 26, 42)}):Play()
        end)
        StatusLabel.Text = attempts >= 3
            and ("❌ Wrong password (" .. attempts .. " attempts)")
            or "❌ Incorrect password"
        task.delay(2.5, function()
            if StatusLabel and StatusLabel.Parent then StatusLabel.Text = "" end
        end)
        -- Clear the textbox and reset tracking
        PasswordBox.Text = ""
        lastSeen = ""
        DisplayLabel.Text = ""
        PlaceholderLabel.Visible = true
    end
end

SubmitBtn.MouseButton1Click:Connect(tryPassword)
PasswordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryPassword() end
end)

-- ── Entrance animation ────────────────────────────────────────────────────────
Card.Size = UDim2.new(0, 0, 0, 0)
Card.BackgroundTransparency = 1
TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 355),
    BackgroundTransparency = 0,
}):Play()
