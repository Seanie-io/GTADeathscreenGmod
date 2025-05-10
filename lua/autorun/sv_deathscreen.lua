if not SERVER then return end

-- Configuration for GTA-styled server-side death screen with custom sound upload
local CONFIG = {
    network_strings = {
        "deathscreen_sendDeath",
        "deathscreen_removeDeath",
        "deathscreen_requestRespawn",
        "deathscreen_updateSound",
        "deathscreen_uploadSound"
    },
    respawn_delay = 6,
    allow_bypass = function(ply)
        return ply:IsSuperAdmin() or ply:HasGodMode()
    end,
    sounds = {
        death_options = {
            { name = "Classic GTA", file = "gta/wasted.mp3" },
            { name = "Soft Chime", file = "gta/soft_chime.mp3" },
            { name = "Deep Tone", file = "gta/deep_tone.mp3" },
            { name = "Retro Beep", file = "gta/retro_beep.mp3" }
        },
        default_death = "gta/wasted.mp3",
        custom_upload_path = "gta/custom_sounds/",
        max_file_size = 5242880, -- 5MB limit
        allowed_extensions = { "mp3", "wav" }
    },
    languages = {
        { code = "en", name = "English", translations = { sound = "Death Sound" } },
        { code = "es", name = "Español", translations = { sound = "Sonido de Muerte" } },
        { code = "fr", name = "Français", translations = { sound = "Son de Mort" } },
        { code = "da", name = "Dansk", translations = { sound = "Dødssound" } },
        { code = "it", name = "Italiano", translations = { sound = "Suono di Morte" } },
        { code = "bg", name = "Български", translations = { sound = "Звук на Смърт" } },
        { code = "zh", name = "中文", translations = { sound = "死亡音效" } },
        { code = "ar", name = "العربية", translations = { sound = "صوت الموت" } },
        { code = "de", name = "Deutsch", translations = { sound = "Todessound" } },
        { code = "ru", name = "Русский", translations = { sound = "Звук смерти" } },
        { code = "pt", name = "Português", translations = { sound = "Som de Morte" } },
        { code = "ja", name = "日本語", translations = { sound = "死亡音" } },
        { code = "ko", name = "한국어", translations = { sound = "사망 소리" } },
        { code = "pl", name = "Polski", translations = { sound = "Dźwięk Śmierci" } },
        { code = "tr", name = "Türkçe", translations = { sound = "Ölüm Sesi" } },
        { code = "nl", name = "Nederlands", translations = { sound = "Doodsgeluid" } },
        { code = "sv", name = "Svenska", translations = { sound = "Dödsljud" } },
        { code = "fi", name = "Suomi", translations = { sound = "Kuoleman Ääni" } },
        { code = "cs", name = "Čeština", translations = { sound = "Zvuk Smrti" } },
        { code = "hu", name = "Magyar", translations = { sound = "Halál Hang" } }
    }
}

-- Register network strings
for _, netstr in ipairs(CONFIG.network_strings) do
    util.AddNetworkString(netstr)
end

-- Track player states
local playerData = {}

-- Validate uploaded sound file
local function ValidateSoundFile(fileName, fileSize)
    if fileSize > CONFIG.sounds.max_file_size then return false end
    local ext = string.lower(string.GetExtensionFromFilename(fileName))
    for _, allowed in ipairs(CONFIG.sounds.allowed_extensions) do
        if ext == allowed then return true end
    end
    return false
end

-- Prevent default respawn
hook.Add("PlayerDeathThink", "DeathScreenNoRespawn", function(ply)
    return false
end)

-- Handle player death
hook.Add("PlayerDeath", "DeathScreenHandleDeath", function(victim, inflictor, attacker)
    if not IsValid(victim) then return end

    local selectedSound = playerData[victim] and playerData[victim].selectedSound or CONFIG.sounds.default_death

    playerData[victim] = playerData[victim] or {}
    playerData[victim].deathTime = CurTime()
    playerData[victim].canRespawn = false

    -- Send death notification and play selected sound
    net.Start("deathscreen_sendDeath")
    net.Send(victim)
    victim:EmitSound(selectedSound, 75, 100, 1)
end)

-- Handle player spawn
hook.Add("PlayerSpawn", "DeathScreenRemove", function(ply)
    if not IsValid(ply) then return end

    if playerData[ply] then
        net.Start("deathscreen_removeDeath")
        net.Send(ply)
        playerData[ply] = nil
    end
end)

-- Suppress default death sound
hook.Add("PlayerDeathSound", "DeathScreenNoSound", function()
    return true
end)

-- Handle respawn requests
net.Receive("deathscreen_requestRespawn", function(len, ply)
    if not IsValid(ply) or ply:Alive() then return end

    local data = playerData[ply]
    if not data then return end

    local elapsed = CurTime() - data.deathTime
    if CONFIG.allow_bypass(ply) or elapsed >= CONFIG.respawn_delay then
        ply:Spawn()
        playerData[ply] = nil
    end
end)

-- Update player sound selection
net.Receive("deathscreen_updateSound", function(len, ply)
    local soundFile = net.ReadString()
    for _, sound in ipairs(CONFIG.sounds.death_options) do
        if sound.file == soundFile then
            playerData[ply] = playerData[ply] or {}
            playerData[ply].selectedSound = soundFile
            return
        end
    end
    -- Check if it's a custom sound
    if string.find(soundFile, CONFIG.sounds.custom_upload_path) then
        playerData[ply] = playerData[ply] or {}
        playerData[ply].selectedSound = soundFile
    end
end)

-- Handle custom sound upload
net.Receive("deathscreen_uploadSound", function(len, ply)
    local fileName = net.ReadString()
    local fileData = net.ReadData(len / 8)
    local fileSize = #fileData

    if ValidateSoundFile(fileName, fileSize) then
        local soundPath = CONFIG.sounds.custom_upload_path .. ply:SteamID64() .. "_" .. fileName
        file.Write(soundPath, fileData)
        playerData[ply] = playerData[ply] or {}
        playerData[ply].selectedSound = soundPath
        -- Notify client of successful upload
        net.Start("deathscreen_uploadSound")
        net.WriteBool(true)
        net.WriteString(soundPath)
        net.Send(ply)
    else
        -- Notify client of failed upload
        net.Start("deathscreen_uploadSound")
        net.WriteBool(false)
        net.Send(ply)
    end
end)

-- Cleanup on disconnect
hook.Add("PlayerDisconnected", "DeathScreenCleanup", function(ply)
    playerData[ply] = nil
end)
