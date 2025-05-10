-- Configuration for GTA-styled server-side death screen
local CONFIG = {
    network_strings = {
        "deathscreen_sendDeath",
        "deathscreen_removeDeath",
        "deathscreen_requestRespawn"
    },
    respawn_delay = 6, -- Matches client-side
    allow_bypass = function(ply)
        return ply:IsSuperAdmin() or ply:HasGodMode()
    end,
    sound = "gta/wasted.mp3"
}

-- Register network strings
for _, netstr in ipairs(CONFIG.network_strings) do
    util.AddNetworkString(netstr)
end

-- Track player states
local playerData = {}

-- Prevent default respawn
hook.Add("PlayerDeathThink", "DeathScreenNoRespawn", function(ply)
    return false
end)

-- Handle player death
hook.Add("PlayerDeath", "DeathScreenHandleDeath", function(victim, inflictor, attacker)
    if not IsValid(victim) then return end

    playerData[victim] = {
        deathTime = CurTime(),
        canRespawn = false
    }

    -- Send death notification and play GTA sound
    net.Start("deathscreen_sendDeath")
    net.Send(victim)
    victim:EmitSound(CONFIG.sound, 75, 100, 1)
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

-- Cleanup on disconnect
hook.Add("PlayerDisconnected", "DeathScreenCleanup", function(ply)
    playerData[ply] = nil
end)
