-- Configuration for GTA-styled death screen with expanded multilingual support and customizable death sound
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
        settings_hover = Color(255, 215, 0, 255),
        background = Color(20, 20, 20, 240)
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
    sounds = {
        death_options = {
            { name = "Classic GTA", file = "gta_death.wav" },
            { name = "Soft Chime", file = "soft_chime.wav" },
            { name = "Deep Tone", file = "deep_tone.wav" },
            { name = "Retro Beep", file = "retro_beep.wav" }
        },
        default_death = "gta_death.wav"
    },
    languages = {
        { code = "en", name = "English", translations = { wasted = "WASTED", respawn = "Respawn in %d seconds", press = "Press [SPACE] to respawn", settings = "Settings", language = "Language", close = "Close", sound = "Death Sound" } },
        { code = "es", name = "Español", translations = { wasted = "LIQUIDADO", respawn = "Reaparecer en %d segundos", press = "Presiona [ESPACIO] para reaparecer", settings = "Configuración", language = "Idioma", close = "Cerrar", sound = "Sonido de Muerte" } },
        { code = "fr", name = "Français", translations = { wasted = "ÉLIMINÉ", respawn = "Réapparaître dans %d secondes", press = "Appuie sur [ESPACE] pour réapparaître", settings = "Paramètres", language = "Langue", close = "Fermer", sound = "Son de Mort" } },
        { code = "da", name = "Dansk", translations = { wasted = "UDSLETTET", respawn = "Genopstå om %d sekunder", press = "Tryk på [MELLUMSLAG] for at genopstå", settings = "Indstillinger", language = "Sprog", close = "Luk", sound = "Dødssound" } },
        { code = "it", name = "Italiano", translations = { wasted = "ELIMINATO", respawn = "Riapparire tra %d secondi", press = "Premi [SPAZIO] per riapparire", settings = "Impostazioni", language = "Lingua", close = "Chiudi", sound = "Suono di Morte" } },
        { code = "bg", name = "Български", translations = { wasted = "УБИТ", respawn = "Възкръсване след %d секунди", press = "Натисни [ИНТЕРВАЛ] за възкръсване", settings = "Настройки", language = "Език", close = "Затвори", sound = "Звук на Смърт" } },
        { code = "zh", name = "中文", translations = { wasted = "死亡", respawn = "%d秒后重生", press = "按[空格]重生", settings = "设置", language = "语言", close = "关闭", sound = "死亡音效" } },
        { code = "ar", name = "العربية", translations = { wasted = "قتل", respawn = "إعادة الظهور بعد %d ثانية", press = "اضغط [المسافة] لإعادة الظهور", settings = "الإعدادات", language = "اللغة", close = "إغلاق", sound = "صوت الموت" } },
        { code = "de", name = "Deutsch", translations = { wasted = "ERLEDIGT", respawn = "In %d Sekunden wiederbeleben", press = "Drücke [LEERTASTE] zum Wiederbeleben", settings = "Einstellungen", language = "Sprache", close = "Schließen", sound = "Todessound" } },
        { code = "ru", name = "Русский", translations = { wasted = "УБИТ", respawn = "Возрождение через %d секунд", press = "Нажми [ПРОБЕЛ] для возрождения", settings = "Настройки", language = "Язык", close = "Закрыть", sound = "Звук смерти" } },
        { code = "pt", name = "Português", translations = { wasted = "ELIMINADO", respawn = "Ressurgir em %d segundos", press = "Pressione [ESPAÇO] para ressurgir", settings = "Configurações", language = "Idioma", close = "Fechar", sound = "Som de Morte" } },
        { code = "ja", name = "日本語", translations = { wasted = "死亡", respawn = "%d秒後にリスポーン", press = "[スペース]を押してリスポーン", settings = "設定", language = "言語", close = "閉じる", sound = "死亡音" } },
        { code = "ko", name = "한국어", translations = { wasted = "사망", respawn = "%d초 후 부활", press = "[스페이스]를 눌러 부활", settings = "설정", language = "언어", close = "닫기", sound = "사망 소리" } },
        { code = "pl", name = "Polski", translations = { wasted = "ZABITY", respawn = "Odrodzenie za %d sekund", press = "Naciśnij [SPACJA] aby odrodzić", settings = "Ustawienia", language = "Język", close = "Zamknij", sound = "Dźwięk Śmierci" } },
        { code = "tr", name = "Türkçe", translations = { wasted = "ÖLDÜRÜLDÜ", respawn = "%d saniye içinde yeniden doğ", press = "Yeniden doğmak için [BOŞLUK] tuşuna bas", settings = "Ayarlar", language = "Dil", close = "Kapat", sound = "Ölüm Sesi" } },
        { code = "nl", name = "Nederlands", translations = { wasted = "VERNIETIGD", respawn = "Herleven in %d seconden", press = "Druk op [SPATIE] om te herleven", settings = "Instellingen", language = "Taal", close = "Sluiten", sound = "Doodsgeluid" } },
        { code = "sv", name = "Svenska", translations = { wasted = "UTSLAGEN", respawn = "Återuppstå om %d sekunder", press = "Tryck på [MELLANSLAG] för att återuppstå", settings = "Inställningar", language = "Språk", close = "Stäng", sound = "Dödsljud" } },
        { code = "fi", name = "Suomi", translations = { wasted = "KUOLLUT", respawn = "Uudelleensyntyminen %d sekunnin kuluttua", press = "Paina [VÄLILYÖNTI] uudelleensyntyäksesi", settings = "Asetukset", language = "Kieli", close = "Sulje", sound = "Kuoleman Ääni" } },
        { code = "cs", name = "Čeština", translations = { wasted = "ZABIT", respawn = "Obnovení za %d sekund", press = "Stiskni [MEZERNÍK] pro obnovení", settings = "Nastavení", language = "Jazyk", close = "Zavřít", sound = "Zvuk Smrti" } },
        { code = "hu", name = "Magyar", translations = { wasted = "MEGÖLVE", respawn = "Újraéledés %d másodperc múlva", press = "Nyomd meg a [SZÓKÖZ] gombot az újraéledéshez", settings = "Beállítások", language = "Nyelv", close = "Bezárás", sound = "Halál Hang" } }
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
    selectedSound = CONFIG.sounds.default_death,
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

-- Utility function to check if mouse is within a rectangle
local function IsMouseInBox(x, y, w, h)
    local mx, my = gui.MousePos()
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

-- Get translation for current language, fallback to English
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
    
    -- Apply GTA-style blur
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

    -- Draw GTA-style WASTED text
    draw.SimpleText(
        GetTranslation("wasted"),
        CONFIG.fonts.title.name,
        state.screenW / 2,
        state.screenH / 2 - 50,
        Color(CONFIG.colors.wasted.r, CONFIG.colors.wasted.g, CONFIG.colors.wasted.b, fadeAlpha),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    -- Draw respawn message
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

    -- Draw settings cog (visible in bottom-right)
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
        draw.RoundedBox(8, 0, 0, w, h, CONFIG.colors.background)
        draw.SimpleText(GetTranslation("settings"), CONFIG.fonts.message.name, w / 2, 20, CONFIG.colors.message, TEXT_ALIGN_CENTER)
    end

    local closeButton = vgui.Create("DButton", settingsPanel)
    closeButton:SetSize(30, 30)
    closeButton:SetPos(settingsPanel:GetWide() - 40, 10)
    closeButton:SetText(GetTranslation("close"))
    closeButton:SetFont(CONFIG.fonts.settings.name)
    closeButton:SetTextColor(CONFIG.colors.settings)
    closeButton.DoClick = function()
        settingsPanel:Remove()
        state.settingsOpen = false
        surface.PlaySound("ui/buttonclickrelease.wav")
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
        surface.PlaySound("ui/buttonclick.wav")
    end
    for _, lang in ipairs(CONFIG.languages) do
        if lang.code == state.selectedLanguage then
            languageCombo:SetValue(lang.name)
            break
        end
    end

    local soundLabel = vgui.Create("DLabel", settingsPanel)
    soundLabel:SetPos(20, 140)
    soundLabel:SetSize(settingsPanel:GetWide() - 40, 30)
    soundLabel:SetFont(CONFIG.fonts.settings.name)
    soundLabel:SetText(GetTranslation("sound"))
    soundLabel:SetTextColor(CONFIG.colors.message)

    local soundCombo = vgui.Create("DComboBox", settingsPanel)
    soundCombo:SetPos(20, 180)
    soundCombo:SetSize(settingsPanel:GetWide() - 40, 30)
    soundCombo:SetFont(CONFIG.fonts.settings.name)
    for _, sound in ipairs(CONFIG.sounds.death_options) do
        soundCombo:AddChoice(sound.name, sound.file)
    end
    soundCombo.OnSelect = function(_, _, _, file)
        state.selectedSound = file
        surface.PlaySound(file)
    end
    for _, sound in ipairs(CONFIG.sounds.death_options) do
        if sound.file == state.selectedSound then
            soundCombo:SetValue(sound.name)
            break
        end
    end
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
    surface.PlaySound("ui/buttonclickrelease.wav")
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
    surface.PlaySound(state.selectedSound)
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)

-- Handle respawn notification
net.Receive("deathscreen_removeDeath", function()
    state.isDead = false
    state.respawnAllowed = false
    state.settingsOpen = false
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)
