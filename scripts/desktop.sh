#!/usr/bin/env bash
# Hyprland y el resto del escritorio de Athanor en Fedora.
# Hyprland no está en los repos oficiales: se usa el COPR de sdegler.
#   ./scripts/desktop.sh
set -euo pipefail

sudo dnf copr enable sdegler/hyprland -y
sudo dnf install -y \
  hyprland hyprlock hypridle hyprpaper \
  waybar mako fuzzel foot swaybg \
  libnotify grim slurp wl-clipboard brightnessctl playerctl

# Fedora no trae los símbolos de Nerd Fonts como paquete, así que se baja el
# set al directorio de usuario.
fonts="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
if ! fc-list 2>/dev/null | grep -qi "Symbols Nerd Font"; then
  mkdir -p "$fonts"
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL -o "$tmp/nerd.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
  unzip -j -o -q "$tmp/nerd.zip" 'SymbolsNerdFontMono-*' -d "$fonts" || true
  fc-cache -f "$fonts"
fi
