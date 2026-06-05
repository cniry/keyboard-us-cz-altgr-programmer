#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYMBOLS_FILE="$ROOT_DIR/xkb/symbols/us-cz-altgr-programmer"
PACKAGE_FILE="$ROOT_DIR/package/default.nix"
README_FILE="$ROOT_DIR/README.md"
FLAKE_FILE="$ROOT_DIR/flake.nix"

echo "==> Checking required files"
for file in \
  "$SYMBOLS_FILE" \
  "$PACKAGE_FILE" \
  "$ROOT_DIR/default.nix" \
  "$FLAKE_FILE" \
  "$ROOT_DIR/shell.nix" \
  "$ROOT_DIR/VERSION" \
  "$ROOT_DIR/CHANGELOG.md" \
  "$ROOT_DIR/nixos/us-cz-altgr-programmer.nix" \
  "$ROOT_DIR/docs/README-NixOS.md" \
  "$ROOT_DIR/docs/README-Ubuntu-Mint.md"; do
  test -f "$file"
done

echo "==> Checking project names"
grep -q 'us-cz-altgr-programmer' "$SYMBOLS_FILE"
grep -q 'us-cz-altgr-programmer-xkb' "$PACKAGE_FILE"
grep -q 'github.com/cniry/keyboard-us-cz-altgr-programmer' "$README_FILE"

if grep -R 'us-cz-programmer\|keyboard-us-cz-programmer' "$ROOT_DIR" \
  --exclude-dir=.git \
  --exclude='*.zip' \
  --exclude='run-self-tests.sh'; then
  echo "Found stale pre-rename project name." >&2
  exit 1
fi

echo "==> Checking version"
grep -q 'version = "0.0.2"' "$PACKAGE_FILE"
grep -q 'Version: `0.0.2`' "$README_FILE"
grep -qx '0.0.2' "$ROOT_DIR/VERSION"

echo "==> Checking required key mappings"
grep -q 'key <AE04>.*ccaron.*Ccaron' "$SYMBOLS_FILE"
grep -q 'key <AE05>.*rcaron.*Rcaron' "$SYMBOLS_FILE"
grep -q 'key <AC10>.*uring.*Uring' "$SYMBOLS_FILE"
grep -q 'key <BKSL>.*ncaron.*Ncaron' "$SYMBOLS_FILE"
grep -q 'key <AD03>.*eacute.*EuroSign' "$SYMBOLS_FILE"
grep -q 'key <TLDE>.*NoSymbol.*degree' "$SYMBOLS_FILE"

echo "==> Checking XKB syntax with xkbcomp"
if command -v xkbcomp >/dev/null 2>&1; then
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  mkdir -p "$TMP_DIR/symbols"
  cp "$SYMBOLS_FILE" "$TMP_DIR/symbols/us-cz-altgr-programmer"
  cat > "$TMP_DIR/test-keymap.xkb" <<'XKBEOF'
xkb_keymap {
  xkb_keycodes  { include "evdev+aliases(qwerty)" };
  xkb_types     { include "complete" };
  xkb_compat    { include "complete" };
  xkb_symbols   { include "pc+us-cz-altgr-programmer+inet(evdev)" };
  xkb_geometry  { include "pc(pc105)" };
};
XKBEOF
  if ! xkbcomp -I"$TMP_DIR" "$TMP_DIR/test-keymap.xkb" /dev/null >"$TMP_DIR/xkbcomp.log" 2>&1; then
    cat "$TMP_DIR/xkbcomp.log" >&2
    exit 1
  fi
else
  echo "xkbcomp not found; skipping XKB syntax check." >&2
fi

echo "==> Self-tests passed"
