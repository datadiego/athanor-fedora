#!/usr/bin/env bash
# Dependencias del layer "shell" de Athanor en Fedora.
#   ./scripts/common.sh
set -euo pipefail

# zsh es el shell de Athanor; el resto lo necesita el instalador de fuentes
# (imagemagick, perl, curl, unzip) y las plantillas de temas.
sudo dnf install -y zsh ImageMagick curl unzip fontconfig perl stow

# uv no se empaqueta de forma fiable en Fedora: se instala con el script oficial.
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# DepartureMono es la fuente por defecto de la terminal y no viene en los repos de
# Fedora, así que se baja el release de Nerd Fonts al directorio de usuario.
fonts="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
if ! fc-list 2>/dev/null | grep -qi "DepartureMono Nerd Font"; then
  mkdir -p "$fonts"
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL -o "$tmp/DepartureMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/DepartureMono.zip
  unzip -j -o -q "$tmp/DepartureMono.zip" "DepartureMonoNerdFontMono-Regular.otf" -d "$fonts" || true
  fc-cache -f "$fonts"
fi
