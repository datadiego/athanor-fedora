# About Athanor

This is a modified and personal version for [athanor](https://github.com/script-wizards/athanor) by script-wizards, using fedora as base distro instead of arch, and adding extra tools, fonts and dotfiles i use in my environment. Please refer to the original repo for a full knowledge of what athanor adds to hyprland.

## Install

On Fedora:

```sh
sudo dnf install make stow -y
git clone https://github.com/datadiego/athanor-fedora .dotfiles
cd .dotfiles
make install
sudo chsh -s /usr/bin/zsh
# personal environment tools
make tools
make dev
```

Athanor keeps its files in `~/.config/athanor`. Outside that folder it only
adds a marked block to the top of your `.zshrc` and your `hyprland.lua`. Your
own settings load after the block and override it.

## Extra tools

`make tools` and `make dev` also link an optional `~/.config/athanor/tools.zsh`
with a personal shell setup (environment, `PATH` and the `fzf`, `zoxide` and
`navi` integrations). The prompt sources it only if it exists, so without those
targets the shell stays exactly as Athanor ships it. `make untools` removes it.

I added zsh completion, and extra fonts, they are noted on `.config/athanor/athanor.toml`, they all snap to the nearest multiple of its grid to keep them crisp.

