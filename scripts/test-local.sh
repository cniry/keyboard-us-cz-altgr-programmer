#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SYMBOLS_FILE="$REPO_DIR/xkb/symbols/us-cz-altgr-programmer"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
  echo "Warning: current session is Wayland. This test only affects X11/XWayland clients." >&2
fi

mkdir -p "$TMP_DIR/symbols"
cp "$SYMBOLS_FILE" "$TMP_DIR/symbols/us-cz-altgr-programmer"

setxkbmap \
  -I"$TMP_DIR" \
  -layout us-cz-altgr-programmer \
  -option lv3:ralt_switch \
  -print | xkbcomp -I"$TMP_DIR" - "$DISPLAY"

echo "Loaded us-cz-altgr-programmer for current X11 session. Revert with: setxkbmap us"
