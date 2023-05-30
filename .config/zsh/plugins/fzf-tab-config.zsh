# fzf-tab configuration
zstyle ':fzf-tab:*' print-query alt-p
zstyle ':fzf-tab:*' accept-line alt-enter
zstyle ':fzf-tab:*' fzf-bindings 'enter:accept'
zstyle ':fzf-tab:*' continuous-trigger 'alt-right'

# fzf preview configuration
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:(cd|exa):*' fzf-preview 'exa -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
