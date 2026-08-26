#!/bin/bash
# Apply Oligarchy About/fastfetch branding when this theme is active.
# Restore Omarchy defaults when switching away.
#
# Install with:
#   omarchy hook install theme-set hooks/theme-set-about.sh

set -euo pipefail

THEME="${1:-}"
THEME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# When installed as a hook, dirname is ~/.config/omarchy/hooks/theme-set.d
if [[ $THEME_DIR == *"/hooks/theme-set.d" ]]; then
  THEME_DIR="$HOME/.config/omarchy/themes/oligarchy"
fi

MARKER="oligarchy-fastfetch"
ABOUT_DST="$HOME/.config/omarchy/branding/about.txt"
FETCH_DST="$HOME/.config/fastfetch/config.jsonc"
ABOUT_SRC="$THEME_DIR/about.txt"
FETCH_SRC="$THEME_DIR/fastfetch.jsonc"
ICON_DEFAULT="${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt"

is_ours() {
  [[ -f $FETCH_DST ]] && grep -q "$MARKER" "$FETCH_DST"
}

if [[ $THEME == oligarchy ]]; then
  [[ -f $ABOUT_SRC ]] && cp "$ABOUT_SRC" "$ABOUT_DST"
  if [[ -f $FETCH_SRC ]]; then
    if [[ ! -f $FETCH_DST ]] || is_ours; then
      mkdir -p "$(dirname "$FETCH_DST")"
      cp "$FETCH_SRC" "$FETCH_DST"
    fi
  fi
else
  if is_ours; then
    rm -f "$FETCH_DST"
  fi
  if [[ -f $ABOUT_DST ]] && grep -q OLIGARCHY "$ABOUT_DST" 2>/dev/null; then
    [[ -f $ICON_DEFAULT ]] && cp "$ICON_DEFAULT" "$ABOUT_DST"
  fi
fi
