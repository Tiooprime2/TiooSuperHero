-- ======================================================
-- Tiooprime2 - ULTRA FIX (ESP + HITBOX + AUTO RUN)
-- ======================================================

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "Tiooprime2 - God Mode",
    HidePremium = true,
    SaveConfig = false,
    IntroText = "Semangat Lembur, Dho!"
})

-- ═══════════════════════════════
-- VARIABEL GLOBAL
-- ═══════════════════════════════
_G.ESP_Enabled = false
_G.Hitbox_Enabled = false
_G.Hitbox_Size = 2
_G.Hitbox_Transparency = 0.5
_G.AutoRun_Enabled = false  -- NEW: Auto Run toggle

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")  -- NEW: For input simulation
local RunService = game:GetService("RunService")  -- NEW: For loop

-- Connections per player biar bisa di-disconnect
local espConnections = {}
local autoRunConnection = nil  -- NEW: Store the connection

-- ═══════════════════════════════
-- FUNGSI CEK MUSUH
-- ═══════════════════════════════
local function isEnemy(player)
    if player == LocalPlayer then return false end
    -- Cek team kalau ada, kalau gak ada team anggap semua musuh
    local ok, result = pcall(function()
        return player.Team ~= LocalPlayer.Team
    end)
    if ok then return result else return true end
end

-- ═══════════════════════════════
-- ESP FUNCTIONS
-- ═══════════════════════════════
local function applyESP(char)
    if not char then return end
    task.wait(0.3)
    if char:FindFirstChild("Highlight_ESP") then
        char.Highlight_ESP:Destroy()
    end
    local hl = Instance.new("Highlight")
    hl.Name = "Highlight_ESP"
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0
    hl.Parent = char
end

local function removeESP(player)
    -- Hapus highlight dari karakter
    if player.Character and player.Character:FindFirstChild("Highlight_ESP") then
        player.Character.Highlight_ESP:Destroy()
    end
    -- Disconnect CharacterAdded connection
    if espConnections[player] then
        pcall(function() espConnections[player]:Disconnect() end)
        espConnections[player] = nil
    end
end

local function setupESP(player)
    if not isEnemy(player) then return end

    -- Apply ke karakter yang sudah ada
    if player.Character then
        applyESP(player.Character)
    end

    -- Disconnect lama kalau ada
    if espConnections[player] then
        pcall(function() espConnections[player]:Disconnect() end)
    end

    -- Connect CharacterAdded — ini yang bikin ESP tetap ada saat respawn!
    espConnections[player] = player.CharacterAdded:Connect(function(char)
        if _G.ESP_Enabled then
            applyESP(char)
        end
    end)
end

-- Auto setup player baru yang join
Players.PlayerAdded:Connect(function(p)
    if _G.ESP_Enabled then
        task.wait(0.5)
        setupESP(p)
    end
end)

-- Cleanup saat player keluar
Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

-- ═══════════════════════════════
-- HITBOX LOOP
-- ═══════════════════════════════
task.spawn(function()
    while task.wait(0.5) do
        if _G.Hitbox_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if isEnemy(p) and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(_G.Hitbox_Size, _G.Hitbox_Size, _G.Hitbox_Size)
                        hrp.Transparency = _G.Hitbox_Transparency
                        hrp.BrickColor = BrickColor.new("Really red")
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════
-- AUTO RUN FUNCTION (FIXED)
-- ═══════════════════════════════
local function startAutoRun()
    if autoRunConnection then return end  -- Prevent multiple connections
    
    autoRunConnection = RunService.RenderStepped:Connect(function()
        if not _G.AutoRun_Enabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Method 1: Direct humanoid movement (works in most games)
        humanoid.WalkSpeed = math.max(humanoid.WalkSpeed, 16)  -- Ensure normal speed
        
        -- Method 2: Simulate W key press for Entrenched compatibility
        -- This is the key fix - many WW1 games use custom movement systems
        local camera = workspace.CurrentCamera
        if camera then
            -- Move forward relative to camera direction
            local moveDirection = camera.CFrame.LookVector
            moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
            humanoid:Move(moveDirection, true)
        end
    end)
end

local function stopAutoRun()
    if autoRunConnection then
        autoRunConnection:Disconnect()
        autoRunConnection = nil
    end
    
    -- Stop movement
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:Move(Vector3.zero, true)
        end
    end
end

-- ═══════════════════════════════
-- UI TAB
-- ═══════════════════════════════
local CombatTab = Window:MakeTab({
    Name = "Combat & ESP",
    Icon = "rbxassetid://4483345998"
})

-- Section ESP
CombatTab:AddSection({
    Name = "ESP"
})

CombatTab:AddToggle({
    Name = "ESP Musuh (Persist Respawn)",
    Default = false,
    Callback = function(val)
        _G.ESP_Enabled = val
        if val then
            for _, p in pairs(Players:GetPlayers()) do
                setupESP(p)
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                removeESP(p)
            end
        end
    end
})

-- Section Hitbox
CombatTab:AddSection({
    Name = "Hitbox"
})

CombatTab:AddToggle({
    Name = "Hitbox Enable",
    Default = false,
    Callback = function(val)
        _G.Hitbox_Enabled = val
        -- Reset ukuran HRP kalau dimatikan
        if not val then
            for _, p in pairs(Players:GetPlayers()) do
                if isEnemy(p) and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
})

CombatTab:AddSlider({
    Name = "Hitbox Size",
    Min = 2,
    Max = 20,
    Default = 2,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "studs",
    Callback = function(val)
        _G.Hitbox_Size = val
    end
})

CombatTab:AddSlider({
    Name = "Hitbox Transparency",
    Min = 0,
    Max = 10,
    Default = 5,
    Increment = 1,
    ValueName = "level",
    Callback = function(val)
        _G.Hitbox_Transparency = val / 10
    end
})

-- ═══════════════════════════════
-- NEW: AUTO RUN SECTION
-- ═══════════════════════════════
CombatTab:AddSection({
    Name = "Movement"
})

CombatTab:AddToggle({
    Name = "Auto Run (Auto Sprint Forward)",
    Default = false,
    Callback = function(val)
        _G.AutoRun_Enabled = val
        if val then
            startAutoRun()
        else
            stopAutoRun()
        end
    end
})

-- Handle respawn - restart auto run if enabled
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)  -- Wait for character to fully load
    if _G.AutoRun_Enabled then
        startAutoRun()
    end
end)

OrionLib:Init()
