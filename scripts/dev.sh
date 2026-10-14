#!/usr/bin/env bash
# Herramientas de desarrollo de Athanor en Fedora.
#   ./scripts/dev.sh        # instala y activa la config de shell personal
#   ./scripts/dev.sh -D     # desenlaza la config de shell personal
set -uo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
if [[ ${1:-} == -D || ${1:-} == --unstow ]]; then
  bash "$root/scripts/stow.sh" tools -D
  exit 0
fi

# pgcli
sudo dnf install -y pgcli

# httpie
sudo dnf install -y httpie

#sql
sudo dnf install sqlite3 sqlitebrowser -y

# zed
curl -f https://zed.dev/install.sh | sh

# vscode
# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
#   echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
# dnf check-update &&
#   sudo dnf install code -y

# gh cli
sudo dnf install dnf5-plugins -y
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo -y
sudo dnf install gh --repo gh-cli -y

# entorno javascript
sudo dnf install npm nodejs -y
curl -fsSL https://bun.sh/install | bash

# csvkit
pipx install csvkit

# go
sudo dnf install -y golang

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# java
#sudo dnf install java-latest-openjdk -y

# lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# lazygit
sudo dnf copr enable dejan/lazygit -y
sudo dnf install lazygit -y

#neovim
sudo dnf install nvim -y

# docker
sudo dnf remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine -y

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl enable --now docker
sudo groupadd -f docker
sudo usermod -aG docker "$USER"

# opencode
curl -fsSL https://opencode.ai/v2/install | bash

# La config de shell personal: entorno, PATH y las integraciones de fzf, zoxide y navi.
bash "$root/scripts/stow.sh" tools
