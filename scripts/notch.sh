#!/usr/bin/env bash
# Dependencias para compilar el plugin notch de Athanor en Fedora.
# El Makefile del plugin usa pkg-config para pixman, libdrm, hyprland,
# pangocairo, libinput, libudev, wayland-server y xkbcommon.
#   ./scripts/notch.sh
set -euo pipefail

sudo dnf copr enable sdegler/hyprland -y
sudo dnf install -y \
  gcc gcc-c++ make pkgconf-pkg-config \
  pixman-devel libdrm-devel hyprland-devel pango-devel \
  libinput-devel systemd-devel wayland-devel libxkbcommon-devel
