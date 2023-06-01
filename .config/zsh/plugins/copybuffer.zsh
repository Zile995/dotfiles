copybuffer() {
  if (($+WAYLAND_DISPLAY && $+commands[wl-copy])); then
    wl-copy -n <<< $BUFFER
  elif (($+DISPLAY && $+commands[xsel])); then
    xsel --clipboard --input <<< $BUFFER
  fi
}

zle -N copybuffer
bindkey '^O' copybuffer
