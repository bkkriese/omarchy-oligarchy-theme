#!/bin/bash
# Apply this theme's About/fastfetch when the staged theme ships them.
# Restore the previous About when switching to a theme that doesn't.
#
# Omarchy has no per-theme About slot (branding is machine-level; a user
# fastfetch config is a machine override). This hook is the include path.
#
# Install with:
#   omarchy hook install theme-set ~/.config/omarchy/themes/oligarchy-dark/hooks/theme-set-about.sh
#   omarchy theme set oligarchy-dark

set -euo pipefail

THEME="${1:-}"
CURRENT_THEME="$HOME/.local/state/omarchy/current/theme"
INSTALLED_THEME="$HOME/.config/omarchy/themes/${THEME}"
MARKER="oligarchy-fastfetch"

ABOUT_DST="$HOME/.config/omarchy/branding/about.txt"
ABOUT_BACKUP="$HOME/.config/omarchy/branding/about.txt.pre-oligarchy"
FETCH_DST="$HOME/.config/fastfetch/config.jsonc"
ICON_DEFAULT="${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt"

is_our_fetch() {
  [[ -f $1 ]] && grep -q "$MARKER" "$1"
}

is_our_about() {
  [[ -f $1 ]] && grep -qE "O[[:space:]]*L[[:space:]]*I[[:space:]]*G[[:space:]]*A[[:space:]]*R[[:space:]]*C[[:space:]]*H[[:space:]]*Y" "$1"
}

theme_ships_about() {
  local dir="$1"
  is_our_fetch "$dir/fastfetch.jsonc" || is_our_about "$dir/about.txt"
}

pick_source() {
  if theme_ships_about "$CURRENT_THEME"; then
    echo "$CURRENT_THEME"
    return 0
  fi
  if [[ -n $THEME ]] && theme_ships_about "$INSTALLED_THEME"; then
    echo "$INSTALLED_THEME"
    return 0
  fi
  return 1
}

apply_from() {
  local src="$1"

  mkdir -p "$(dirname "$ABOUT_DST")"
  if [[ -f $src/about.txt ]]; then
    if [[ -f $ABOUT_DST ]] && ! is_our_about "$ABOUT_DST" && [[ ! -f $ABOUT_BACKUP ]]; then
      cp "$ABOUT_DST" "$ABOUT_BACKUP"
    fi
    cp "$src/about.txt" "$ABOUT_DST"
  fi

  if [[ -f $src/fastfetch.jsonc ]]; then
    if [[ -f $FETCH_DST ]] && ! is_our_fetch "$FETCH_DST"; then
      # Leave a user's own fastfetch config alone.
      return 0
    fi
    mkdir -p "$(dirname "$FETCH_DST")"
    cp "$src/fastfetch.jsonc" "$FETCH_DST"
  fi
}

restore() {
  if is_our_fetch "$FETCH_DST"; then
    rm -f "$FETCH_DST"
  fi

  if is_our_about "$ABOUT_DST"; then
    if [[ -f $ABOUT_BACKUP ]]; then
      mv "$ABOUT_BACKUP" "$ABOUT_DST"
    elif [[ -f $ICON_DEFAULT ]]; then
      cp "$ICON_DEFAULT" "$ABOUT_DST"
    fi
  fi
}

if SRC=$(pick_source); then
  apply_from "$SRC"
else
  restore
fi
