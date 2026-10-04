## ytpro (Termux share-target downloader)

ytpro is a shell-first Termux project by **BDhaCkers009** for handling Android **Share -> Termux** URLs with an interactive terminal menu.

It supports:
- YouTube playback/download workflows (existing style preserved)
- Instagram public post/reel/tv download workflows (via `yt-dlp` backend)

> Public-content note: Instagram private/login-required URLs and Stories may fail unless you provide your own authentication setup for `yt-dlp`.

---

## Features

- Share URL directly to Termux (`termux-url-opener` workflow)
- YouTube menu:
  - play with `mpv` (optional dependency)
  - video download (up to 720p / up to 1080p)
  - audio-only / mp3 extraction
  - metadata preview
- Instagram menu (for `/reel/`, `/reels/`, `/p/`, `/tv/` URLs):
  - best video
  - smaller/data-saver variant
  - audio-only extraction (if supported by ffmpeg/yt-dlp)
  - metadata preview
- Safe default output dirs:
  - `/sdcard/YouTube`
  - `/sdcard/Instagram`
- Idempotent installer with backups before replacing managed files

---

## Install in Termux

```bash
pkg update -y && pkg upgrade -y
pkg install -y git
git clone https://github.com/BDhackers009/ytpro.git
cd ytpro
bash tuo-install.sh
```

Installer behavior:
- verifies Termux environment
- requests `termux-setup-storage` only when needed
- installs missing dependencies (`python`, `ffmpeg`, optional `mpv`)
- installs missing `yt-dlp` package using:
  - `pkg install -y python-yt-dlp`
- installs scripts to `$HOME/bin`
- creates timestamped backups before replacing managed files

---

## Usage

1. In Android app (YouTube/Instagram), open a video/post URL.
2. Tap **Share**.
3. Select **Termux**.
4. `termux-url-opener` starts and shows an interactive menu.

This workflow depends on Termux's built-in share-target integration (`termux-url-opener`) that receives the shared URL as `$1`.

You can also test directly:

```bash
termux-url-opener "https://www.instagram.com/reel/XXXXXXXX/"
termux-url-opener "https://www.youtube.com/watch?v=XXXXXXXXXXX"
```

---

## Uninstall

Use either:

```bash
bash tuo-install.sh --uninstall
```

or:

```bash
bash tuo-uninstall.sh
```

Uninstall removes only ytpro-managed files in Termux paths and **does not delete** `/sdcard/YouTube` or `/sdcard/Instagram` downloads.

---

## Local script checks (offline)

```bash
bash -n termux-url-opener tuo-install.sh tuo-uninstall.sh test.sh
bash test.sh
```

`test.sh` is lightweight and does not contact YouTube/Instagram.

---

## Troubleshooting

- **Storage permission issues**
  - Run `termux-setup-storage`
  - Ensure Android granted storage access to Termux
  - Restart Termux after granting permission

- **`yt-dlp` missing / outdated**
  - Run: `pkg install -y python-yt-dlp`
  - Re-run installer: `bash tuo-install.sh`

- **Instagram URL fails**
  - Ensure URL path is one of `/reel/`, `/reels/`, `/p/`, `/tv/`
  - Private/login-required content and Stories may not be downloadable without authentication

- **`mpv` playback option fails**
  - Install optional dependency: `pkg install mpv`

- **Termux command path problems**
  - Ensure `$HOME/bin` is in `PATH`
  - Check opener exists: `ls -l "$HOME/bin/termux-url-opener"`

---

## Attribution

Original project identity and authorship by **BDhaCkers009** is preserved.

Special thanks (from original README):
- [Tahmid Rayat (HTR-TECH)](https://github.com/htr-tech)
