copybuffer() {
  if (($+WAYLAND_DISPLAY && $+commands[wl-copy])); then
    wl-copy -n <<< $BUFFER
  elif (($+DISPLAY && $+commands[xclip])); then
    xclip -r -in -sel c <<< $BUFFER
  fi
}

zle -N copybuffer

() {
  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^O' copybuffer
  done
}
