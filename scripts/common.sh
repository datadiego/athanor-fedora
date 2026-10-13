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
