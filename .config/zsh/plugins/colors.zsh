# Autoload colors
autoload -U colors && colors

# Define LS_COLORS via dircolors
source <(dircolors -b)

# Set ls, grep, cat and exa colors
alias ls='ls --color=tty'
if (( $+commands[bat] )); then alias cat='bat -pp'; fi
if (( $+commands[exa] )); then alias exa='exa --color=auto --icons'; fi
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

() {
  local grc_plugin="/etc/grc.zsh"
  if [ -f $grc_plugin ]; then
    source "$grc_plugin" <$TTY
    unset -f ls
    unset -f journalctl
  fi
}
