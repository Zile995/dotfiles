copybuffer() {
  (( $+commands[wl-copy] || $+commands[xclip] )) || return 1
  (( $+WAYLAND_DISPLAY && $+commands[wl-copy] )) && wl-copy -n <<< $BUFFER
  (( $+DISPLAY && $+commands[xclip] )) && xclip -r -in -sel c <<< $BUFFER
}

zle -N copybuffer

() {
  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^O' copybuffer
  done
}
