-- ======================================================
-- SCRIPT HAVFUN MINOR BUAT RIDHO (Natural Disaster Survival)
-- ======================================================

-- 1. LOAD UI LIBRARY (Pakai Orion biar gampang)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. BUAT WINDOW UTAMA
local Window = OrionLib:MakeWindow({
    Name = "Tiooprime2 - Have Fun", -- Nama UI nya
    HidePremium = true, 
    SaveConfig = true, 
    ConfigFolder = "OrionTest",
    IntroText = "Halo Ridho!" -- Teks pas loading
})

-- 3. VARIABEL & FUNGSI ESP (GLOBAL BIAR GAMPANG DIATUR)
_G.ESP_Enabled = false
local ESP_Objects = {} -- Buat nyimpen kotak ESP biar bisa dihapus

local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end -- Jangan kasih ESP ke diri sendiri

    local function ApplyESP(v)
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
            -- Bikin kotak (Highlight)
            local Highlight = Instance.new("Highlight")
            Highlight.Name = player.Name .. "_ESP"
            Highlight.Adornee = v
            Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Warna merah terang
            Highlight.FillTransparency = 0.5 -- Transparansi kotak
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Warna garis pinggir putih
            Highlight.OutlineTransparency = 0
            Highlight.Parent = game.CoreGui -- Taruh di CoreGui biar tembus pandang

            table.insert(ESP_Objects, Highlight) -- Simpan di tabel
        end
    end
    
    -- Terapkan kalau karakter sudah load
    if player.Character then ApplyESP(player.Character) end
    player.CharacterAdded:Connect(ApplyESP)
end

-- Fungsi Hapus ESP
local function ClearESP()
    for _, obj in pairs(ESP_Objects) do
        obj:Destroy()
    end
    table.clear(ESP_Objects)
end

-- 4. BUAT TAB & TOMBOL DI UI
local FunTab = Window:MakeTab({
    Name = "Main Fun",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- == TOMBOL ESP (TEMBUS PANDANG) ==
FunTab:AddToggle({
    Name = "Tembus Pandang Player (ESP)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Enabled = Value
        if _G.ESP_Enabled then
            -- Aktifkan ESP
            for _, player in pairs(game.Players:GetPlayers()) do
                CreateESP(player)
            end
            -- Deteksi kalau ada player baru join
            game.Players.PlayerAdded:Connect(CreateESP)
        else
            -- Matikan ESP
            ClearESP()
        end
    end    
})

-- == TOMBOL LARI CEPAT (SPEED) ==
FunTab:AddSlider({
    Name = "Lari Cepat (Speed)",
    Min = 16, -- Kecepatan normal Roblox
    Max = 150, -- Super cepat
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- == TOMBOL LOMPAT TINGGI (JUMP) ==
FunTab:AddSlider({
    Name = "Lompat Tinggi (Power)",
    Min = 50, -- Lompatan normal Roblox
    Max = 300, -- Sangat tinggi
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- 5. NOTIFIKASI SUKSES
OrionLib:MakeNotification({
    Name = "Sukses!",
    Content = "Script Tiooprime2 udah jalan, Dho. Met iseng!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Init UI
OrionLib:Init()
