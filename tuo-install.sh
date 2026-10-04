#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/bin"
YTDLP_CONFIG_DIR="${HOME}/.config/yt-dlp"
YOUTUBE_DIR="/sdcard/YouTube"
INSTAGRAM_DIR="/sdcard/Instagram"
TS="$(date +%Y%m%d-%H%M%S)"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }
err() { printf '[ERROR] %s\n' "$*" >&2; }

require_termux() {
  if [[ "${PREFIX:-}" != "/data/data/com.termux/files/usr" ]]; then
    err "This installer must run inside Termux."
    exit 1
  fi
}

ensure_storage_access() {
  if [[ -d "${HOME}/storage/shared" && -e "/sdcard" ]]; then
    info "Termux storage access already configured."
    return 0
  fi

  info "Requesting storage permission (termux-setup-storage)."
  info "When prompted, allow storage permission in Android settings."
  termux-setup-storage

  if [[ ! -d "${HOME}/storage/shared" || ! -e "/sdcard" ]]; then
    err "Storage is still unavailable. Restart Termux and rerun installer."
    exit 1
  fi
}

install_pkg_if_missing() {
  local pkg_name="$1"
  local cmd_name="$2"
  if command -v "$cmd_name" >/dev/null 2>&1; then
    info "$pkg_name already installed."
    return 0
  fi
  info "Installing $pkg_name ..."
  pkg install -y "$pkg_name"
}

install_dependencies() {
  install_pkg_if_missing python python
  install_pkg_if_missing ffmpeg ffmpeg

  if command -v mpv >/dev/null 2>&1; then
    info "mpv already installed."
  else
    warn "mpv not found; attempting install (optional for playback)."
    if ! pkg install -y mpv; then
      warn "mpv install failed. Download features still work without mpv."
    fi
  fi

  info "Installing/upgrading yt-dlp with pip ..."
  python -m pip install --upgrade yt-dlp
}

backup_if_needed() {
  local dest="$1"
  local src="$2"

  if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
    info "Unchanged: $dest"
    return 0
  fi

  if [[ -e "$dest" ]]; then
    local backup="${dest}.bak.${TS}"
    cp -a "$dest" "$backup"
    info "Backup created: $backup"
  fi

  cp "$src" "$dest"
  chmod +x "$dest" 2>/dev/null || true
  info "Installed: $dest"
}

install_files() {
  mkdir -p "$BIN_DIR" "$YTDLP_CONFIG_DIR" "$YOUTUBE_DIR" "$INSTAGRAM_DIR"

  backup_if_needed "$BIN_DIR/termux-url-opener" "$SCRIPT_DIR/termux-url-opener"
  backup_if_needed "$BIN_DIR/ytpro-uninstall" "$SCRIPT_DIR/tuo-uninstall.sh"
  backup_if_needed "$YTDLP_CONFIG_DIR/ytpro.config" "$SCRIPT_DIR/config"
}

run_uninstall() {
  if [[ -x "$SCRIPT_DIR/tuo-uninstall.sh" ]]; then
    "$SCRIPT_DIR/tuo-uninstall.sh"
  elif [[ -x "$BIN_DIR/ytpro-uninstall" ]]; then
    "$BIN_DIR/ytpro-uninstall"
  else
    warn "Uninstall script not found."
    return 1
  fi
}

main() {
  if [[ "${1:-}" == "--uninstall" ]]; then
    run_uninstall
    return 0
  fi

  require_termux
  ensure_storage_access
  install_dependencies
  install_files

  info "Installation complete."
  info "Share YouTube or Instagram URLs to Termux to launch termux-url-opener."
  info "Downloads: $YOUTUBE_DIR and $INSTAGRAM_DIR"
}

main "$@"
