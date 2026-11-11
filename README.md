## Introduction

ytpro is a Termux share handler for YouTube. Share a video from the YouTube app
to Termux and you get a small terminal menu: stream it with `mpv`, download the
video in any resolution YouTube offers, or download the audio (native or MP3).

Every step is visible: format lists, size estimates, a live progress bar with
speed/ETA, and a completion card when the download finishes.

## Features

- **One-shot flow.** Link → mode → quality → download → summary → exit. No menu
  loop, no leftovers.
- **Every video format is listed**, one row per resolution/fps, with the codec
  and an estimated size. `Best available` is first.
- **Codec policy:** H.264 first, then AV1, then VP9; m4a audio is preferred and
  the result is muxed to MP4 when possible.
- **Audio list:** native streams ranked by bitrate (best preselected) plus MP3
  re-encodes at 320/192/128 kbps at the bottom.
- **Live progress:** one clean bar with percent, speed, and ETA. A spinner
  covers merge/convert time. Downloads over 1 GiB ask first.
- **Blocking result card:** Done (Enter), Play, Copy path, Show log. `Ctrl+C`
  during a download shows a cancel card and exits cleanly.
- **Playlists:** choose this video only (default) or the whole playlist.
- **Live streams:** detected and downloaded from the start.
- **Stateless downloads:** `-f`/`-x` flags are passed per run; your
  `~/.config/yt-dlp/config` is no longer edited.
- **Log:** the last run is always at `~/.cache/ytpro/last.log`.

## Requirements

Termux (F-Droid or GitHub build, not the Play Store build), plus:

- `python`, `mpv`, `ffmpeg`, `yt-dlp`, `dialog`, `gum`, `deno`
- Optional: the **Termux:API** app + `termux-api` package for **Copy path** and
  toasts. `termux-open` (Play) ships with Termux itself.

`tuo-install.sh` installs the packages, including `gum` and `deno`. `deno` gives
yt-dlp a JavaScript runtime, which unlocks some YouTube formats.

## Installation

Run from the cloned repo's root (the installer copies files from the current
directory):

```bash
pkg upgrade -y
pkg install git -y
git clone https://github.com/BDhackers009/ytpro.git
cd ytpro
bash tuo-install.sh
```

The installer creates `~/bin`, `~/.config/yt-dlp`, and `/sdcard/YouTube`, backs
up an existing config to `config.bak`, and installs:

- `~/bin/termux-url-opener` (the share handler)
- `~/.config/yt-dlp/config` (output path, `--no-mtime`, SponsorBlock removal)

## Usage

1. Open the YouTube app and share a video.
2. Pick **Termux** in the share sheet.
3. Choose an action:
   1. **Play audio** – stream with `mpv`, no download.
   2. **Download video** – pick a resolution from the list.
   3. **Download audio** – pick a native stream or an MP3 preset.
4. Watch the progress bar, then use the completion card:
   - **Done** – exit (Enter also works).
   - **Play** – open the finished file.
   - **Copy path** – put the file path on the clipboard.
   - **Show log** – inspect the last yt-dlp run.
5. The share session ends when you choose **Done**.

Downloads land in **`/sdcard/YouTube`** using
`%(title)s-[%(id)s].%(ext)s`.

### Notes

- If a link belongs to a playlist, ytpro asks whether to download just the
  video or the whole playlist. A whole playlist uses the best quality for the
  chosen mode; its completion card offers Done and Show log because there is no
  single output path to play or copy.
- Live streams are labelled `LIVE`; ytpro downloads them from the start.
- If you share a URL that contains `&` (playlists, some `?si=...` links), the
  URL is passed quoted, so it is safe now.
- If a JavaScript runtime is missing, yt-dlp warns and some formats may be
  unavailable. Run `pkg install deno` (the installer does this by default).

### Special Thanks

- [**Tahmid Rayat (HTR-TECH)**](https://github.com/htr-tech)
