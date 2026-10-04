#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=termux-url-opener
source "$SCRIPT_DIR/termux-url-opener"

pass=0
fail=0

assert_eq() {
  local expected="$1"
  local actual="$2"
  local name="$3"
  if [[ "$expected" == "$actual" ]]; then
    printf '[PASS] %s\n' "$name"
    pass=$((pass + 1))
  else
    printf '[FAIL] %s\n       expected: %s\n       actual:   %s\n' "$name" "$expected" "$actual"
    fail=$((fail + 1))
  fi
}

assert_eq "instagram" "$(classify_url "https://www.instagram.com/reel/abc123/")" "classify reel"
assert_eq "instagram" "$(classify_url "https://instagram.com/p/abc123")" "classify post"
assert_eq "instagram" "$(classify_url "https://instagram.com/reels/abc123")" "classify reels plural"
assert_eq "instagram" "$(classify_url "https://instagram.com/tv/abc123")" "classify tv"
assert_eq "instagram_other" "$(classify_url "https://www.instagram.com/stories/user/1")" "classify unsupported instagram path"
assert_eq "youtube" "$(classify_url "https://youtu.be/dQw4w9WgXcQ")" "classify youtu.be"
assert_eq "youtube" "$(classify_url "https://www.youtube.com/watch?v=dQw4w9WgXcQ")" "classify youtube"
assert_eq "other" "$(classify_url "https://example.com/video")" "classify other"
assert_eq "/sdcard/Instagram/%(title).120B-%(id)s.%(ext)s" "$(output_template_for_kind instagram)" "instagram template"
assert_eq "/sdcard/YouTube/%(title).120B-%(uploader|unknown)s.%(ext)s" "$(output_template_for_kind youtube)" "youtube template"

printf '\nTests: %d passed, %d failed\n' "$pass" "$fail"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
