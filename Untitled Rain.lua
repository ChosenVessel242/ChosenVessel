--[[
    🌧️ RainClient LocalScript
    Place in: StarterPlayerScripts

    /rainstart  — start rain
    /rainstop   — stop rain
]]

-- ─── SERVICES ────────────────────────────────────────────────────────────────
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting     = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ─── DROP CONFIG ─────────────────────────────────────────────────────────────
local POOL_SIZE        = 260
local DROP_SPREAD      = 70
local DROP_HEIGHT      = 45
local EXCLUSION_RADIUS = 12
local EXCLUSION_BREAK  = 0.12
local DROP_SIZE        = Vector3.new(0.03, 0.75, 0.03)
local DROP_COLOR       = Color3.fromRGB(174, 202, 226)
local DROP_TRANS       = 0.20
local DROP_MAT         = Enum.Material.Glass
local DROP_TILT        = CFrame.Angles(math.rad(6), math.rad(16), 0)
local FALL_MIN         = 100
local FALL_MAX         = 150
local WIND_X           = 8
local WIND_Z           = 3

-- ─── PUDDLE CONFIG ───────────────────────────────────────────────────────────
local PUDDLE_POOL_SIZE   = 45
local PUDDLE_SPAWN_RATE  = 0.16
local PUDDLE_MIN_SIZE    = 0.55
local PUDDLE_MAX_SIZE    = 1.80
local PUDDLE_FADE_MIN    = 2.2
local PUDDLE_FADE_MAX    = 4.5
local PUDDLE_COLOR       = Color3.fromRGB(120, 145, 168)
local PUDDLE_START_TRANS = 0.22

-- ─── SPLASH CONFIG ───────────────────────────────────────────────────────────
local SPLASH_POOL_SIZE = 18
local SPLASH_COOLDOWN  = 0.04

-- ─── SOUND ───────────────────────────────────────────────────────────────────
local RAIN_SOUND_ID = "rbxassetid://138911277964858"
local RAIN_VOLUME   = 0.55

-- ─── CHAMS CONFIG ────────────────────────────────────────────────────────────
local CHAM_FILL_COLOR        = Color3.fromRGB(120, 0, 200)
local CHAM_OUTLINE_COLOR     = Color3.fromRGB(180, 60, 255)
local CHAM_FILL_TRANS        = 0.72
local CHAM_OUTLINE_TRANS     = 0.0

-- ─── LIGHTING ────────────────────────────────────────────────────────────────
local CFG = {
    ClockTime            = 9.5,
    Brightness           = 0.55,
    ExposureCompensation = -0.2,
    Ambient              = Color3.fromRGB(85, 88, 108),
    OutdoorAmbient       = Color3.fromRGB(70, 74, 95),
    ColorShiftTop        = Color3.fromRGB(30, 28, 55),
    ColorShiftBottom     = Color3.fromRGB(18, 16, 40),
    FogEnd               = 1100,
    FogStart             = 380,
    FogColor             = Color3.fromRGB(110, 108, 130),
    AtmDensity           = 0.07,
    AtmHaze              = 1.4,
    AtmGlare             = 0,
    AtmColor             = Color3.fromRGB(125, 118, 148),
    AtmDecay             = Color3.fromRGB(90, 85, 115),
    CCTintColor          = Color3.fromRGB(195, 175, 255),
    CCBrightness         = 0.0,
    CCContrast           = 0.05,
    CCSaturation         = -0.15,
    FadeTime             = 3.5,
}

-- ─── SAVE ORIGINALS ──────────────────────────────────────────────────────────
local origL = {
    ClockTime            = Lighting.ClockTime,
    Brightness           = Lighting.Brightness,
    ExposureCompensation = Lighting.ExposureCompensation,
    Ambient              = Lighting.Ambient,
    OutdoorAmbient       = Lighting.OutdoorAmbient,
    ColorShift_Top       = Lighting.ColorShift_Top,
    ColorShift_Bottom    = Lighting.ColorShift_Bottom,
    FogEnd               = Lighting.FogEnd,
    FogStart             = Lighting.FogStart,
    FogColor             = Lighting.FogColor,
}

local rng = Random.new()

local function tweenLighting(props, t)
    local ok, err = pcall(function()
        TweenService:Create(Lighting, TweenInfo.new(t, Enum.EasingStyle.Sine), props):Play()
    end)
    if not ok then
        -- Fallback: set directly if tween fails
        for k, v in pairs(props) do
            pcall(function() Lighting[k] = v end)
        end
    end
end

local function getRootPos()
    local char = player.Character
    if not char then return nil end
    local r = char:FindFirstChild("HumanoidRootPart")
    return r and r.Position or nil
end

-- ─── SKY ─────────────────────────────────────────────────────────────────────
local savedCelestial = nil
local existingSky    = nil

local function darkenSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then
            existingSky            = v
            savedCelestial         = v.CelestialBodiesShown
            v.CelestialBodiesShown = false
            break
        end
    end
end

local function restoreSky()
    if existingSky and savedCelestial ~= nil then
        existingSky.CelestialBodiesShown = savedCelestial
        existingSky    = nil
        savedCelestial = nil
    end
end

-- ─── ATMOSPHERE ──────────────────────────────────────────────────────────────
local rainAtm  = nil
local savedAtm = nil

local function setupAtmosphere()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") then savedAtm = v; v.Parent = nil; break end
    end
    rainAtm         = Instance.new("Atmosphere")
    rainAtm.Density = CFG.AtmDensity
    rainAtm.Haze    = CFG.AtmHaze
    rainAtm.Glare   = CFG.AtmGlare
    rainAtm.Color   = CFG.AtmColor
    rainAtm.Decay   = CFG.AtmDecay
    rainAtm.Offset  = 0
    rainAtm.Parent  = Lighting
end

local function teardownAtmosphere()
    if rainAtm  then rainAtm:Destroy();           rainAtm  = nil end
    if savedAtm then savedAtm.Parent = Lighting;  savedAtm = nil end
end

-- ─── COLOR CORRECTION ────────────────────────────────────────────────────────
local rainCC  = nil
local savedCC = nil

local function setupColorCorrection()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then savedCC = v; v.Parent = nil; break end
    end
    rainCC            = Instance.new("ColorCorrectionEffect")
    rainCC.TintColor  = CFG.CCTintColor
    rainCC.Brightness = CFG.CCBrightness
    rainCC.Contrast   = CFG.CCContrast
    rainCC.Saturation = CFG.CCSaturation
    rainCC.Parent     = Lighting
end

local function teardownColorCorrection()
    if rainCC  then rainCC:Destroy();           rainCC  = nil end
    if savedCC then savedCC.Parent = Lighting;  savedCC = nil end
end

-- ─── SOUND ───────────────────────────────────────────────────────────────────
local rainSound = nil

local function startSound()
    rainSound             = Instance.new("Sound")
    rainSound.SoundId     = RAIN_SOUND_ID
    rainSound.Volume      = RAIN_VOLUME
    rainSound.Looped      = true
    rainSound.RollOffMode = Enum.RollOffMode.InverseTapered
    rainSound.Parent      = camera
    rainSound:Play()
end

local function stopSound()
    if rainSound then rainSound:Stop(); rainSound:Destroy(); rainSound = nil end
end

-- ─── CHAMS ───────────────────────────────────────────────────────────────────
local highlights      = {}
local chamConnections = {}
local playerAddedConn   = nil
local playerRemovedConn = nil

local function addCham(targetPlayer)
    if targetPlayer == player then return end
    local char = targetPlayer.Character
    if not char then return end

    local existing = highlights[targetPlayer]
    if existing then existing:Destroy(); highlights[targetPlayer] = nil end

    local hl = Instance.new("Highlight")
    hl.Name                = "RainCham"
    hl.DepthMode           = Enum.HighlightDepthMode.Occluded
    hl.FillColor           = CHAM_FILL_COLOR
    hl.OutlineColor        = CHAM_OUTLINE_COLOR
    hl.FillTransparency    = CHAM_FILL_TRANS
    hl.OutlineTransparency = CHAM_OUTLINE_TRANS
    hl.Adornee             = char
    hl.Parent              = char

    highlights[targetPlayer] = hl
end

local function removeCham(targetPlayer)
    local hl = highlights[targetPlayer]
    if hl then hl:Destroy(); highlights[targetPlayer] = nil end
end

local function removeAllChams()
    for p, hl in pairs(highlights) do
        hl:Destroy()
        highlights[p] = nil
    end
end

local function hookPlayer(p)
    if p == player then return end
    if p.Character then addCham(p) end
    local conn = p.CharacterAdded:Connect(function()
        task.wait(0.1)
        addCham(p)
    end)
    chamConnections[p] = conn
end

local function unhookPlayer(p)
    removeCham(p)
    if chamConnections[p] then
        chamConnections[p]:Disconnect()
        chamConnections[p] = nil
    end
end

local function startChams()
    for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
    playerAddedConn   = Players.PlayerAdded:Connect(hookPlayer)
    playerRemovedConn = Players.PlayerRemoving:Connect(unhookPlayer)
end

local function stopChams()
    if playerAddedConn   then playerAddedConn:Disconnect();   playerAddedConn   = nil end
    if playerRemovedConn then playerRemovedConn:Disconnect(); playerRemovedConn = nil end
    for p in pairs(chamConnections) do
        if chamConnections[p] then chamConnections[p]:Disconnect() end
    end
    table.clear(chamConnections)
    removeAllChams()
end

-- ─── SPLASH POOL ─────────────────────────────────────────────────────────────
local splashPool     = {}
local splashFolder   = nil
local lastSplashTime = 0

local function buildSplashPool()
    splashFolder        = Instance.new("Folder")
    splashFolder.Name   = "SplashPool"
    splashFolder.Parent = workspace

    for i = 1, SPLASH_POOL_SIZE do
        local p = Instance.new("Part")
        p.Name         = "SP"
        p.Size         = Vector3.new(0.2, 0.2, 0.2)
        p.Anchored     = true
        p.CanCollide   = false
        p.CanQuery     = false
        p.CanTouch     = false
        p.CastShadow   = false
        p.Transparency = 1
        p.Parent       = splashFolder

        local e = Instance.new("ParticleEmitter")
        e.Rate              = 0
        e.Lifetime          = NumberRange.new(0.10, 0.28)
        e.Speed             = NumberRange.new(3, 10)
        e.Size              = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.06),
            NumberSequenceKeypoint.new(0.4, 0.035),
            NumberSequenceKeypoint.new(1,   0.0),
        })
        e.Transparency      = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.05),
            NumberSequenceKeypoint.new(1,   1.0),
        })
        e.Color             = ColorSequence.new(Color3.fromRGB(185, 210, 230))
        e.LightInfluence    = 0.95
        e.SpreadAngle       = Vector2.new(55, 55)
        e.EmissionDirection = Enum.NormalId.Top
        e.RotSpeed          = NumberRange.new(-15, 15)
        e.Parent            = p

        splashPool[i] = { part = p, emitter = e, busy = false }
    end
end

local function destroySplashPool()
    if splashFolder then splashFolder:Destroy(); splashFolder = nil end
    table.clear(splashPool)
end

local function fireSplash(hitPos)
    local now = tick()
    if (now - lastSplashTime) < SPLASH_COOLDOWN then return end
    lastSplashTime = now
    for _, slot in ipairs(splashPool) do
        if not slot.busy then
            slot.busy = true
            slot.part.CFrame = CFrame.new(hitPos + Vector3.new(0, 0.05, 0))
            slot.emitter:Emit(rng:NextInteger(3, 5))
            task.delay(0.35, function() slot.busy = false end)
            return
        end
    end
end

-- ─── PUDDLE POOL ─────────────────────────────────────────────────────────────
local puddles      = {}
local puddleFolder = nil
local lastPuddle   = 0

local function buildPuddlePool()
    puddleFolder        = Instance.new("Folder")
    puddleFolder.Name   = "Puddles"
    puddleFolder.Parent = workspace

    for i = 1, PUDDLE_POOL_SIZE do
        local p = Instance.new("Part")
        p.Shape        = Enum.PartType.Cylinder
        p.Size         = Vector3.new(0.045, PUDDLE_MIN_SIZE, PUDDLE_MIN_SIZE)
        p.Anchored     = true
        p.CanCollide   = false
        p.CanQuery     = false
        p.CanTouch     = false
        p.CastShadow   = false
        p.Material     = Enum.Material.SmoothPlastic
        p.Color        = PUDDLE_COLOR
        p.Transparency = 1
        p.Parent       = puddleFolder
        puddles[i]     = { part = p, busy = false }
    end
end

local function destroyPuddlePool()
    if puddleFolder then puddleFolder:Destroy(); puddleFolder = nil end
    table.clear(puddles)
end

local function spawnPuddle(pos)
    for _, slot in ipairs(puddles) do
        if not slot.busy then
            slot.busy = true
            local s = rng:NextNumber(PUDDLE_MIN_SIZE, PUDDLE_MAX_SIZE)
            slot.part.Size        = Vector3.new(0.045, s, s)
            slot.part.CFrame      = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
            slot.part.Transparency = PUDDLE_START_TRANS
            local ft = rng:NextNumber(PUDDLE_FADE_MIN, PUDDLE_FADE_MAX)
            local tw = TweenService:Create(
                slot.part,
                TweenInfo.new(ft, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
                { Transparency = 1 }
            )
            tw:Play()
            tw.Completed:Connect(function() slot.busy = false end)
            return
        end
    end
end

-- ─── DROP POOL ───────────────────────────────────────────────────────────────
local drops      = {}
local dropFolder = nil

local dropRayParams = RaycastParams.new()
dropRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getExclusions()
    local t = { splashFolder, puddleFolder, dropFolder }
    if player.Character then table.insert(t, player.Character) end
    return t
end

local function findGroundY(wx, rootY, wz)
    dropRayParams.FilterDescendantsInstances = getExclusions()
    local origin = Vector3.new(wx, rootY + DROP_HEIGHT + 5, wz)
    local dir    = Vector3.new(0, -(DROP_HEIGHT + rootY + 60), 0)
    local hit    = workspace:Raycast(origin, dir, dropRayParams)
    return hit and hit.Position.Y or nil
end

local function randomXZ(rootPos)
    local breaksRule = rng:NextNumber() < EXCLUSION_BREAK
    for _ = 1, 8 do
        local angle  = rng:NextNumber(0, math.pi * 2)
        local radius = rng:NextNumber(0, DROP_SPREAD)
        local x      = rootPos.X + math.cos(angle) * radius
        local z      = rootPos.Z + math.sin(angle) * radius
        local dx, dz = x - rootPos.X, z - rootPos.Z
        if breaksRule or math.sqrt(dx * dx + dz * dz) >= EXCLUSION_RADIUS then
            return x, z
        end
    end
    local a = rng:NextNumber(0, math.pi * 2)
    return rootPos.X + math.cos(a) * EXCLUSION_RADIUS,
           rootPos.Z + math.sin(a) * EXCLUSION_RADIUS
end

local function recycleDrop(d, rootPos)
    local x, z   = randomXZ(rootPos)
    local spawnY = rootPos.Y + DROP_HEIGHT + rng:NextNumber(0, 10)
    d.pos         = Vector3.new(x, spawnY, z)
    d.speed       = rng:NextNumber(FALL_MIN, FALL_MAX)
    d.groundY     = findGroundY(x, rootPos.Y, z)
    d.part.CFrame = CFrame.new(d.pos) * DROP_TILT
end

local function buildPool(rootPos)
    dropFolder        = Instance.new("Folder")
    dropFolder.Name   = "RainDrops"
    dropFolder.Parent = workspace

    for i = 1, POOL_SIZE do
        local p = Instance.new("Part")
        p.Name         = "D"
        p.Size         = DROP_SIZE
        p.Anchored     = true
        p.CanCollide   = false
        p.CanQuery     = false
        p.CanTouch     = false
        p.CastShadow   = false
        p.Material     = DROP_MAT
        p.Color        = DROP_COLOR
        p.Transparency = DROP_TRANS
        p.Parent       = dropFolder

        local d = { part = p, pos = Vector3.zero, speed = 0, groundY = nil }
        drops[i] = d
        recycleDrop(d, rootPos)
    end
end

local function destroyPool()
    if dropFolder then dropFolder:Destroy(); dropFolder = nil end
    table.clear(drops)
end

-- ─── LOOPS ───────────────────────────────────────────────────────────────────
local loopConn   = nil
local puddleConn = nil

local function startLoops()
    loopConn = RunService.Heartbeat:Connect(function(dt)
        local rootPos = getRootPos()
        if not rootPos or #drops == 0 then return end
        local fallbackY = rootPos.Y - 8

        for _, d in ipairs(drops) do
            local p  = d.pos
            local nx = p.X + WIND_X * dt * 0.42
            local ny = p.Y - d.speed * dt
            local nz = p.Z + WIND_Z * dt * 0.42
            local impactY = d.groundY or fallbackY

            if ny <= impactY then
                fireSplash(Vector3.new(nx, impactY, nz))
                recycleDrop(d, rootPos)
            else
                d.pos = Vector3.new(nx, ny, nz)
                d.part.CFrame = CFrame.new(d.pos) * DROP_TILT
            end
        end
    end)

    puddleConn = RunService.Heartbeat:Connect(function()
        local now = tick()
        if (now - lastPuddle) < PUDDLE_SPAWN_RATE then return end
        lastPuddle = now

        local rootPos = getRootPos()
        if not rootPos then return end

        local angle  = rng:NextNumber(0, math.pi * 2)
        local radius = rng:NextNumber(3, DROP_SPREAD * 0.85)
        local ox = rootPos.X + math.cos(angle) * radius
        local oz = rootPos.Z + math.sin(angle) * radius

        local pp = RaycastParams.new()
        pp.FilterType = Enum.RaycastFilterType.Exclude
        pp.FilterDescendantsInstances = getExclusions()

        local hit = workspace:Raycast(
            Vector3.new(ox, rootPos.Y + 12, oz),
            Vector3.new(0, -22, 0),
            pp
        )
        if hit then
            spawnPuddle(hit.Position + Vector3.new(0, 0.025, 0))
        end
    end)
end

local function stopLoops()
    if loopConn   then loopConn:Disconnect();   loopConn   = nil end
    if puddleConn then puddleConn:Disconnect(); puddleConn = nil end
end

-- ─── RAIN ON / OFF ───────────────────────────────────────────────────────────
local active = false

local function startRain()
    if active then print("[Rain] Already raining.") return end
    active = true

    darkenSky()
    setupAtmosphere()
    setupColorCorrection()
    startSound()
    startChams()

    tweenLighting({
        ClockTime            = CFG.ClockTime,
        Brightness           = CFG.Brightness,
        ExposureCompensation = CFG.ExposureCompensation,
        Ambient              = CFG.Ambient,
        OutdoorAmbient       = CFG.OutdoorAmbient,
        ColorShift_Top       = CFG.ColorShiftTop,
        ColorShift_Bottom    = CFG.ColorShiftBottom,
        FogEnd               = CFG.FogEnd,
        FogStart             = CFG.FogStart,
        FogColor             = CFG.FogColor,
    }, CFG.FadeTime)

    local rootPos = getRootPos()
    while not rootPos do task.wait(0.1); rootPos = getRootPos() end

    buildSplashPool()
    buildPuddlePool()
    buildPool(rootPos)
    startLoops()

    print("[Rain] 🌧️ Rain started — /rainstop to stop.")
end

local function stopRain()
    if not active then print("[Rain] Not raining.") return end
    active = false

    stopLoops()
    destroyPool()
    destroyPuddlePool()
    destroySplashPool()
    teardownAtmosphere()
    teardownColorCorrection()
    restoreSky()
    stopSound()
    stopChams()

    tweenLighting({
        ClockTime            = origL.ClockTime,
        Brightness           = origL.Brightness,
        ExposureCompensation = origL.ExposureCompensation,
        Ambient              = origL.Ambient,
        OutdoorAmbient       = origL.OutdoorAmbient,
        ColorShift_Top       = origL.ColorShift_Top,
        ColorShift_Bottom    = origL.ColorShift_Bottom,
        FogEnd               = origL.FogEnd,
        FogStart             = origL.FogStart,
        FogColor             = origL.FogColor,
    }, CFG.FadeTime)

    print("[Rain] ☀️ Rain stopped — /rainstart to start.")
end

-- ─── RESPAWN ─────────────────────────────────────────────────────────────────
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    if active then
        stopLoops()
        destroyPool()
        local rootPos = char.HumanoidRootPart.Position
        buildPool(rootPos)
        startLoops()
    end
end)

-- ─── CHAT ────────────────────────────────────────────────────────────────────
player.Chatted:Connect(function(msg)
    local cmd = msg:lower():match("^%s*(.-)%s*$")
    if cmd == "/rainstart" then startRain()
    elseif cmd == "/rainstop" then stopRain()
    end
end)

-- ─── AUTO START ──────────────────────────────────────────────────────────────
task.wait(1.5)
startRain()
print("[Rain] ✅ Loaded — /rainstart | /rainstop")
