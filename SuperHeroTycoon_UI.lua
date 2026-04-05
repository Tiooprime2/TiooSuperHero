-- ╔══════════════════════════════════════════╗
-- ║       SUPER HERO TYCOON - UI Hub         ║
-- ║        by Tioo Dev Team                  ║
-- ╚══════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

if pGui:FindFirstChild("SuperHeroUI") then
    pGui.SuperHeroUI:Destroy()
end

-- ═══════════════════════════════
-- THEME
-- ═══════════════════════════════
local THEME = {
    BG_DARK      = Color3.fromRGB(22, 22, 26),
    BG_PANEL     = Color3.fromRGB(28, 28, 34),
    BG_CARD      = Color3.fromRGB(36, 36, 44),
    BG_HOVER     = Color3.fromRGB(46, 46, 58),
    ACCENT       = Color3.fromRGB(120, 80, 255),
    ACCENT_GLOW  = Color3.fromRGB(80, 60, 200),
    GREEN        = Color3.fromRGB(50, 255, 100),
    RED          = Color3.fromRGB(255, 50, 80),
    TEXT_PRIMARY = Color3.fromRGB(235, 235, 245),
    TEXT_MUTED   = Color3.fromRGB(130, 130, 155),
    BORDER       = Color3.fromRGB(55, 55, 70),
}

-- ═══════════════════════════════
-- UTILITY
-- ═══════════════════════════════
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function gradient(obj, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rotation or 90
    g.Parent = obj
    return g
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            tween(frame, 0.08, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
end

-- ═══════════════════════════════
-- MAIN GUI
-- ═══════════════════════════════
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "SuperHeroUI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = pGui

-- ═══════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
mainFrame.BackgroundColor3 = THEME.BG_DARK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = mainGui
corner(mainFrame, 16)
stroke(mainFrame, THEME.BORDER, 1, 0.2)

-- Top glow line
local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(0.5, 0, 0, 2)
topGlow.Position = UDim2.new(0.25, 0, 0, 0)
topGlow.BackgroundColor3 = THEME.ACCENT
topGlow.BorderSizePixel = 0
topGlow.Parent = mainFrame
corner(topGlow, 2)
gradient(topGlow, THEME.ACCENT, THEME.ACCENT_GLOW, 0)

-- ═══════════════════════════════
-- HEADER
-- ═══════════════════════════════
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = THEME.BG_PANEL
header.BorderSizePixel = 0
header.Parent = mainFrame
corner(header, 16)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.BackgroundColor3 = THEME.BG_PANEL
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Logo box
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.new(0, 36, 0, 36)
logoBox.Position = UDim2.new(0, 14, 0.5, -18)
logoBox.BackgroundColor3 = THEME.ACCENT
logoBox.BorderSizePixel = 0
logoBox.Parent = header
corner(logoBox, 10)
gradient(logoBox, THEME.ACCENT, THEME.ACCENT_GLOW, 135)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "⚡"
logoText.TextSize = 18
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoBox

-- Title
local titleMain = Instance.new("TextLabel")
titleMain.Size = UDim2.new(1, -160, 0, 20)
titleMain.Position = UDim2.new(0, 60, 0, 10)
titleMain.BackgroundTransparency = 1
titleMain.Text = "SUPER HERO TYCOON"
titleMain.TextColor3 = THEME.TEXT_PRIMARY
titleMain.Font = Enum.Font.GothamBold
titleMain.TextSize = 14
titleMain.TextXAlignment = Enum.TextXAlignment.Left
titleMain.Parent = header

local titleSub = Instance.new("TextLabel")
titleSub.Size = UDim2.new(1, -160, 0, 16)
titleSub.Position = UDim2.new(0, 60, 0, 32)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Tioo Hub  •  Pro Edition"
titleSub.TextColor3 = THEME.TEXT_MUTED
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 10
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -42, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
closeBtn.Text = "✕"
closeBtn.TextColor3 = THEME.RED
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header
corner(closeBtn, 8)
stroke(closeBtn, THEME.RED, 1, 0.5)

closeBtn.MouseEnter:Connect(function() tween(closeBtn, 0.15, {BackgroundColor3 = THEME.RED, TextColor3 = Color3.fromRGB(255,255,255)}) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(45,20,25), TextColor3 = THEME.RED}) end)

makeDraggable(mainFrame, header)

-- ═══════════════════════════════
-- CONTENT AREA
-- ═══════════════════════════════
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -24, 1, -76)
contentArea.Position = UDim2.new(0, 12, 0, 68)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = THEME.ACCENT
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.Parent = contentArea

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.Wraps = true
listLayout.Parent = scroll

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

local listPadding = Instance.new("UIPadding")
listPadding.PaddingBottom = UDim.new(0, 10)
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingLeft = UDim.new(0, 2)
listPadding.PaddingRight = UDim.new(0, 2)
listPadding.Parent = scroll

-- ═══════════════════════════════
-- VERSION BADGE
-- ═══════════════════════════════
local verLabel = Instance.new("TextLabel")
verLabel.Size = UDim2.new(1, 0, 0, 16)
verLabel.Position = UDim2.new(0, 0, 1, -18)
verLabel.BackgroundTransparency = 1
verLabel.Text = "TIOO HUB  •  Super Hero Tycoon  •  Build 001"
verLabel.TextColor3 = THEME.TEXT_MUTED
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 9
verLabel.TextXAlignment = Enum.TextXAlignment.Center
verLabel.Parent = mainFrame

-- ═══════════════════════════════
-- TOGGLE CARD FACTORY
-- ═══════════════════════════════
local function makeToggleCard(parent, icon, label, sublabel, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 0, 60)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = layoutOrder
    btn.Parent = parent
    corner(btn, 12)
    stroke(btn, THEME.BORDER, 1, 0.3)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0, 32)
    bar.Position = UDim2.new(0, 0, 0.5, -16)
    bar.BackgroundColor3 = THEME.TEXT_MUTED
    bar.BorderSizePixel = 0
    bar.Parent = btn
    corner(bar, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 28, 0, 28)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -14)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 16
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -90, 0, 16)
    lbl.Position = UDim2.new(0, 46, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = THEME.TEXT_PRIMARY
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -90, 0, 13)
    sub.Position = UDim2.new(0, 46, 0, 28)
    sub.BackgroundTransparency = 1
    sub.Text = sublabel
    sub.TextColor3 = THEME.TEXT_MUTED
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = btn

    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 38, 0, 20)
    badge.Position = UDim2.new(1, -46, 0.5, -10)
    badge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    badge.BorderSizePixel = 0
    badge.Parent = btn
    corner(badge, 10)

    local badgeText = Instance.new("TextLabel")
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = "OFF"
    badgeText.TextColor3 = THEME.RED
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 9
    badgeText.Parent = badge

    return btn, bar, sub, badge, badgeText, lbl
end

-- ═══════════════════════════════
-- REMOTES
-- ═══════════════════════════════
local RepStorage = game:GetService("ReplicatedStorage")

local ReplicaRemote = RepStorage
    :WaitForChild("ReplicaRemoteEvents")
    :WaitForChild("Replica_ReplicaSignal")

local CrateRemote = RepStorage
    :WaitForChild("SharedPackages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.1.0")
    :WaitForChild("net")
    :WaitForChild("RE/claimCrate")

local CRATE_UUID = "28b0df2d-2c55-44c4-bd57-6bf816ac47c7"

-- ═══════════════════════════════
-- LOOPS
-- ═══════════════════════════════
getgenv().AutoCollect  = false
getgenv().CrateCollect = false

-- Loop Auto Collect Money
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoCollect then
            pcall(function()
                ReplicaRemote:FireServer(154, "collectMoney", Players:WaitForChild(player.Name))
            end)
        end
    end
end)

-- Loop Crate Collect
task.spawn(function()
    while task.wait(1) do
        if getgenv().CrateCollect then
            pcall(function()
                CrateRemote:FireServer(CRATE_UUID)
            end)
        end
    end
end)

-- ═══════════════════════════════
-- TOGGLE HELPER
-- ═══════════════════════════════
local function applyToggleOn(btn, bar, badge, badgeText, sub, msg)
    tween(btn,   0.2, {BackgroundColor3 = Color3.fromRGB(12, 38, 18)})
    tween(bar,   0.2, {BackgroundColor3 = THEME.GREEN})
    tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 50, 25)})
    badgeText.Text      = "ON"
    badgeText.TextColor3 = THEME.GREEN
    sub.Text            = msg
    sub.TextColor3      = THEME.GREEN
    stroke(btn, THEME.GREEN, 1, 0.4)
end

local function applyToggleOff(btn, bar, badge, badgeText, sub)
    tween(btn,   0.2, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)})
    tween(bar,   0.2, {BackgroundColor3 = THEME.TEXT_MUTED})
    tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)})
    badgeText.Text      = "OFF"
    badgeText.TextColor3 = THEME.RED
    sub.Text            = "Tap to enable"
    sub.TextColor3      = THEME.TEXT_MUTED
    stroke(btn, THEME.BORDER, 1, 0.3)
end

-- ═══════════════════════════════
-- CARD: AUTO COLLECT MONEY
-- ═══════════════════════════════
local autoCollectActive = false
local collectBtn, collectBar, collectSub, collectBadge, collectBadgeText =
    makeToggleCard(scroll, "💰", "Auto Collect", "Tap to enable", 1)

collectBtn.MouseEnter:Connect(function()
    if not autoCollectActive then tween(collectBtn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}) end
end)
collectBtn.MouseLeave:Connect(function()
    if not autoCollectActive then tween(collectBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}) end
end)
collectBtn.MouseButton1Click:Connect(function()
    autoCollectActive = not autoCollectActive
    getgenv().AutoCollect = autoCollectActive
    if autoCollectActive then
        applyToggleOn(collectBtn, collectBar, collectBadge, collectBadgeText, collectSub, "Collecting money...")
    else
        applyToggleOff(collectBtn, collectBar, collectBadge, collectBadgeText, collectSub)
    end
end)

-- ═══════════════════════════════
-- CARD: CRATE COLLECT
-- ═══════════════════════════════
local crateActive = false
local crateBtn, crateBar, crateSub, crateBadge, crateBadgeText =
    makeToggleCard(scroll, "📦", "Crate Collect", "Tap to enable", 2)

crateBtn.MouseEnter:Connect(function()
    if not crateActive then tween(crateBtn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}) end
end)
crateBtn.MouseLeave:Connect(function()
    if not crateActive then tween(crateBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}) end
end)
crateBtn.MouseButton1Click:Connect(function()
    crateActive = not crateActive
    getgenv().CrateCollect = crateActive
    if crateActive then
        applyToggleOn(crateBtn, crateBar, crateBadge, crateBadgeText, crateSub, "Claiming crates...")
    else
        applyToggleOff(crateBtn, crateBar, crateBadge, crateBadgeText, crateSub)
    end
end)

-- ═══════════════════════════════
-- OPEN BUTTON
-- ═══════════════════════════════
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 52, 0, 52)
openBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
openBtn.BackgroundColor3 = THEME.BG_DARK
openBtn.Text = "⚡"
openBtn.TextSize = 22
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.BorderSizePixel = 0
openBtn.Parent = mainGui
corner(openBtn, 14)
stroke(openBtn, THEME.ACCENT, 1.5, 0.3)
makeDraggable(openBtn)

openBtn.MouseEnter:Connect(function() tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD}) end)
openBtn.MouseLeave:Connect(function() tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_DARK}) end)

closeBtn.MouseButton1Click:Connect(function()
    tween(mainFrame, 0.2, {Size = UDim2.new(0, 500, 0, 0)})
    task.delay(0.2, function() mainFrame.Visible = false; openBtn.Visible = true end)
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 500, 0, 0)
    tween(mainFrame, 0.25, {Size = UDim2.new(0, 500, 0, 320)})
    openBtn.Visible = false
end)

-- Animasi muncul pertama kali
mainFrame.Size = UDim2.new(0, 500, 0, 0)
tween(mainFrame, 0.3, {Size = UDim2.new(0, 500, 0, 320)})
