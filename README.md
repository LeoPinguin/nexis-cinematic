# 🎬 FiveM Cinematic Video Player (Standalone)

A complete and 100% Standalone script allowing you to broadcast YouTube videos directly onto players' screens to create immersive cinematics during your server events.

This script stands out with its **off-screen preloading technique**: the default YouTube interface (red Play button, video title, recommended videos) is completely hidden. Players only experience a smooth transition directly into the video, guaranteeing total immersion.

## ✨ Features

*   **100% Standalone:** Works on any framework (ESX, QBCore, vRP, or a blank server) using FiveM's native ACE permission system.
*   **Total Immersion:** Complete bypass of the YouTube UI (Buttons, Titles, Logos) thanks to an off-screen Iframe preload and a slight zoom.
*   **Dynamic HUD Management:** The script automatically hides the HUD and minimap during the video, and restores them once it finishes.
*   **Multiple Broadcast Modes:**
    *   🌍 **Global:** Plays the video for all online players.
    *   📍 **Radius (Zone):** Plays the video only for players within a defined radius around the administrator.
    *   👤 **Player (ID):** Plays the video for a specific player.
    *   👁️ **Preview:** Test the video and volume locally before playing it for everyone else.
*   **Emergency Stop:** Instantly cut the video for everyone with a single click.
*   **Multilingual:** Easy-to-modify configuration file (English and French included).

## 🛠️ Requirements

This script only requires the following UI library:
*   [ox_lib](https://github.com/overextended/ox_lib)

## 📥 Installation

1. Download the latest version of the script.
2. Extract the folder into your `resources` directory.
3. Ensure the folder is named `cinematique` (or your preferred name, but avoid capital letters).
4. Add the following lines to your `server.cfg` file:

```cfg
ensure ox_lib
ensure cinematique
```

## ⚙️ Configuration (ACE Permissions)

The script no longer relies on a specific framework to check for administrators; it uses native ACE permissions.

To allow your admins to use the menu, you need to add this line to your `server.cfg` (adjust `group.admin` according to your server setup):

```cfg
# Grants permission to use the cinematic script to administrators
add_ace group.admin cinematique.admin allow
```

You can change the required ACE node and the translations directly in the `config.lua` file.

## ⌨️ Commands

| Command | Description | Required Permission |
| :--- | :--- | :--- |
| `/cinemenu` | Opens the main menu to play/manage videos. | `cinematic.admin` (ACE) |
| `/togglehud` | Allows players to manually hide/show their HUD (blocked while a video is playing). | None (All players) |
| `/debugcine` | Failsafe command to force-stop the video and unhide the HUD in case of a client-side bug. | None (All players) |

## 💡 How to get a YouTube Video ID?

The video ID is the string of letters and numbers located in the URL after `?v=`.
Example: For the URL `https://www.youtube.com/watch?v=dQw4w9WgXcQ`, the ID you need to paste into the script is **`dQw4w9WgXcQ`**.
