# MTG Arena Video Maker

This project automates the creation of "Audio-Background" videos for Magic The Gathering Arena soundtracks. It uses a Docker container to watch your input folders and generate `.mp4` videos with 1-second fade-ins and fade-outs.



---

## 🇺🇸 English

### Overview
The goal is to transform in-game audio tracks into simple, ready-to-share videos by pairing each music file with its official Keyart.

### Workflow
The process is semi-automated to ensure high-quality output:
1.  **Audio**: Manually extracted from the game client using **Wwise Unpacker** (not currently automatable as `.pck` files require specific extraction tools).
2.  **Images**: Official Keyarts sourced from [Wizards WPN Marketing Materials](https://wpn.wizards.com/en/marketing-materials). Supported formats: `.png`, `.jpg`, `.jpeg`.
3.  **Naming**: The script automatically extracts the 3-letter set code from Wwise audio file names (e.g., `BAT_ONE_hash_1.mp3` looks for `ONE.jpg`).
4.  **Automation**: Once files are dropped, the container detects the pair and generates the video. Multiple tracks from the same extract are automatically numbered (e.g. `MTGArena OST - ONE 1_2.mp4`).

### Configuration
The service relies on three volume mappings to manage the workflow:
* `./input/audio`: Source folder for MP3 files.
* `./input/keyart`: Source folder for PNG files.
* `./output`: Destination for the final MP4 videos.
* `FADEOUT_TIME`: Environment variable to set the fadeout duration in seconds (default: 1).

---

## 🇫🇷 Français

### Présentation
L'objectif est de transformer les pistes sonores du jeu en vidéos simples prêtes à être partagées ou archivées, en associant chaque musique à son Keyart officiel.

### Workflow
Le processus est semi-automatique pour garantir la meilleure qualité possible :
1.  **Audio** : Extraits manuellement du client de jeu via **Wwise Unpacker** (actuellement non automatisable car les fichiers `.pck` nécessitent une extraction spécifique).
2.  **Images** : Keyarts officiels téléchargés sur le site [WPN Wizards Marketing Materials](https://wpn.wizards.com/fr/marketing-materials). Formats supportés : `.png`, `.jpg`, `.jpeg`.
3.  **Nommage** : Le script extrait automatiquement le trigramme de l'extension depuis les fichiers audio Wwise (ex: `BAT_ONE_hash_1.mp3` cherchera l'image `ONE.jpg`).
4.  **Automatisation** : Une fois les fichiers déposés, le conteneur détecte la paire et génère la vidéo. S'il y a plusieurs pistes pour une même extraction, les fichiers finaux seront automatiquement numérotés (ex: `MTGArena OST - ONE 1_2.mp4`).

### Configuration (FR)
Le service s'appuie sur trois points de montage pour organiser le flux de travail :
* `./input/audio` : Dossier source des fichiers MP3.
* `./input/keyart` : Dossier source des fichiers PNG.
* `./output` : Destination des vidéos finales.
* `FADEOUT_TIME` : Variable d'environnement pour définir la durée du fadeout en secondes (par défaut : 1).

---

## 🚀 Setup & Launch

Use the following `docker-compose.yml` file to start the service:

```yaml
services:
  mtgavideomaker:
    image: ghcr.io/whit3str/mtgavideomaker:latest
    container_name: mtgavideomaker
    restart: unless-stopped
    environment:
      - FADEOUT_TIME=1
    volumes:
      - ./input/audio:/input/audio
      - ./input/keyart:/input/keyart
      - ./output:/output
```

## ⚖️ Legal Disclaimer

### 🇺🇸 English
This project is unofficial Fan Content permitted under the Fan Content Policy. This tool is not approved or endorsed by Wizards. Portions of the materials used (audio and keyart) are property of Magic: The Gathering and Wizards of the Coast, LLC. © Wizards of the Coast LLC.

### 🇫🇷 Français
Ce projet est un contenu de fan non officiel autorisé dans le cadre de la Politique relative au contenu des fans. Cet outil n'est ni approuvé ni parrainé par Wizards. Une partie des matériaux utilisés (audio et images) est la propriété de Magic: The Gathering et de Wizards of the Coast, LLC. © Wizards of the Coast LLC.
