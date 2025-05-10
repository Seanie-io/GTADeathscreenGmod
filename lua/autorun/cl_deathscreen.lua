if not CLIENT then return end

CreateClientConVar("seanie_deathscreen_language", "default", true, false)

-- Configuration for GTA-styled death screen with expanded multilingual support and custom death sound upload
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
        { code = "en", name = "English", translations = { wasted = "WASTED", respawn = "Respawn in %d seconds", press = "Press [SPACE] to respawn", settings = "Settings", language = "Language", close = "Close", sound = "Death Sound", upload = "Upload Custom Sound", upload_error = "Invalid file! Use MP3/WAV, max 5MB." } },
        { code = "es", name = "Español", translations = { wasted = "LIQUIDADO", respawn = "Reaparecer en %d segundos", press = "Presiona [ESPACIO] para reaparecer", settings = "Configuración", language = "Idioma", close = "Cerrar", sound = "Sonido de Muerte", upload = "Subir Sonido Personalizado", upload_error = "¡Archivo inválido! Usa MP3/WAV, máximo 5MB." } },
        { code = "fr", name = "Français", translations = { wasted = "ÉLIMINÉ", respawn = "Réapparaître dans %d secondes", press = "Appuie sur [ESPACE] pour réapparaître", settings = "Paramètres", language = "Langue", close = "Fermer", sound = "Son de Mort", upload = "Télécharger Son Personnalisé", upload_error = "Fichier invalide ! Utilisez MP3/WAV, max 5MB." } },
        { code = "da", name = "Dansk", translations = { wasted = "UDSLETTET", respawn = "Genopstå om %d sekunder", press = "Tryk på [MELLUMSLAG] for at genopstå", settings = "Indstillinger", language = "Sprog", close = "Luk", sound = "Dødssound", upload = "Upload Brugerdefineret Lyd", upload_error = "Ugyldig fil! Brug MP3/WAV, max 5MB." } },
        { code = "it", name = "Italiano", translations = { wasted = "ELIMINATO", respawn = "Riapparire tra %d secondi", press = "Premi [SPAZIO] per riapparire", settings = "Impostazioni", language = "Lingua", close = "Chiudi", sound = "Suono di Morte", upload = "Carica Suono Personalizzato", upload_error = "File non valido! Usa MP3/WAV, max 5MB." } },
        { code = "bg", name = "Български", translations = { wasted = "УБИТ", respawn = "Възкръсване след %d секунди", press = "Натисни [ИНТЕРВАЛ] за възкръсване", settings = "Настройки", language = "Език", close = "Затвори", sound = "Звук на Смърт", upload = "Качи Персонализиран Звук", upload_error = "Невалиден файл! Използвай MP3/WAV, макс. 5MB." } },
        { code = "zh", name = "中文", translations = { wasted = "死亡", respawn = "%d秒后重生", press = "按[空格]重生", settings = "设置", language = "语言", close = "关闭", sound = "死亡音效", upload = "上传自定义音效", upload_error = "无效文件！使用MP3/WAV，最大5MB。" } },
        { code = "ar", name = "العربية", translations = { wasted = "قتل", respawn = "إعادة الظهور بعد %d ثانية", press = "اضغط [المسافة] لإعادة الظهور", settings = "الإعدادات", language = "اللغة", close = "إغلاق", sound = "صوت الموت", upload = "تحميل صوت مخصص", upload_error = "ملف غير صالح! استخدم MP3/WAV، الحد الأقصى 5MB." } },
        { code = "de", name = "Deutsch", translations = { wasted = "ERLEDIGT", respawn = "In %d Sekunden wiederbeleben", press = "Drücke [LEERTASTE] zum Wiederbeleben", settings = "Einstellungen", language = "Sprache", close = "Schließen", sound = "Todessound", upload = "Benutzerdefinierten Sound Hochladen", upload_error = "Ungültige Datei! Verwende MP3/WAV, max. 5MB." } },
        { code = "ru", name = "Русский", translations = { wasted = "УБИТ", respawn = "Возрождение через %d секунд", press = "Нажми [ПРОБЕЛ] для возрождения", settings = "Настройки", language = "Язык", close = "Закрыть", sound = "Звук смерти", upload = "Загрузить Пользовательский Звук", upload_error = "Недопустимый файл! Используйте MP3/WAV, макс. 5MB." } },
        { code = "pt", name = "Português", translations = { wasted = "ELIMINADO", respawn = "Ressurgir em %d segundos", press = "Pressione [ESPAÇO] para ressurgir", settings = "Configurações", language = "Idioma", close = "Fechar", sound = "Som de Morte", upload = "Carregar Som Personalizado", upload_error = "Arquivo inválido! Use MP3/WAV, máx. 5MB." } },
        { code = "ja", name = "日本語", translations = { wasted = "死亡", respawn = "%d秒後にリスポーン", press = "[スペース]を押してリスポーン", settings = "設定", language = "言語", close = "閉じる", sound = "死亡音", upload = "カスタムサウンドをアップロード", upload_error = "無効なファイル！MP3/WAVを使用、最大5MB。" } },
        { code = "ko", name = "한국어", translations = { wasted = "사망", respawn = "%d초 후 부활", press = "[스페이스]를 눌러 부활", settings = "설정", language = "언어", close = "닫기", sound = "사망 소리", upload = "사용자 정의 사운드 업로드", upload_error = "잘못된 파일! MP3/WAV 사용, 최대 5MB." } },
        { code = "pl", name = "Polski", translations = { wasted = "ZABITY", respawn = "Odrodzenie za %d sekund", press = "Naciśnij [SPACJA] aby odrodzić", settings = "Ustawienia", language = "Język", close = "Zamknij", sound = "Dźwięk Śmierci", upload = "Prześlij Niestandardowy Dźwięk", upload_error = "Nieprawidłowy plik! Użyj MP3/WAV, maks. 5MB." } },
        { code = "tr", name = "Türkçe", translations = { wasted = "ÖLDÜRÜLDÜ", respawn = "%d saniye içinde yeniden doğ", press = "Yeniden doğmak için [BOŞLUK] tuşuna bas", settings = "Ayarlar", language = "Dil", close = "Kapat", sound = "Ölüm Sesi", upload = "Özel Ses Yükle", upload_error = "Geçersiz dosya! MP3/WAV kullan, maks. 5MB." } },
        { code = "nl", name = "Nederlands", translations = { wasted = "VERNIETIGD", respawn = "Herleven in %d seconden", press = "Druk op [SPATIE] om te herleven", settings = "Instellingen", language = "Taal", close = "Sluiten", sound = "Doodsgeluid", upload = "Aangepast Geluid Uploaden", upload_error = "Ongeldig bestand! Gebruik MP3/WAV, max. 5MB." } },
        { code = "sv", name = "Svenska", translations = { wasted = "UTSLAGEN", respawn = "Återuppstå om %d sekunder", press = "Tryck på [MELLANSLAG] för att återuppstå", settings = "Inställningar", language = "Språk", close = "Stäng", sound = "Dödsljud", upload = "Ladda Upp Anpassat Ljud", upload_error = "Ogiltig fil! Använd MP3/WAV, max 5MB." } },
        { code = "fi", name = "Suomi", translations = { wasted = "KUOLLUT", respawn = "Uudelleensyntyminen %d sekunnin kuluttua", press = "Paina [VÄLILYÖNTI] uudelleensyntyäksesi", settings = "Asetukset", language = "Kieli", close = "Sulje", sound = "Kuoleman Ääni", upload = "Lataa Mukautettu Ääni", upload_error = "Virheellinen tiedosto! Käytä MP3/WAV, enintään 5MB." } },
        { code = "cs", name = "Čeština", translations = { wasted = "ZABIT", respawn = "Obnovení za %d sekund", press = "Stiskni [MEZERNÍK] pro obnovení", settings = "Nastavení", language = "Jazyk", close = "Zavřít", sound = "Zvuk Smrti", upload = "Nahrát Vlastní Zvuk", upload_error = "Neplatný soubor! Použij MP3/WAV, max. 5MB." } },
        { code = "hu", name = "Magyar", translations = { wasted = "MEGÖLVE", respawn = "Újraéledés %d másodperc múlva", press = "Nyomd meg a [SZÓKÖZ] gombot az újraéledéshez", settings = "Beállítások", language = "Nyelv", close = "Bezárás", sound = "Halál Hang", upload = "Egyéni Hang Feltöltése", upload_error = "Érvénytelen fájl! Használj MP3/WAV formátumot, max. 5MB." } }
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
    selectedLanguage = GetConVarString("seanie_deathscreen_language"),
    selectedSound = CONFIG.sounds.default_death,
    customSound = nil,
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
    local code = state.selectedLanguage
    print(code)
    if code == "default" then
        code = GetConVarString("gmod_language")
    end
    for _, lang in ipairs(CONFIG.languages) do
        if lang.code == code then
            return lang.translations[key] or CONFIG.languages[1].translations[key]
        end
    end
    return CONFIG.languages[1].translations[key]
end

-- Validate uploaded sound file
local function ValidateSoundFile(fileName, fileSize)
    if fileSize > CONFIG.sounds.max_file_size then return false end
    local ext = string.lower(string.GetExtensionFromFilename(fileName))
    for _, allowed in ipairs(CONFIG.sounds.allowed_extensions) do
        if ext == allowed then return true end
    end
    return false
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
    languageCombo:AddChoice("Default", "default")
    for _, lang in ipairs(CONFIG.languages) do
        languageCombo:AddChoice(lang.name, lang.code)
    end
    languageCombo.OnSelect = function(_, _, _, code)
        state.selectedLanguage = code
        RunConsoleCommand("seanie_deathscreen_language", code)
        surface.PlaySound("ui/buttonclick.wav")
    end
    for _, lang in ipairs(CONFIG.languages) do
        if lang.code == state.selectedLanguage then
            languageCombo:SetValue(lang.name)
            break
        end
    end
    if state.selectedLanguage == "default" then
        languageCombo:SetValue("Default")
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
    if state.customSound then
        soundCombo:AddChoice("Custom Sound", state.customSound)
    end
    soundCombo.OnSelect = function(_, _, _, file)
        state.selectedSound = file
        surface.PlaySound(file)
        net.Start("deathscreen_updateSound")
        net.WriteString(file)
        net.SendToServer()
    end
    for _, sound in ipairs(CONFIG.sounds.death_options) do
        if sound.file == state.selectedSound then
            soundCombo:SetValue(sound.name)
            break
        end
    end
    if state.customSound and state.selectedSound == state.customSound then
        soundCombo:SetValue("Custom Sound")
    end

    local uploadButton = vgui.Create("DButton", settingsPanel)
    uploadButton:SetPos(20, 220)
    uploadButton:SetSize(settingsPanel:GetWide() - 40, 30)
    uploadButton:SetText(GetTranslation("upload"))
    uploadButton:SetFont(CONFIG.fonts.settings.name)
    uploadButton:SetTextColor(CONFIG.colors.settings)
    uploadButton.DoClick = function()
        Derma_Query(
            GetTranslation("upload"),
            GetTranslation("upload"),
            "Browse",
            function()
                file.Write("gta_temp_sound.dat", "")
                gui.OpenURL("file:///" .. string.Replace(game.GetIPAddress(), ":", "_") .. "/gta_temp_sound.dat")
                timer.Simple(1, function()
                    local tempFile = file.Read("gta_temp_sound.dat", "DATA")
                    if tempFile and tempFile ~= "" then
                        local fileName = string.match(tempFile, "[^\\/]+$")
                        local fileSize = #tempFile
                        if ValidateSoundFile(fileName, fileSize) then
                            local soundPath = CONFIG.sounds.custom_upload_path .. LocalPlayer():SteamID64() .. "_" .. fileName
                            net.Start("deathscreen_uploadSound")
                            net.WriteString(fileName)
                            net.WriteData(tempFile, fileSize)
                            net.SendToServer()
                            state.customSound = soundPath
                            state.selectedSound = soundPath
                            soundCombo:AddChoice("Custom Sound", soundPath, true)
                            soundCombo:SetValue("Custom Sound")
                            surface.PlaySound(soundPath)
                        else
                            Derma_Message(GetTranslation("upload_error"), "Error", "OK")
                        end
                        file.Delete("gta_temp_sound.dat")
                    end
                end)
            end,
            "Cancel",
            function() end
        )
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
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)

-- Handle respawn notification
net.Receive("deathscreen_removeDeath", function()
    state.isDead = false
    state.respawnAllowed = false
    state.settingsOpen = false
    if IsValid(settingsPanel) then settingsPanel:Remove() end
end)
