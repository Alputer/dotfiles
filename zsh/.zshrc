export HISTFILE="$HOME/.zsh_history"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
setopt appendhistory # Makes Zsh append new commands to the history file instead of overwriting it when the shell exits.
setopt sharehistory # Allows all running Zsh sessions to share command history in real time.

# mise
eval "$(mise activate zsh)"

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# system info once per boot
if [[ -o interactive ]]; then
  stamp_file="$XDG_CACHE_HOME/fastfetch-boot"
  boot_time="$(sysctl -n kern.boottime | sed -E 's/.*sec = ([0-9]+).*/\1/')"
  mkdir -p "$XDG_CACHE_HOME"
  if [[ ! -f "$stamp_file" || "$(cat "$stamp_file")" != "$boot_time" ]]; then
    echo "$boot_time" > "$stamp_file"
    fastfetch
  fi
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

