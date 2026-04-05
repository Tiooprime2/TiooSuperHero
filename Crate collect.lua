-- ╔══════════════════════════════════════════╗
-- ║         CRATE COLLECT - Standalone       ║
-- ║      Super Hero Tycoon  •  Tioo Dev      ║
-- ╚══════════════════════════════════════════╝

local RepStorage = game:GetService("ReplicatedStorage")

local CrateRemote = RepStorage
    :WaitForChild("SharedPackages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.1.0")
    :WaitForChild("net")
    :WaitForChild("RE/claimCrate")

-- ═══════════════════════
-- CONFIG
-- ═══════════════════════
local DELAY       = 1    -- interval claim crate (detik)
local CRATE_UUID  = "28b0df2d-2c55-44c4-bd57-6bf816ac47c7"

-- ═══════════════════════
-- LOOP
-- ═══════════════════════
getgenv().CrateCollect = true

print("[Crate Collect] Started!")

task.spawn(function()
    while task.wait(DELAY) do
        if getgenv().CrateCollect then
            pcall(function()
                CrateRemote:FireServer(CRATE_UUID)
            end)
        end
    end
end)

print("[Crate Collect] Running... set getgenv().CrateCollect = false to stop.")
