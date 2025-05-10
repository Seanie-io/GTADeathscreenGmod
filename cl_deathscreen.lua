-- Configuration for GTA-styled death screen with multilingual support
local CONFIG = {
    fonts = {
        title = { name = "gta_title", font = "Pricedown", size = 100, weight = 1000 },
        message = { name = "gta_message", font = "Arial", size = 28, weight = 700 },
        settings = { name = "gta_settings", font = "Arial", size = 24, weight = 600 }
    },
    colors = {
        wasted = Color(200, 0, 0, 255),
        message = Color(220, 220, 220, 255),
        settings = Color(255, 255, 255, 255),
        settings_hover = Color(255, 215, 0, 255)
    },
    timings = {
        respawn_delay = 6,
        fade_duration = 0.8,
        desaturation_rate = 0.12
    },
    effects = {
        fov_multiplier = 0.8,
        brightness = -0.03,
        blur_strength = 3
    },
    languages = {
        { code = "en", name = "English", translations = { wasted = "WASTED", respawn = "Respawn in %d seconds", press = "Press [SPACE] to respawn", settings = "Settings", language = "Language" } },
        { code = "es", name = "Español", translations = { wasted = "LIQUIDADO", respawn = "Reaparecer en %d segundos", press = "Presiona [ESPACIO] para reaparecer", settings = "Configuración", language = "Idioma" } },
        { code = "fr", name = "Français", translations = { wasted = "ÉLIMINÉ", respawn = "Réapparaître dans %d secondes", press = "Appuie sur [ESPACE] pour réapparaître", settings = "Paramètres", language = "Langue" } },
        { code = "da", name = "Dansk", translations = { wasted = "UDSLETTET", respawn = "Genopstå om %d sekunder", press = "Tryk på [MELLUMSLAG] for at genopstå", settings = "Indstillinger", language = "Sprog" } },
        { code = "it", name = "Italiano", translations = { wasted = "ELIMINATO", respawn = "Riapparire tra %d secondi", press = "Premi [SPAZIO] per riapparire", settings = "Impostazioni", language = "Lingua" } },
        { code = "bg", name = "Български", translations = { wasted = "УБИТ", respawn = "Възкръсване след %d секунди", press = "Натисни [ИНТЕРВАЛ] за възкръсване", settings = "Настройки", language = "Език" } },
        { code = "zh", name = "中文", translations = { wasted = "死亡", respawn = "%d秒后重生", press = "按[空格]重生", settings = "设置", language = "语言" } },
        { code = "ar", name = "العربية", translations = { wasted = "قتل", respawn = "إعادة الظهور بعد %d ثانية", press = "اضغط [المسافة] لإعادة الظهور", settings = "الإعدادات", language = "اللغة" } }
    }
}

-- Initialize state
local state = {
    isDead = false,
    deathTime = 0,
    respawnAllowed = false,
    lastSpacePress = 0,
    screenW = ScrW(),
    screenH = ScrH(),
    selectedLanguage = "en",
    settingsOpen = false
}

-- Create fonts
for _, font in pairs(CONFIG.fonts) do
    surface.CreateFont(font.name, {
        font = font.font,
        size = font.size,
        weight = font.weight,
        antialias = true
    })
end

-- Load blur material
local blurMaterial = Material("pp/blurscreen")

-- Check if mouse is within a rectangle
local function IsMouseInBox(x, y, w, h)
    local mx, my = gui.MousePos()
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

-- Get translation for current language
local function GetTranslation(key)
    for _, lang in ipairs(CONFIG.languages) do
        if lang.code == state.selectedLanguage then
            return lang.translations[key] or CONFIG.languages[1].translations[key]
        end
    end
    return CONFIG.languages[1].translations[key]
end

-- Apply screen effects
hook.Add("RenderScreenspaceEffects", "DeathScreenEffects", function()
    if not state.isDead then return end

    local elapsed = CurTime() - state.deathTime
    local colorMod = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = CONFIG.effects.brightness,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = math.Clamp(1 - math.pow(elapsed * CONFIG.timings.desaturation_rate, 0.7), 0, 1),
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    DrawColorModify(colorMod)
    
    -- GTA-style blur
    surface.SetMaterial(blurMaterial)
    surface.SetDrawColor(255, 255, 255)
    for i = 1, 3 do
        blurMaterial:SetFloat("$blur", (i / 3) * CONFIG.effects.blur_strength)
        blurMaterial:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(0, 0, state.screenW, state.screenH)
    end
end)

-- Draw death screen UI
hook.Add("HUDPaint", "DrawDeathScreen", function()
    if not state.isDead then return end

    local elapsed = CurTime() - state.deathTime
    local fadeAlpha = math.Clamp(elapsed / CONFIG.timings.fade_duration, 0, 1) * 255
    local respawnTime = math.max(CONFIG.timings.respawn_delay - elapsed, 0)

    -- GTA-style WASTED text
    draw.SimpleText(
        GetTranslation("wasted"),
        CONFIG.fonts.title.name,
        state.screenW / 2,
        state.screenH / 2 - 50,
        Color(CONFIG.colors.wasted.r, CONFIG.colors.wasted.g, CONFIG.colors.wasted.b, fadeAlpha),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    -- Respawn message
    local message = respawnTime > 0
        and string.format(GetTranslation("respawn"), math.ceil(respawnTime))
        or GetTranslation("press")
    if respawnTime <= 0 then state.respawnAllowed = true end

    draw.SimpleText(
        message,
        CONFIG.fonts.message.name,
        state.screenW / 2,
        state.screenH / 2 + 80,
        Color(CONFIG.colors.message.r, CONFIG.colors.message.g, CONFIG.colors.message.b, fadeAlpha),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    -- Settings cog (visible in bottom-right)
    if not state.settingsOpen then
        draw.SimpleText(
            "⚙",
            CONFIG.fonts.settings.name,
            state.screenW - 60,
            state.screenH - 60,
            IsMouseInBox(state.screenW - 80, state.screenH - 80, 60, 60) and CONFIG.colors.settings_hover or CONFIG.colors.settings,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end
end)

-- Handle settings menu
local settingsPanel
local function OpenSettings()
    if IsValid(settingsPanel) then settingsPanel:Remove() end

    state.settingsOpen = true
    settingsPanel = vgui.Create("EditablePanel")
    settingsPanel:SetSize(state.screenW * 0.3, state.screenH * 0.5)
    settingsPanel:SetPos(state.screenW * 0.7, state.screenH * 0.25)
    settingsPanel:MakePopup()
    settingsPanel.Paint = function(s, w, h)
        -- GTA-style dark panel
        draw.RoundedBox(8, 0, 0, w, h, Color(20, 20, 20, 240))
        draw.SimpleText(GetTranslation("settings"), CONFIG.fonts.message.name, w / 2, 20, CONFIG.colors.message, TEXT_ALIGN_CENTER)
    end

    local closeButton = vgui.Create("DButton", settingsPanel)
    closeButton:SetSize(30, 30)
    closeButton:SetPos(settingsPanel:GetWide() - 40, 10)
    closeButton:SetText("X")
    closeButton:SetFont(CONFIG.fonts.settings.name)
    closeButton:SetTextColor(CONFIG.colors.settings)
    closeButton.DoClick = function()
        settingsPanel:Remove()
        state.settingsOpen = false
    end

    local languageLabel = vgui.Create("DLabel", settingsPanel)
    languageLabel:SetPos(20, 60)
    languageLabel:SetSize(settingsPanel:GetWide() - 40, 30)
    languageLabel:SetFont(CONFIG.fonts.settings.name)
    languageLabel:SetText(GetTranslation("language"))
    languageLabel:SetTextColor(CONFIG.colors.message)

    local languageCombo = vgui.Create("DComboBox", settingsPanel)
    languageCombo:SetPos(20, 100)
    languageCombo:SetSize(settingsPanel:GetWide() - 40, 30)
    languageCombo:SetFont(CONFIG.fonts.settings.name)
    for _, lang in ipairs(CONFIG.languages) do
        languageCombo:AddChoice(lang.name, lang.code)
    end
    languageCombo.OnSelect = function(_, _, _, code)
        state.selectedLanguage = code
    end
    languageCombo:SetValue(CONFIG.languages[1].name)
end

-- Handle input
hook.Add("Think", "DeathScreenInput", function()
    if state.isDead and not state.settingsOpen and input.IsMouseDown(MOUSE_LEFT) then
        if IsMouseInBox(state.screenW - 80, state.screenH - 80, 60, 60) then
            OpenSettings()
            surface.PlaySound("ui/buttonclick.wav")
        end
    end

    if not (state.isDead and state.respawnAllowed and input.IsKeyDown(KEY_SPACE)) then return end

    local currentTime = CurTime()
    if currentTime - state.lastSpacePress < 0.5 then return end

    net.Start("deathscreen_requestRespawn")
    net.SendToServer()
    state.lastSpacePress = currentTime
    state.respawnAllowed = false
end)

-- Adjust camera view
hook.Add("CalcView", "DeathScreenView", function(ply, origin, angles, fov, znear, zfar)
    if not state.isDead then return end

    return {
        origin = origin,
        angles = angles,
        fov = fov * CONFIG.effects.fov_multiplier,
        znear = znear,
        zfar = zfar
    }
end)

-- Update screen dimensions
hook.Add("OnScreenSizeChanged", "DeathScreenUpdateResolution", function()
    state.screenW, state.screenH = ScrW(), ScrH()
end)

-- Handle death notification
net.Receive("deathscreen_sendDeath", function()
    state.isDead = true
    state.deathTime = CurTime()
    state.respawnAllowed = false
    state.settingsOpen = false
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)

-- Handle respawn notification
net.Receive("deathscreen_removeDeath", function()
    state.isDead = false
    state.respawnAllowed = false
    state.settingsOpen = false
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)
