() {
  (( $+commands[fzf] )) || return 1

  export FZF_TMUX_HEIGHT='50%'
  export FZF_DEFAULT_OPTS="
    --cycle
    --height=50%
    --bind=btab:up,tab:down,change:top
    --bind=ctrl-a:toggle-all,ctrl-space:toggle-out
    --bind=ctrl-h:backward-kill-word,ctrl-k:kill-line,ctrl-u:clear-query
    --bind=alt-j:clear-query,alt-k:unix-line-discard
    --prompt='∼ ' --pointer='▶' --marker='✓'
    --color=fg:-1,bg:-1,hl:#b83b3b
    --color=fg+:#ffffff,bg+:#2b2b2b,hl+:#ff5757
    --color=pointer:#4b87c2,prompt:#72cc98
    --color=marker:#a0dbca,spinner:#6fb375,header:#72cc98
  "

  (( $+commands[fd] )) || return 

  local command="fd --hidden --exclude={.git,.hg,.svn}"

  # Set default commands. Use fd instead of the default find.
  export FZF_ALT_C_COMMAND="$command --type d"
  export FZF_DEFAULT_COMMAND="$command --type f"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Use fd for listing path candidates.
  _fzf_compgen_dir() { eval $FZF_ALT_C_COMMAND . "$1" }

  # Use fd to generate the list for directory completion.
  _fzf_compgen_path() { eval $FZF_DEFAULT_COMMAND . "$1" }
}

# Open selected dir in file manager.
fzf-xdg-dir() {
  local exa_preview
  local bat_preview
  (( $+commands[exa] )) && exa_preview="[[ -f {} ]] || exa -1 --icons {}"
  (( $+commands[bat] )) && bat_preview="[[ -d {} ]] || bat --color=always {}"

  setopt localoptions pipefail no_aliases 2> /dev/null

  eval $FZF_ALT_C_COMMAND |
  fzf \
  --reverse \
  --height 70% \
  --query=${LBUFFER} \
  --preview=$exa_preview \
  --prompt "Directories ❯ " \
  --header "CTRL-D: Directories / CTRL-F: Files" \
  --bind "enter:execute-silent(xdg-open {} & disown)" \
  --bind "ctrl-f:change-prompt(Files ❯ )+reload($FZF_DEFAULT_COMMAND)+change-preview($bat_preview)+change-preview-window(70%,top,border-bottom)" \
  --bind "ctrl-d:change-prompt(Directories ❯ )+reload($FZF_ALT_C_COMMAND)+change-preview($exa_preview)+change-preview-window("")"

  zle .reset-prompt && zle -R
}

() {
  builtin local keymap

  zle -N fzf-xdg-dir

  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^[i' fzf-xdg-dir
  done
}
