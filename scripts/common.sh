#!/usr/bin/env bash
# Dependencias del layer "shell" de Athanor en Fedora.
#   ./scripts/common.sh
set -euo pipefail

# zsh es el shell de Athanor; el resto lo necesita el instalador de fuentes
# (imagemagick, perl, curl, unzip) y las plantillas de temas.
sudo dnf install -y zsh ImageMagick curl unzip fontconfig perl stow || true

# zsh-autosuggestions da sugerencias de historial al estilo fish. No siempre está
# en los repos de Fedora; si no se encuentra, el usuario puede instalarlo a mano.
sudo dnf install -y zsh-autosuggestions || true

# uv no se empaqueta de forma fiable en Fedora: se instala con el script oficial.
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Fuentes Nerd Font para la terminal (no vienen en los repos de Fedora, así que
# se bajan los releases de Nerd Fonts al directorio de usuario).
fonts="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
mkdir -p "$fonts"

# Instala una fuente Nerd Font si todavía no está registrada en fontconfig.
# Argumentos: nombre url_zip archivo_dentro_del_zip nombre_para_fc-list
install_nerd_font() {
  local name="$1" url="$2" file="$3" grep_name="$4"
  if fc-list 2>/dev/null | grep -qi "$grep_name"; then
    return 0
  fi
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/$name.zip" "$url"
  unzip -j -o -q "$tmp/$name.zip" "$file" -d "$fonts" || true
  rm -rf "$tmp"
}

install_nerd_font "DepartureMono" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/DepartureMono.zip" \
  "DepartureMonoNerdFontMono-Regular.otf" \
  "DepartureMono Nerd Font"

install_nerd_font "IosevkaTerm" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/IosevkaTerm.zip" \
  "IosevkaTermNerdFontMono-Regular.ttf" \
  "IosevkaTerm Nerd Font"

install_nerd_font "Terminus" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/Terminus.zip" \
  "TerminessNerdFontMono-Regular.ttf" \
  "Terminess Nerd Font"

install_nerd_font "ProggyClean" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/ProggyClean.zip" \
  "ProggyCleanNerdFontMono-Regular.ttf" \
  "ProggyClean Nerd Font"

fc-cache -f "$fonts"
