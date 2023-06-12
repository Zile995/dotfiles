autoload -Uz add-zsh-hook

title-precmd () {
  print -Pn -- '\e]2;%2~\a' >$TTY
}

title-preexec () {
  print -Pn -- '\e]2;%2~ - ' && print -n -- "${(q)1}\a" >$TTY
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd title-precmd
  add-zsh-hook -Uz preexec title-preexec
fi
