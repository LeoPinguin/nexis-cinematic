Config = {}

-- Default Language ('fr' ou 'en')
Config.Locale = 'en'

-- ACE permission required to access the cinematic menu (to be added in server.cfg)
-- To add in server.cfg: add_ace group.admin cinematic.admin allow
Config.AdminAce = 'cinematic.admin'

-- Command to disable the HUD (leave empty '' if not desired)
Config.HudCommand = 'togglehud'

-- Locales for the menu and notifications
Config.Locales = {
    ['en'] = {
        menu_title = '🎬 Cinematic Manager',
        play_all = 'Play for everyone',
        play_all_desc = 'Starts the video for all players',
        play_radius = 'Play around me (Radius)',
        play_radius_desc = 'Starts for nearby players',
        play_id = 'Play for a player (ID)',
        play_id_desc = 'Starts for a specific ID',
        preview = 'Preview (Only me)',
        preview_desc = 'Test the video and sound',
        stop_all = '⛔ EMERGENCY STOP',
        stop_all_desc = 'Stops the video for EVERYONE',
        
        input_global_title = 'Start Cinematic (Global)',
        input_zone_title = 'Start Cinematic (Zone)',
        input_id_title = 'Start Cinematic (ID)',
        input_preview_title = 'Preview',
        
        label_yt_id = 'YouTube Video ID (ex: dQw4w9WgXcQ)',
        label_volume = 'Volume',
        label_radius = 'Radius (meters)',
        label_player_id = 'Player ID',
        
        notify_debug_title = 'Cinematic Debug',
        notify_debug_desc = 'Video closed and HUD reactivated.',
        
        log_unauthorized = "Unauthorized attempt to start a cinematic by ID: ",
        log_emergency = "Emergency stop triggered by ID: "
    },
        ['fr'] = {
        menu_title = '🎬 Gestion Cinématique',
        play_all = 'Jouer à tout le monde',
        play_all_desc = 'Lance la vidéo pour tous les joueurs',
        play_radius = 'Jouer autour de moi (Rayon)',
        play_radius_desc = 'Lance pour les joueurs proches',
        play_id = 'Jouer pour un joueur (ID)',
        play_id_desc = 'Lance pour un ID spécifique',
        preview = 'Preview (Seulement moi)',
        preview_desc = 'Tester la vidéo et le son',
        stop_all = '⛔ ARRÊT D’URGENCE',
        stop_all_desc = 'Coupe la vidéo pour TOUT LE MONDE',
        
        input_global_title = 'Lancer une cinématique (Global)',
        input_zone_title = 'Lancer une cinématique (Zone)',
        input_id_title = 'Lancer une cinématique (ID)',
        input_preview_title = 'Preview',
        
        label_yt_id = 'ID Vidéo YouTube (ex: dQw4w9WgXcQ)',
        label_volume = 'Volume',
        label_radius = 'Rayon (mètres)',
        label_player_id = 'ID du joueur',
        
        notify_debug_title = 'Cinématique Debug',
        notify_debug_desc = 'Vidéo fermée et HUD réactivé.',
        
        log_unauthorized = "Tentative non autorisée de lancer une cinématique par l'ID: ",
        log_emergency = "Arrêt d'urgence déclenché par l'ID: "
    }
}

-- Helper function to retrieve translations
function _L(str)
    if not Config.Locales[Config.Locale] then return str end
    return Config.Locales[Config.Locale][str] or str
end