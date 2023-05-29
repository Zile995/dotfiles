# Autoload colors
autoload -U colors && colors

# Define LS_COLORS via dircolors
source <(dircolors -b)

# Set ls, grep and exa colors
alias ls='ls --color=tty'
alias exa='exa --color=auto --icons'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
