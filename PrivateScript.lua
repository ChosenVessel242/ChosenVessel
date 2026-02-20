-- ╔══════════════════════════════════════╗
-- ║   PASSWORD GATE — ChosenVessel V19   ║
-- ╚══════════════════════════════════════╝

local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local CORRECT_PASSWORD = "Chosen X Antarctica"

-- ── Password Screen ──────────────────────────────────────────────────────────

local PasswordGui = Instance.new("ScreenGui", Player.PlayerGui)
PasswordGui.Name = "CV_PasswordGate"
PasswordGui.ResetOnSpawn = false
PasswordGui.DisplayOrder = 999

-- Dark full-screen backdrop
local Backdrop = Instance.new("Frame", PasswordGui)
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BorderSizePixel = 0

-- Subtle animated gradient overlay
local GradientFrame = Instance.new("Frame", Backdrop)
GradientFrame.Size = UDim2.new(1, 0, 1, 0)
GradientFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GradientFrame.BackgroundTransparency = 0.6
GradientFrame.BorderSizePixel = 0
local UIGradient = Instance.new("UIGradient", GradientFrame)
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 5, 5)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40)),
})
UIGradient.Rotation = 135

-- Animate gradient rotation
local gradAngle = 135
local gradConn = RunService.Heartbeat:Connect(function(dt)
    gradAngle = (gradAngle + dt * 15) % 360
    UIGradient.Rotation = gradAngle
end)

-- Card container
local Card = Instance.new("Frame", Backdrop)
Card.Size = UDim2.new(0, 320, 0, 370)
Card.Position = UDim2.new(0.5, -160, 0.5, -185)
Card.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Card.BorderSizePixel = 0

local CardCorner = Instance.new("UICorner", Card)
CardCorner.CornerRadius = UDim.new(0, 16)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(90, 60, 160)
CardStroke.Thickness = 1.5
CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Glow effect behind card
local Glow = Instance.new("ImageLabel", Backdrop)
Glow.Size = UDim2.new(0, 480, 0, 480)
Glow.Position = UDim2.new(0.5, -240, 0.5, -240)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857472" -- soft radial glow
Glow.ImageColor3 = Color3.fromRGB(80, 40, 180)
Glow.ImageTransparency = 0.7
Glow.ZIndex = 0

-- Pulse the glow
local glowDir = -1
local glowTrans = 0.7
RunService.Heartbeat:Connect(function(dt)
    glowTrans = glowTrans + dt * 0.3 * glowDir
    if glowTrans <= 0.5 then glowDir = 1 end
    if glowTrans >= 0.8 then glowDir = -1 end
    Glow.ImageTransparency = glowTrans
end)

-- Lock icon (top center of card)
local LockIcon = Instance.new("ImageLabel", Card)
LockIcon.Size = UDim2.new(0, 52, 0, 52)
LockIcon.Position = UDim2.new(0.5, -26, 0, 24)
LockIcon.BackgroundTransparency = 1
LockIcon.Image = "rbxasset://textures/ui/Shell/Icons/LockIcon.png"
LockIcon.ImageColor3 = Color3.fromRGB(160, 110, 255)
LockIcon.ZIndex = 2

-- Title
local TitleLabel = Instance.new("TextLabel", Card)
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 86)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ChosenVessel V19"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.ZIndex = 2

-- Subtitle
local SubLabel = Instance.new("TextLabel", Card)
SubLabel.Size = UDim2.new(1, -20, 0, 20)
SubLabel.Position = UDim2.new(0, 10, 0, 118)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Enter access password to continue"
SubLabel.TextColor3 = Color3.fromRGB(130, 110, 170)
SubLabel.TextSize = 12
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Center
SubLabel.ZIndex = 2

-- Divider line
local Divider = Instance.new("Frame", Card)
Divider.Size = UDim2.new(0, 240, 0, 1)
Divider.Position = UDim2.new(0.5, -120, 0, 148)
Divider.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
Divider.BorderSizePixel = 0

-- "Password" field label
local FieldLabel = Instance.new("TextLabel", Card)
FieldLabel.Size = UDim2.new(0, 260, 0, 18)
FieldLabel.Position = UDim2.new(0.5, -130, 0, 162)
FieldLabel.BackgroundTransparency = 1
FieldLabel.Text = "PASSWORD"
FieldLabel.TextColor3 = Color3.fromRGB(150, 110, 255)
FieldLabel.TextSize = 10
FieldLabel.Font = Enum.Font.GothamBold
FieldLabel.TextXAlignment = Enum.TextXAlignment.Left
FieldLabel.ZIndex = 2

-- Input box background
local InputBG = Instance.new("Frame", Card)
InputBG.Size = UDim2.new(0, 260, 0, 42)
InputBG.Position = UDim2.new(0.5, -130, 0, 182)
InputBG.BackgroundColor3 = Color3.fromRGB(30, 28, 45)
InputBG.BorderSizePixel = 0
InputBG.ZIndex = 2
local InputCorner = Instance.new("UICorner", InputBG)
InputCorner.CornerRadius = UDim.new(0, 10)
local InputStroke = Instance.new("UIStroke", InputBG)
InputStroke.Color = Color3.fromRGB(80, 55, 140)
InputStroke.Thickness = 1.5
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Actual TextBox
local PasswordBox = Instance.new("TextBox", InputBG)
PasswordBox.Size = UDim2.new(1, -40, 1, 0)
PasswordBox.Position = UDim2.new(0, 14, 0, 0)
PasswordBox.BackgroundTransparency = 1
PasswordBox.PlaceholderText = "Enter password..."
PasswordBox.PlaceholderColor3 = Color3.fromRGB(80, 70, 110)
PasswordBox.Text = ""
PasswordBox.TextColor3 = Color3.fromRGB(220, 215, 255)
PasswordBox.TextSize = 14
PasswordBox.Font = Enum.Font.Gotham
PasswordBox.ClearTextOnFocus = false
PasswordBox.TextXAlignment = Enum.TextXAlignment.Left
PasswordBox.ZIndex = 3

-- Eye toggle (show/hide password)
local EyeBtn = Instance.new("TextButton", InputBG)
EyeBtn.Size = UDim2.new(0, 28, 0, 28)
EyeBtn.Position = UDim2.new(1, -34, 0.5, -14)
EyeBtn.BackgroundTransparency = 1
EyeBtn.Text = "👁"
EyeBtn.TextSize = 16
EyeBtn.Font = Enum.Font.GothamBold
EyeBtn.ZIndex = 4

local isHidden = true
PasswordBox.TextTransparency = 1 -- start invisible, we draw bullets manually

-- We fake masked input with bullet characters
local realText = ""
local function updateDisplay()
    if isHidden then
        PasswordBox.Text = string.rep("•", #realText)
    else
        PasswordBox.Text = realText
    end
    -- keep cursor at end
    PasswordBox.CursorPosition = #PasswordBox.Text + 1
end

EyeBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    EyeBtn.Text = isHidden and "👁" or "🙈"
    updateDisplay()
end)

PasswordBox:GetPropertyChangedSignal("Text"):Connect(function()
    local new = PasswordBox.Text
    if isHidden then
        -- count difference and apply to realText
        local bullets = string.rep("•", #realText)
        if new ~= bullets then
            -- figure out what changed
            if #new > #realText then
                local added = string.sub(new, #realText + 1)
                realText = realText .. added
            elseif #new < #realText then
                realText = string.sub(realText, 1, #new)
            end
            updateDisplay()
        end
    else
        realText = new
    end
end)

-- Highlight input on focus
PasswordBox.Focused:Connect(function()
    local tween = TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 90, 255)})
    tween:Play()
end)
PasswordBox.FocusLost:Connect(function()
    local tween = TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 55, 140)})
    tween:Play()
end)

-- Status label (wrong password / hint)
local StatusLabel = Instance.new("TextLabel", Card)
StatusLabel.Size = UDim2.new(0, 260, 0, 18)
StatusLabel.Position = UDim2.new(0.5, -130, 0, 230)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.ZIndex = 2

-- Submit button
local SubmitBtn = Instance.new("TextButton", Card)
SubmitBtn.Size = UDim2.new(0, 260, 0, 44)
SubmitBtn.Position = UDim2.new(0.5, -130, 0, 258)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(100, 55, 200)
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.ZIndex = 2
local SubmitCorner = Instance.new("UICorner", SubmitBtn)
SubmitCorner.CornerRadius = UDim.new(0, 10)

-- Hover effect on submit
SubmitBtn.MouseEnter:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(130, 75, 240)}):Play()
end)
SubmitBtn.MouseLeave:Connect(function()
    TweenService:Create(SubmitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 55, 200)}):Play()
end)

-- Credit label at bottom
local CreditLabel = Instance.new("TextLabel", Card)
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 1, -28)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by ChosenVessel • private build"
CreditLabel.TextColor3 = Color3.fromRGB(70, 60, 100)
CreditLabel.TextSize = 10
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.ZIndex = 2

-- Shake animation on wrong password
local function shakeCard()
    local origin = Card.Position
    local offsets = {-12, 10, -8, 6, -4, 2, 0}
    local shakeConn
    local i = 0
    shakeConn = RunService.Heartbeat:Connect(function()
        i = i + 1
        if offsets[i] then
            Card.Position = UDim2.new(origin.X.Scale, origin.X.Offset + offsets[i], origin.Y.Scale, origin.Y.Offset)
        else
            Card.Position = origin
            shakeConn:Disconnect()
        end
    end)
end

-- ── Unlock Logic ─────────────────────────────────────────────────────────────

local function onUnlock()
    -- Flash green border
    TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 220, 120)}):Play()
    StatusLabel.Text = "✓ Access granted!"
    StatusLabel.TextColor3 = Color3.fromRGB(60, 220, 120)
    SubmitBtn.Active = false

    task.wait(0.6)

    -- Fade out password GUI
    TweenService:Create(Backdrop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
    }):Play()

    task.wait(0.55)
    gradConn:Disconnect()
    PasswordGui:Destroy()

    -- ══════════════════════════════════════════════════════════════════════
    -- MAIN SCRIPT (runs only after correct password)
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
            if tween then pcall(function() tween:Cancel() end) end
        end
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

            local slideIn = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -60)})
            table.insert(ActiveTweens, slideIn)
            slideIn:Play()

            local fadeThread = task.delay(1, function()
                local fadeOut = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -210, 1, 100)})
                local transparencyTween = TweenService:Create(ShakeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                local textFade = TweenService:Create(NotificationText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                local iconFade = TweenService:Create(NotificationIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
                local strokeFade = TweenService:Create(NotificationStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
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
                fadeOut.Completed:Connect(function() ShakeNotification.Visible = false end)
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
                    if model.Humanoid.Health > 0 then return true end
                end
                if TargetMode == "All" then
                    if hit:IsA("BasePart") and not hit.Anchored then return true end
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
                    if targetDetectedTime == 0 then targetDetectedTime = tick() end
                    local delayTime = tonumber(ReactionInput.Text) or 0.1
                    if (tick() - targetDetectedTime) >= delayTime then
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
end

-- ── Submit handler ────────────────────────────────────────────────────────────

local attempts = 0

local function tryPassword()
    if realText == CORRECT_PASSWORD then
        onUnlock()
    else
        attempts = attempts + 1
        shakeCard()
        TweenService:Create(CardStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 60, 60)}):Play()
        task.delay(0.4, function()
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(90, 60, 160)}):Play()
        end)

        if attempts >= 3 then
            StatusLabel.Text = "❌ Wrong password (" .. attempts .. " attempts)"
        else
            StatusLabel.Text = "❌ Incorrect password"
        end

        -- Brief red flash on input
        TweenService:Create(InputBG, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}):Play()
        task.delay(0.4, function()
            TweenService:Create(InputBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 28, 45)}):Play()
        end)

        -- Clear after a moment
        task.delay(2, function()
            if StatusLabel and StatusLabel.Parent then
                StatusLabel.Text = ""
            end
        end)

        realText = ""
        updateDisplay()
    end
end

SubmitBtn.MouseButton1Click:Connect(tryPassword)
PasswordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryPassword() end
end)

-- ── Entrance animation ────────────────────────────────────────────────────────
Card.Size = UDim2.new(0, 0, 0, 0)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.BackgroundTransparency = 1

TweenService:Create(Card, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 370),
    Position = UDim2.new(0.5, -160, 0.5, -185),
    BackgroundTransparency = 0,
}):Play()
