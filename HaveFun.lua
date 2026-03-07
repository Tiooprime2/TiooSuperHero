-- ======================================================
-- HAVFUN SCRIPT - Tiooprime2
-- ======================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local pGui = LocalPlayer:WaitForChild("PlayerGui")

if pGui:FindFirstChild("HavFunGui") then
    pGui.HavFunGui:Destroy()
end

_G.ESP_Enabled = false
local ESP_Table = {}
local connections = {}

-- ═══════════════════════════════
-- ESP FUNCTIONS
-- ═══════════════════════════════
local function applyHighlight(char, player)
    if not char then return end
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

local function setupESP(player)
    if player == LocalPlayer then return end
    if player.Character then applyHighlight(player.Character, player) end
    if connections[player] then pcall(function() connections[player]:Disconnect() end) end
    connections[player] = player.CharacterAdded:Connect(function(char)
        if _G.ESP_Enabled then task.wait(0.3); applyHighlight(char, player) end
    end)
end

Players.PlayerRemoving:Connect(function(p) removeHighlight(p) end)

-- ═══════════════════════════════
-- GUI
-- ═══════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "HavFunGui"
gui.ResetOnSpawn = false
gui.Parent = pGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 1
frame.Active = true
frame.Parent = gui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "HavFun - Tiooprime2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -28, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Draggable
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Open button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.Text = "HavFun"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 12
openBtn.BorderSizePixel = 1
openBtn.Visible = false
openBtn.Parent = gui

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

-- ═══════════════════════════════
-- HELPER: TOGGLE
-- ═══════════════════════════════
local rowY = 38
local function makeToggle(labelText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 28)
    row.Position = UDim2.new(0, 8, 0, rowY)
    row.BackgroundTransparency = 1
    row.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 20)
    toggleBtn.Position = UDim2.new(1, -42, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = row

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            toggleBtn.Text = "OFF"
        end
        callback(active)
    end)

    rowY = rowY + 34
end

-- ═══════════════════════════════
-- HELPER: SLIDER
-- ═══════════════════════════════
local function makeSlider(labelText, min, max, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 38)
    row.Position = UDim2.new(0, 8, 0, rowY)
    row.BackgroundTransparency = 1
    row.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Position = UDim2.new(0, 0, 0, 22)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.BorderSizePixel = 0
    track.Parent = row

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local draggingSlider = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local relative = math.clamp((input.Position.X - trackPos) / trackSize, 0, 1)
            local value = math.floor(min + (max - min) * relative)
            fill.Size = UDim2.new(relative, 0, 1, 0)
            lbl.Text = labelText .. ": " .. value
            callback(value)
        end
    end)

    rowY = rowY + 48
end

-- ═══════════════════════════════
-- FITUR
-- ═══════════════════════════════
makeToggle("ESP Tembus Pandang", function(val)
    _G.ESP_Enabled = val
    if val then
        for _, p in pairs(Players:GetPlayers()) do setupESP(p) end
        if not connections["PlayerAdded"] then
            connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
                if _G.ESP_Enabled then task.wait(0.5); setupESP(p) end
            end)
        end
    else
        for _, p in pairs(Players:GetPlayers()) do removeHighlight(p) end
        if connections["PlayerAdded"] then
            pcall(function() connections["PlayerAdded"]:Disconnect() end)
            connections["PlayerAdded"] = nil
        end
    end
end)

makeSlider("Speed", 16, 200, 16, function(val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

frame.Size = UDim2.new(0, 220, 0, rowY + 10)
