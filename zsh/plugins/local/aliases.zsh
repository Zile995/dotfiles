# Aliases

# cp, mv, mkdir
alias cp='cp -v'
alias mv='mv -v'
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

# eza or ls with colors
(( $+commands[eza] )) && 256_colors && {
  alias eza='eza --color=auto --icons=always'
  alias exa='eza'
  alias ls='eza'
  alias l.='eza -d .*(N)'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
} || {
  alias ls='ls --color=tty'
  alias l.='ls -d .*(N)'
  alias ll='ls -lh'
  alias la='ls -lAh'
}

# systemctl soft-reboot
(( $+commands[systemctl] )) && {
  alias sreboot='systemctl soft-reboot'
  alias freboot='systemctl reboot --firmware-setup'
  (( $+commands[pipewire-pulse] )) && (( $+commands[wireplumber] )) &&
    alias pwreset='systemctl --user restart wireplumber pipewire pipewire-pulse'
}

# Update Pacman, AUR and Flatpak packages
(( $+commands[yay] && $+commands[flatpak] )) && alias update='yay && flatpak update'

# Colorize pactree by default
(( $+commands[pactree] )) && alias pactree='pactree -c'

# git diff alias
(( $+commands[git] )) && {
  alias gd='git diff'
  alias gst='git status'
  (( $+commands[delta] )) && alias gdd='git diff | delta'
}

# Use delta with git diff
(( $+commands[git] && $+commands[delta] )) && alias gdd='git diff | delta'

# Reset all pacman keys
(( $+commands[pacman] )) &&
  alias resetkeys='sudo zsh -c "rm -rf /etc/pacman.d/gnupg; pacman-key --init; pacman-key --populate"'

# Update all Arch mirrors
(( $+commands[pacman] && $+commands[reflector] )) &&
  alias updatemirrors='sudo reflector --verbose --protocol https --score 10 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist'

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

# Global loop aliases
alias -g FORI='| while read i ; do '
alias -g IROF='; done '

# Gloval clipboard alias
(( $+WAYLAND_DISPLAY && $+commands[wl-copy] )) && alias -g CC='| wl-copy -n' || {
  (( $+DISPLAY && $+commands[xclip] )) && alias -g CC='| xclip -r -in -sel c'
}
