autoload -Uz add-zsh-hook

set-title() {
  emulate -L zsh -o no_prompt_bang -o prompt_subst -o prompt_percent -o no_prompt_subst
  local title=$1
  print -Prnv title -- $title
  print -Pn -- "\e]0;${title}\a" >$TTY
}

title-precmd() {
  local title="%2~"
  if [[ -n $SSH_CONNECTON || $P9K_SSH == 1 ]]; then
    set-title "%n@%m: $title"
  else
    set-title "$title"
  fi
  printf "\e]7;file://%s%s\e\\" "$PWD" >$TTY
}

title-preexec() {
  local title="${1//\%/%%}"
  if [[ -n $SSH_CONNECTON || $P9K_SSH == 1 ]]; then
    set-title "%n@%m: $title"
  else
    set-title "$title"
  fi
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd  title-precmd
  add-zsh-hook -Uz preexec title-preexec
fi
