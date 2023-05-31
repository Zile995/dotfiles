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

# Zsh syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets line root)
