-- Configuration for server-side death screen
local CONFIG = {
    network_strings = {
        "deathscreen_sendDeath",
        "deathscreen_removeDeath",
        "deathscreen_requestRespawn"
    },
    respawn_delay = 10, -- Seconds before respawn is allowed
    allow_bypass = function(ply) -- Function to check if player can bypass respawn delay
        return ply:IsSuperAdmin()
    end
}

-- Register network strings
for _, netstr in ipairs(CONFIG.network_strings) do
    util.AddNetworkString(netstr)
end

-- Track player death times
local playerDeathTimes = {}

-- Prevent default respawn behavior
hook.Add("PlayerDeathThink", "DeathScreenNoRespawn", function(ply)
    return false -- Block normal respawn
end)

-- Trigger death screen on player death
hook.Add("PlayerDeath", "DeathScreenHandleDeath", function(victim, inflictor, attacker)
    if not IsValid(victim) then return end

    playerDeathTimes[victim] = CurTime()
    net.Start("deathscreen_sendDeath")
    net.Send(victim)
end)

-- Remove death screen on player spawn
hook.Add("PlayerSpawn", "DeathScreenRemove", function(ply)
    if not IsValid(ply) then return end

    playerDeathTimes[ply] = nil
    net.Start("deathscreen_removeDeath")
    net.Send(ply)
end)

-- Disable default death sound
hook.Add("PlayerDeathSound", "DeathScreenNoSound", function()
    return true -- Suppress default sound
end)

-- Handle client respawn requests
net.Receive("deathscreen_requestRespawn", function(len, ply)
    if not IsValid(ply) or ply:Alive() then return end

    local deathTime = playerDeathTimes[ply]
    if not deathTime then return end

    -- Allow bypass for authorized players or after delay
    if CONFIG.allow_bypass(ply) or (CurTime() - deathTime >= CONFIG.respawn_delay) then
        ply:Spawn()
        playerDeathTimes[ply] = nil
    end
end)
