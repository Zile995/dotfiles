# Aliases

# dd with progress
alias dd='dd status=progress'

# Better lsblk defaults
alias lsblk='lsblk -o +fstype,label,uuid,model'

# ls and cat
alias ls='ls --color=tty'
if (( $+commands[bat] )); then alias cat='bat -pp'; fi

# exa with icons and colors
if (( $+commands[exa] )); then 
  alias exa='exa --color=auto --icons'
  alias ll='exa --long --all --group-directories-first --git'
fi

# grep with colors
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# Write all cached data to disk and free slab objects and pagecache
alias clearcaches='sudo sync && echo 3 | sudo tee -a /proc/sys/vm/drop_caches 1> /dev/null'
