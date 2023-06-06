# Load zsh completion 
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs false

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:complete:*:options' sort false

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format "${fg_bold[green]}[%d]%{$reset_color%}"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
