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

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'

alias lg='lazygit'

alias g='git'
alias ga="git add"
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gs='git status -s'
alias gsh='git show'
alias gsw='git switch'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcl='git clone'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gl='git log'
alias gla='git log --oneline --graph --decorate --all'
alias gls='git log --stat'
alias glo='git log --oneline'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'

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

