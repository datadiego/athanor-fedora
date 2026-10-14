#!/usr/bin/env bash
# Enlaza los dotfiles de Athanor en $HOME con GNU Stow.
#   ./scripts/stow.sh            # todos los ficheros
#   ./scripts/stow.sh shell      # capa shell (sin Hyprland, Waybar ni systemd)
#   ./scripts/stow.sh tools      # la config de shell personal (athanor-tools)
#   ./scripts/stow.sh -D         # desenlaza
#
# Los ficheros que ya existen y no son de Athanor se dejan en paz: en vez de
# romper el stow, se pasan como --ignore.
set -euo pipefail

command -v stow >/dev/null || {
  echo "stow is not installed. Run scripts/common.sh first." >&2
  exit 1
}

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
pkg=athanor
target=${STOW_TARGET:-$HOME}

action=-S
layer=
for arg in "$@"; do
  [[ -z $arg ]] && continue
  case $arg in
    -D | --delete) action=-D ;;
    shell | desktop) layer=$arg ;;
    tools) pkg=athanor-tools ;;
    *)
      echo "unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

ignore=()
if [[ $layer == shell ]]; then
  ignore+=(
    --ignore='\.config/athanor/hypr'
    --ignore='\.config/athanor/waybar'
    --ignore='\.config/systemd'
  )
fi

if [[ $action == -S ]]; then
  while IFS= read -r -d '' file; do
    rel=${file#"$root/$pkg/"}
    if [[ $layer == shell ]]; then
      case $rel in
        .config/athanor/hypr/* | .config/athanor/waybar/* | .config/systemd/*) continue ;;
      esac
    fi
    dest=$target/$rel
    if [[ -e $dest || -L $dest ]]; then
      if [[ -L $dest ]]; then
        resolved=$(readlink -f "$dest" 2>/dev/null || true)
        [[ $resolved == "$root/$pkg/"* ]] && continue
      fi
      echo "! $dest already exists and isn't Athanor's. Leaving it alone." >&2
      # shellcheck disable=SC2016
      ignore+=(--ignore="$(printf '%s' "$rel" | sed 's/[.[\*^$()+?{}|]/\\&/g')")
    fi
  done < <(find "$root/$pkg" -type f -print0)
fi

mkdir -p "$target"
stow --no-folding --dir "$root" --target "$target" ${ignore[@]+"${ignore[@]}"} "$action" "$pkg"
