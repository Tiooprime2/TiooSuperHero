-- ======================================================
-- FIX SCRIPT HAVFUN RIDHO (Tiooprime2)
-- ======================================================
local Success, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
end)
if not Success then
    warn("Gagal memuat Orion Library! Cek koneksi atau link.")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.ESP_Enabled = false
local ESP_Table = {}
local connections = {}

-- Fungsi buat highlight
local function applyHighlight(char, player)
    if not char then return end
    -- Hapus dulu kalau ada
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
    ESP_Table[player] = hl
end

-- Fungsi remove highlight
local function removeHighlight(player)
    if ESP_Table[player] then
        pcall(function() ESP_Table[player]:Destroy() end)
        ESP_Table[player] = nil
    end
    if connections[player] then
        pcall(function() connections[player]:Disconnect() end)
        connections[player] = nil
    end
end

-- Fungsi setup ESP per player
local function setupESP(player)
    if player == LocalPlayer then return end

    -- Apply ke karakter yang sudah ada
    if player.Character then
        applyHighlight(player.Character, player)
    end

    -- Connect CharacterAdded biar persist saat respawn
    if connections[player] then
        pcall(function() connections[player]:Disconnect() end)
    end
    connections[player] = player.CharacterAdded:Connect(function(char)
        if _G.ESP_Enabled then
            task.wait(0.3)
            applyHighlight(char, player)
        end
    end)
end

-- ═══════════════════════════════
-- TAB
-- ═══════════════════════════════
local Window = OrionLib:MakeWindow({
    Name = "Tiooprime2 - Have Fun FIX",
    HidePremium = true,
    SaveConfig = false,
    IntroText = "Semangat Lembur, Dho!"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})

-- ═══════════════════════════════
-- ESP TOGGLE
-- ═══════════════════════════════
Tab:AddToggle({
    Name = "ESP Tembus Pandang",
    Default = false,
    Callback = function(Value)
        _G.ESP_Enabled = Value

        if Value then
            -- Setup ESP semua player yang ada
            for _, p in pairs(Players:GetPlayers()) do
                setupESP(p)
            end

            -- Auto setup kalau ada player baru join
            if not connections["PlayerAdded"] then
                connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
                    if _G.ESP_Enabled then
                        task.wait(0.5)
                        setupESP(p)
                    end
                end)
            end
        else
            -- Hapus semua highlight
            for _, p in pairs(Players:GetPlayers()) do
                removeHighlight(p)
            end
            -- Disconnect PlayerAdded
            if connections["PlayerAdded"] then
                pcall(function() connections["PlayerAdded"]:Disconnect() end)
                connections["PlayerAdded"] = nil
            end
        end
    end
})

-- ═══════════════════════════════
-- PLAYER REMOVING CLEANUP
-- ═══════════════════════════════
Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

-- ═══════════════════════════════
-- SPEED SLIDER
-- ═══════════════════════════════
Tab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = v
        end
    end
})

OrionLib:Init()
