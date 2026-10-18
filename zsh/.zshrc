export HISTFILE="$HOME/.zsh_history"    # History filepath
export HISTSIZE=90000                   # Maximum events for internal history
export SAVEHIST=90000                   # Maximum events in history file
setopt appendhistory                    # Makes Zsh append new commands to the history file instead of overwriting it when the shell exits.
setopt sharehistory                     # Allows all running Zsh sessions to share command history in real time.

bindkey -e # emacs mode

# mise
eval "$(mise activate zsh)"

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

source <(fzf --zsh) # Ctrl-R + Ctrl-T + Alt-C

export PATH=/Users/alputer/.opencode/bin:$PATH

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# system info once per boot
if [[ -o interactive ]] && (( $+commands[fastfetch] )); then
  fastfetch_stamp="$HOME/.cache/fastfetch-boot"
  boot_time=$(sysctl -n kern.boottime | sed -E 's/^\{ sec = ([0-9]+).*/\1/')
  mkdir -p "$HOME/.cache"
  if [[ ! -f $fastfetch_stamp || $(<$fastfetch_stamp) != $boot_time ]]; then
    print -r -- "$boot_time" > "$fastfetch_stamp"
    fastfetch
  fi
  unset fastfetch_stamp boot_time
fi

