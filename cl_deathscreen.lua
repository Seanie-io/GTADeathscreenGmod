-- Configuration for death screen
local CONFIG = {
    fonts = {
        title = {
            name = "tutorial_90",
            font = "Roboto",
            size = 90,
            weight = 1000
        },
        message = {
            name = "tutorial_24",
            font = "Roboto",
            size = 24,
            weight = 800
        }
    },
    colors = {
        wasted = Color(255, 0, 0, 255),
        message = Color(255, 255, 255, 255)
    },
    timings = {
        respawn_delay = 5, -- Seconds before respawn is allowed
        fade_duration = 1, -- Seconds for WASTED text fade-in
        desaturation_rate = 0.15 -- Rate of color desaturation
    },
    effects = {
        fov_multiplier = 0.85, -- Narrower FOV during death
        brightness = -0.02, -- Slight darkening
        blur_strength = 2 -- Blur effect intensity
    }
}

-- Create fonts
surface.CreateFont(CONFIG.fonts.title.name, {
    font = CONFIG.fonts.title.font,
    size = CONFIG.fonts.title.size,
    weight = CONFIG.fonts.title.weight
})

surface.CreateFont(CONFIG.fonts.message.name, {
    font = CONFIG.fonts.message.font,
    size = CONFIG.fonts.message.size,
    weight = CONFIG.fonts.message.weight
})

-- State variables
local isDead = false
local deathTime = 0
local respawnAllowed = false
local lastSpacePress = 0
local screenW, screenH = ScrW(), ScrH()

-- Handle death notification
net.Receive("deathscreen_sendDeath", function()
    isDead = true
    deathTime = CurTime()
    respawnAllowed = false
end)

-- Handle respawn notification
net.Receive("deathscreen_removeDeath", function()
    isDead = false
    respawnAllowed = false
end)

-- Apply screen effects (color and blur)
hook.Add("RenderScreenspaceEffects", "DeathScreenEffects", function()
    if not isDead then return end

    local elapsed = CurTime() - deathTime
    local colorMod = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = CONFIG.effects.brightness,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = math.Clamp(1 - math.pow(elapsed * CONFIG.timings.desaturation_rate, 0.8), 0, 1),
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    DrawColorModify(colorMod)
    DrawMotionBlur(0.4, CONFIG.effects.blur_strength * (elapsed / CONFIG.timings.respawn_delay), 0.01)
end)

-- Draw death screen UI
hook.Add("HUDPaint", "DrawDeathScreen", function()
    if not isDead then return end

    local elapsed = CurTime() - deathTime
    local fadeAlpha = math.Clamp(elapsed / CONFIG.timings.fade_duration, 0, 1) * 255
    local respawnTime = math.max(CONFIG.timings.respawn_delay - elapsed, 0)

    -- Draw WASTED text with fade-in
    draw.SimpleText(
        "WASTED",
        CONFIG.fonts.title.name,
        screenW / 2,
        screenH / 2,
        Color(CONFIG.colors.wasted.r, CONFIG.colors.wasted.g, CONFIG.colors.wasted.b, fadeAlpha),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    -- Draw respawn message
    local message = respawnTime > 0
        and "Respawn in " .. math.ceil(respawnTime) .. " seconds"
        or "Press [SPACE] to respawn"
    if respawnTime <= 0 then respawnAllowed = true end

    draw.SimpleText(
        message,
        CONFIG.fonts.message.name,
        screenW / 2,
        screenH / 2 + 100,
        Color(CONFIG.colors.message.r, CONFIG.colors.message.g, CONFIG.colors.message.b, fadeAlpha),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end)

-- Handle respawn input
hook.Add("Think", "DeathScreenRespawn", function()
    if not (isDead and respawnAllowed and input.IsKeyDown(KEY_SPACE)) then return end

    local currentTime = CurTime()
    if currentTime - lastSpacePress < 0.5 then return end -- Debounce input

    net.Start("deathscreen_requestRespawn")
    net.SendToServer()
    lastSpacePress = currentTime
    respawnAllowed = false
end)

-- Adjust camera view
hook.Add("CalcView", "DeathScreenView", function(ply, origin, angles, fov, znear, zfar)
    if not isDead then return end

    return {
        origin = origin,
        angles = angles,
        fov = fov * CONFIG.effects.fov_multiplier,
        znear = znear,
        zfar = zfar
    }
end)

-- Update screen dimensions on resolution change
hook.Add("OnScreenSizeChanged", "DeathScreenUpdateResolution", function()
    screenW, screenH = ScrW(), ScrH()
end)
