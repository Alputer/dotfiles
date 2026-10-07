export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="open"

# mise (installed via https://mise.run)
export PATH="$HOME/.local/bin:$PATH"

# Homebrew prefix (populated by `mise bootstrap packages`)
export PATH="/opt/homebrew/bin:$PATH"

# Bitwarden SSH agent (.dmg build); falls back to the system agent if absent
if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

