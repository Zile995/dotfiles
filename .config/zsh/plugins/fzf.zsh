# Set tmux height
export FZF_TMUX_HEIGHT='50%'

# Set default commands. Use fd instead of the default find.
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# Use fd for listing path candidates.
_fzf_compgen_dir() { fd --type d --hidden --exclude .git . "$1" }

# Use fd to generate the list for directory completion.
_fzf_compgen_path() { fd --type f --hidden --exclude .git . "$1" }

fzf-xdg-dir() { 
  if (( $+commands[fd] )) && (( $+commands[fzf] )) && (( $+commands[exa] )); then
    local selected_dir=$( \
      fd -t d -H -E .git | \
      fzf \
      --reverse \
      --height 60% \
      --scheme=path \
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
bindkey -M emacs '^[i' fzf-xdg-dir
bindkey -M vicmd '^[i' fzf-xdg-dir
bindkey -M viins '^[i' fzf-xdg-dir
