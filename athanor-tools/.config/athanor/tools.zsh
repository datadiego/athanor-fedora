export EDITOR=nvim
export TERMINAL=foot
export BUN_INSTALL="$HOME/.bun"
export TRY_PATH="$HOME/Documentos/tries"

typeset -U path PATH
path=(
  "$HOME/.opencode/bin"
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.turso"
  "$HOME/.cargo/bin"
  $path
)

[[ -r ~/.cargo/env ]] && source ~/.cargo/env

if [[ -o interactive ]]; then
  command -v fzf >/dev/null && source <(fzf --zsh)
  command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
  command -v navi >/dev/null && eval "$(navi widget zsh)"
  command -v lazygit >/dev/null && alias lg='lazygit'
  command -v nvim >/dev/null && alias n='nvim'
  alias la='ls -la'
fi
