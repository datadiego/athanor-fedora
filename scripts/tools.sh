#!/usr/bin/env bash
# Utilidades y herramientas CLI de Athanor en Fedora.
#   ./scripts/tools.sh        # instala y activa la config de shell personal
#   ./scripts/tools.sh -D     # desenlaza la config de shell personal
set -uo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
if [[ ${1:-} == -D || ${1:-} == --unstow ]]; then
  bash "$root/scripts/stow.sh" tools -D
  exit 0
fi

# update
sudo dnf update -y

# utilidades
sudo dnf install pipx unzip xclip yq jq fzf stow eza tldr fastfetch micro stow btop brightnessctl fd-find curl wget2 -y

# cargo
sudo dnf install cargo -y

# nushell
sudo dnf install -y nu

# jc
pipx install jc

# wormhole
pipx install magic-wormhole

# fish
#sudo dnf install -y fish

# navi
sudo dnf install -y navi

# alacritty
#sudo dnf install -y alacritty

# starship
#curl -sS https://starship.rs/install.sh | sh -s -- --yes

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Nerd fonts
# wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
# unzip -o JetBrainsMono.zip -d ~/.local/share/fonts
# fc-cache -f -v

#tetro-tui
URL="https://github.com/Strophox/tetro-tui/releases/download/v3.1.0/tetro-tui_v3.1_x86_64-unknown-linux-gnu.zip"
TMP_DIR="$(mktemp -d)"
wget -q "$URL" -O "$TMP_DIR/tetro.zip"
unzip -q "$TMP_DIR/tetro.zip" -d "$TMP_DIR"
chmod +x "$TMP_DIR/tetro-tui"
sudo mv "$TMP_DIR/tetro-tui" /usr/local/bin/tetro-tui

rm -rf "$TMP_DIR"

# lsoff
curl -sL "$(curl -s https://api.github.com/repos/yutat23/lsoff/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4)" -o /tmp/lsoff
chmod +x /tmp/lsoff
sudo mv /tmp/lsoff /usr/local/bin/lsoff

# Codecs (RPM Fusion + ffmpeg completo para mkv, h264, hevc, etc)
sudo dnf install \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

# try
sudo dnf install ruby -y
echo 'gem: -n ~/.local/bin' >>~/.gemrc
gem install try-cli --user-install

# asciinema
pipx install asciinema

cargo install --locked --git https://github.com/asciinema/agg

# vm-curator
# sudo dnf install rust-libudev-devel -y
# cargo install vm-curator -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# La config de shell personal: entorno, PATH y las integraciones de fzf, zoxide y navi.
bash "$root/scripts/stow.sh" tools

