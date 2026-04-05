-- ╔══════════════════════════════════════════╗
-- ║         AUTO COLLECT - Standalone        ║
-- ║      Super Hero Tycoon  •  Tioo Dev      ║
-- ╚══════════════════════════════════════════╝

local Players      = game:GetService("Players")
local RepStorage   = game:GetService("ReplicatedStorage")

local player       = Players.LocalPlayer

local ReplicaRemote = RepStorage
    :WaitForChild("ReplicaRemoteEvents")
    :WaitForChild("Replica_ReplicaSignal")

-- ═══════════════════════
-- CONFIG
-- ═══════════════════════
local DELAY = 0.5 -- interval collect (detik)

-- ═══════════════════════
-- LOOP
-- ═══════════════════════
getgenv().AutoCollect = true

print("[Auto Collect] Started!")

task.spawn(function()
    while task.wait(DELAY) do
        if getgenv().AutoCollect then
            local args = {
                154,
                "collectMoney",
                Players:WaitForChild(player.Name)
            }
            pcall(function()
                ReplicaRemote:FireServer(unpack(args))
            end)
        end
    end
end)

print("[Auto Collect] Running... set getgenv().AutoCollect = false to stop.")
