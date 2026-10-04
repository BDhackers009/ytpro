#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

BIN_DIR="${HOME}/bin"
CONFIG_FILE="${HOME}/.config/yt-dlp/ytpro.config"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }

is_managed_file() {
  local path="$1"
  [[ -f "$path" ]] && head -n 1 "$path" 2>/dev/null | grep -q "Managed by ytpro"
}

remove_file_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    rm -f "$path"
    info "Removed $path"
  else
    info "Not found: $path"
  fi
}

main() {
  if [[ "${PREFIX:-}" != "/data/data/com.termux/files/usr" ]]; then
    warn "This uninstall script is intended for Termux."
  fi

  remove_file_if_exists "$BIN_DIR/termux-url-opener"
  remove_file_if_exists "$BIN_DIR/ytpro-uninstall"

  if is_managed_file "$CONFIG_FILE"; then
    rm -f "$CONFIG_FILE"
    info "Removed managed config: $CONFIG_FILE"
  elif [[ -f "$CONFIG_FILE" ]]; then
    warn "Keeping $CONFIG_FILE (not marked as ytpro-managed)."
  else
    info "Not found: $CONFIG_FILE"
  fi

  info "Done. Download folders (/sdcard/YouTube, /sdcard/Instagram) were not deleted."
}

main "$@"
