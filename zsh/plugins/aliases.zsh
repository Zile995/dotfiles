# Aliases

# ln, cp, mv, mkdir
alias ln='ln -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# df and du
alias df='df -hT'
alias du='du -hs'

# kill, immediately terminate a process
alias kill='kill -9'

# xdg-open, open with the default program
alias xo='xdg-open'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# dd with progress
alias dd='dd status=progress'

# Better lsblk defaults
alias lsblk='lsblk -o +fstype,label,uuid,model'

# cat
(( $+commands[bat] )) && alias cat='bat -pp'

# ping
alias ping='ping -c 4'

# exa or ls with colors
(( $+commands[exa] )) && {
  alias exa='exa --color=auto --icons'
  alias ls='exa'
  alias ll='exa --long --group-directories-first --git'
  alias la='exa --long --all --group-directories-first --git'
} || {
  alias ls='ls --color=tty'
  alias ll='ls -lh'
  alias la='ls -lAh'
}

# Update Pacman, AUR and Flatpak packages
(( $+commands[yay] && $+commands[flatpak] )) && alias update='yay && flatpak update'

# grep with colors
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# Write all cached data to disk and free slab objects and pagecache
alias clearcaches='sudo sync && echo 3 | sudo tee -a /proc/sys/vm/drop_caches 1> /dev/null'

# Global aliases
alias -g H='| head'
alias -g G='| grep'
alias -g L='| less'
alias -g T='| tail'
alias -g W='| wc -l'
alias -g X='| xargs'
alias -g D='& disown'
alias -g NSE='2> /dev/null'
alias -g NSO='> /dev/null 2>&1'

# Global loop alias
alias -g FORI='| while read i ; do '
alias -g IROF='; done '

# Clipboard alias
{ (( $+WAYLAND_DISPLAY && $+commands[wl-copy] )) && alias -g CC='| wl-copy -n' } || {
  (( $+DISPLAY && $+commands[xclip] )) && alias -g CC='| xclip -r -in -sel c' 
}
