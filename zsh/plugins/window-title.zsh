autoload -Uz add-zsh-hook

set-title() {
  local title=$1
  shift
  print -Prnv title -- $title
  printf -v title '\e]0;%s\a' "${(V)title}"
  print -Pn -- $title >$TTY
}

title-precmd() {
  local title="%2~"
  if [[ -n $SSH_CONNECTON || $P9K_SSH == 1 ]]; then
    set-title "%n@%m: $title"
  else
    set-title "$title"
  fi
}

title-preexec() {
  local title="%2~"
  if [[ -n $SSH_CONNECTON || $P9K_SSH == 1 ]]; then
    set-title "%n@%m: $title - ${1//\%/%%}"
  else
    set-title "$title - ${1//\%/%%}"
  fi
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd  title-precmd
  add-zsh-hook -Uz preexec title-preexec
fi
