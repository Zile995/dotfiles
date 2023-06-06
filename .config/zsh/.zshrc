# Load antidote
fpath+=(/usr/share/zsh-antidote/functions)
autoload -Uz antidote

# Set the name of plugins file
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins

# Create the .zsh_plugins if it doesn't exist
[[ -f ${zsh_plugins:r} ]] || touch ${zsh_plugins:r}

# Generate and source static plugins file
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins} ]]; then
  (antidote bundle <${zsh_plugins} >${zsh_plugins}.zsh)
fi
source ${zsh_plugins}.zsh

# Load zstyles
[[ -r $ZDOTDIR/.zstyles ]] && . $ZDOTDIR/.zstyles

# Rehash
TRAPUSR1() { rehash }

# Aliases
alias ll='exa --long --all --group-directories-first --git'

# Exports
#export EDITOR='nvim'
export EDITOR='nano'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

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
