# Set autoloading functions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -U select-word-style && select-word-style bash

# Rehash
TRAPUSR1() { rehash }

# Keybindings
bindkey "^H" backward-kill-word

# Aliases
alias exa='exa --color=auto --icons'

# Functions
cleanup() {
  yes | yay -Ycc
  { pacman -Qttdq | sudo pacman -Rnsu --noconfirm - } 2>/dev/null; yes | yay -Scc
  flatpak uninstall --unused --assumeyes
  sudo journalctl --rotate && sudo journalctl --vacuum-time=1d
  { sudo rm -rf /var/lib/systemd/coredump/* } > /dev/null 2>&1
}

# Zsh History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt HIST_VERIFY               # Show command with history expansion to user before running it
setopt SHARE_HISTORY             # Share history between all sessions.
setopt EXTENDED_HISTORY          # Record timestamp of command in HISTFILE
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.

# Zsh options
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
setopt NO_AUTO_REMOVE_SLASH

# Configure zsh syntax highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets line root)

# Zstyle fzf-tab
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' continuous-trigger 'space'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
#zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always --icons $realpath'

# Zstyle completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Load antidote
source '/usr/share/zsh-antidote/antidote.zsh'
antidote load
