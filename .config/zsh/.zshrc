# Set autoloading functions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -U select-word-style && select-word-style bash

# Load antidote
source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

# Rehash
TRAPUSR1() { rehash }

# Aliases
alias ll='exa --long --all --group-directories-first --git'

# Exports
#export EDITOR='nvim'
export EDITOR='nano'

# Functions
cleanup() {
  yes | yay -Ycc
  { pacman -Qttdq | sudo pacman -Rnsu --noconfirm - } 2>/dev/null; yes | yay -Scc
  flatpak uninstall --unused --assumeyes
  sudo journalctl --rotate && sudo journalctl --vacuum-time=1d
  { sudo rm -rf /var/lib/systemd/coredump/* } > /dev/null 2>&1
}

# Zsh options
setopt AUTO_CD
setopt C_BASES
setopt CORRECT
setopt MULTIOS
setopt GLOB_DOTS
setopt NO_BG_NICE
setopt ALWAYS_TO_END
setopt NO_LIST_TYPES
setopt TYPESET_SILENT
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt NO_AUTO_REMOVE_SLASH

# Zsh syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets line root)

# Zstyle fzf-tab
zstyle ':fzf-tab:*' print-query alt-p
zstyle ':fzf-tab:*' accept-line alt-enter
zstyle ':fzf-tab:*' fzf-bindings 'enter:accept'
zstyle ':fzf-tab:*' continuous-trigger 'alt-right'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Zstyle completion
zstyle ':completion:*' special-dirs false
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
