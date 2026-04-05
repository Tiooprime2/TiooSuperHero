-- ╔══════════════════════════════════════════╗
-- ║         TIOO HUB - Main Loader           ║
-- ║      Super Hero Tycoon  •  Tioo Dev      ║
-- ╚══════════════════════════════════════════╝

local REPO   = "Tiooprime2/TiooSuperHero"
local BRANCH = "main"

local BASE_URL = "https://raw.githubusercontent.com/" .. REPO .. "/" .. BRANCH .. "/"

local FILES = {
    "SuperHeroTycoon_UI.lua",
}

local function loadScript(fileName)
    local url = BASE_URL .. fileName
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        warn("[TiooHub] Gagal fetch: " .. fileName .. " | " .. tostring(result))
        return
    end

    local fn, err = loadstring(result)
    if not fn then
        warn("[TiooHub] Gagal loadstring: " .. fileName .. " | " .. tostring(err))
        return
    end

    local runOk, runErr = pcall(fn)
    if not runOk then
        warn("[TiooHub] Gagal run: " .. fileName .. " | " .. tostring(runErr))
        return
    end

    print("[TiooHub] Loaded: " .. fileName)
end

-- Load semua file
for _, file in ipairs(FILES) do
    loadScript(file)
end
