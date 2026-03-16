#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="${HOME}/.local/share/fonts/silly-glitch"

echo "Installing Operator Mono fonts from ${SCRIPT_DIR}/fonts/ ..."
mkdir -p "$FONT_DIR"
cp "$SCRIPT_DIR"/fonts/OperatorMono*.otf "$FONT_DIR/"

echo "Updating font cache ..."
fc-cache -fv "$FONT_DIR"

echo ""
echo "Installed fonts:"
fc-list | grep -i "operator mono"
echo ""
echo "Done. Open glitch.html in a browser to see the effect."
