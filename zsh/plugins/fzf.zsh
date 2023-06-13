if (( $+commands[fzf] )); then
  # Set tmux height
  export FZF_TMUX_HEIGHT='50%'

  if (( $+commands[fd] )); then
    # Set default commands. Use fd instead of the default find.
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude={.git,.hg,.svn}'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude={.git,.hg,.svn}'

    # Use fd for listing path candidates.
    _fzf_compgen_dir() { fd --type d --hidden --exclude={.git,.hg,.svn} . "$1" }

    # Use fd to generate the list for directory completion.
    _fzf_compgen_path() { fd --type f --hidden --exclude={.git,.hg,.svn} . "$1" }
  fi
fi

# Open selected dir in file manager. 
fzf-xdg-dir() { 
  if (( $+commands[fd] && $+commands[fzf] && $+commands[exa] )); then
    local selected_dir=$( \
      $(echo $FZF_ALT_C_COMMAND) | \
      fzf \
      --reverse \
      --height 60% \
      --query=${LBUFFER} \
      --preview 'exa -1 --icons {}' \
    )

    if [ -n "$selected_dir" ]; then
      (xdg-open "$selected_dir" & disown &>/dev/null)
    fi

    zle .reset-prompt && zle -R
  fi
}

zle -N fzf-xdg-dir

() {
  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^[i' fzf-xdg-dir
  done
}
