# Aliases

# ln, cp, mv, mkdir
alias ln='ln -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# df and du
alias df='df -hT'
alias du='du -hs'

# dd with progress
alias dd='dd status=progress'

# Better lsblk defaults
alias lsblk='lsblk -o +fstype,label,uuid,model'

# ls and cat
alias ls='ls --color=tty'
(( $+commands[bat] )) && alias cat='bat -pp'

# exa with icons and colors
(( $+commands[exa] )) && {
  alias exa='exa --color=auto --icons' &&
  alias ll='exa --long --all --group-directories-first --git'
}

# grep with colors
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# Write all cached data to disk and free slab objects and pagecache
alias clearcaches='sudo sync && echo 3 | sudo tee -a /proc/sys/vm/drop_caches 1> /dev/null'
