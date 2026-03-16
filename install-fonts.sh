#!/usr/bin/env bash
set -euo pipefail

FONT_URL="https://asplo.de/u/IhpZrq.xz"
FONT_DIR="${HOME}/.local/share/fonts/silly-glitch"
TMP=$(mktemp -d)

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading fonts from $FONT_URL ..."
curl -fL "$FONT_URL" -o "$TMP/fonts.xz"

echo "Extracting ..."
# The .xz may be a bare xz-compressed tarball or a plain xz file
if xz -t "$TMP/fonts.xz" 2>/dev/null; then
    xz -dk "$TMP/fonts.xz" -c > "$TMP/fonts.tar" || cp "$TMP/fonts.xz" "$TMP/fonts.tar"
fi

# Try to untar; if it's not a tar just grab bare font files
if tar tf "$TMP/fonts.tar" &>/dev/null; then
    tar xf "$TMP/fonts.tar" -C "$TMP"
else
    cp "$TMP/fonts.tar" "$TMP/font.otf"
fi

mkdir -p "$FONT_DIR"
find "$TMP" -type f \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.woff" -o -iname "*.woff2" \) \
    -exec cp {} "$FONT_DIR/" \;

echo "Updating font cache ..."
fc-cache -fv "$FONT_DIR"

echo ""
echo "Installed fonts:"
fc-list | grep -i "$FONT_DIR" || fc-list : family | sort | grep -v "^$" | tail -20
echo ""
echo "Done. Open glitch.html in a browser to see the effect."
