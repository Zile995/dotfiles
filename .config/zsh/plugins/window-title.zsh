autoload -Uz add-zsh-hook

title-precmd() {
  'builtin' 'emulate' -LR zsh
  local title=$(print -P "%2~")
  'builtin' 'echo' -ne "\033]0;$title\007" >$TTY
}

title-preexec() {
  'builtin' 'emulate' -LR zsh
  local title=$(print -P "%2~ - ${(q)1}\a")
  'builtin' 'echo' -ne "\033]0;$title\007" >$TTY
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd title-precmd
  add-zsh-hook -Uz preexec title-preexec
fi
