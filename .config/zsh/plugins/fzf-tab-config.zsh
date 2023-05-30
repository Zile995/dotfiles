# fzf-tab configuration
zstyle ':fzf-tab:*' print-query alt-p
zstyle ':fzf-tab:*' accept-line alt-enter
zstyle ':fzf-tab:*' fzf-bindings 'enter:accept'
zstyle ':fzf-tab:*' continuous-trigger 'alt-right'

# fzf-tab preview configuration
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:(cd|exa):*' fzf-preview 'exa -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:systemctl-(status|(re|)start|(dis|en)able):*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Kill and ps
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview \
       '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
