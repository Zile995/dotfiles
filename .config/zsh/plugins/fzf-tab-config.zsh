# fzf-tab configuration
zstyle ':fzf-tab:*' print-query alt-p
zstyle ':fzf-tab:*' accept-line alt-enter
zstyle ':fzf-tab:*' fzf-bindings 'enter:accept'
zstyle ':fzf-tab:*' continuous-trigger 'alt-right'

# fzf-tab single group
zstyle ':fzf-tab:*' single-group color

# fzf-tab preview configuration
# tld, cd, exa and systemctl
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:(cd|exa):*' fzf-preview 'exa -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:systemctl-(status|(re|)start|(dis|en)able):*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Kill and ps
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview \
       '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# Git diff, log, describe, help and show
zstyle ':fzf-tab:complete:git-diff:*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle 'fzf-tab:complete:git-describe:argument-rest' fzf-preview 'git describe $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	  "commit tag") git show --color=always $word ;;
	  *) git show --color=always $word | delta ;;
	esac'
