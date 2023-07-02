set_key_opts() {
  export FZF_CTRL_R_OPTS="--preview 'echo {} | bat -l bash --color always -pp --wrap=character' --preview-window down:5:hidden:wrap"
  (( $+commands[exa] )) && export FZF_ALT_C_OPTS="--preview 'exa -1 --icons {}'"
  (( $+commands[bat] )) && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"

  (( $+commands[wl-copy] || $+commands[xclip] )) || return 1

  export FZF_CTRL_R_OPTS=$FZF_CTRL_R_OPTS"
    --bind 'ctrl-o:execute-silent(echo -n {2..} | { wl-copy -n || xclip -r -in -sel c })+abort'
    --header 'Press CTRL-O to copy command into clipboard'
  "
}

set_command_opts() {
  (( $+commands[fd] )) || return 1

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

set_opts() {
  set_key_opts
  set_command_opts

  export FZF_TMUX_HEIGHT="50%"
  export FZF_DEFAULT_OPTS="
    --cycle
    --height 50%
    --bind ctrl-z:ignore
    --bind btab:up,tab:down,change:top
    --bind ctrl-/:toggle-preview
    --bind ctrl-a:toggle-all,ctrl-space:toggle-out
    --bind ctrl-h:backward-kill-word,ctrl-k:kill-line,ctrl-u:clear-query
    --bind alt-j:clear-query,alt-k:unix-line-discard
    --prompt '❯ ' --pointer '▶' --marker '✓'
    --color fg:-1,bg:-1,hl:#d49c2d
    --color fg+:#ffffff,bg+:#2b2b2b,hl+:#ffcc66
    --color info:#789cc2,pointer:#6095d1,prompt:#6ba3a3
    --color marker:#a0dbca,spinner:#6fb375,header:#9c8db8:italic
  "

  unfunction set_key_opts set_command_opts
}

load_key_bindings() {
  local key_bindings_file="/usr/share/fzf/key-bindings.zsh"
  # Source the key-bindings.zsh file
  [[ -e $key_bindings_file ]] && source "$key_bindings_file"
}

# Load fzf completion
load_completion() {
  local completion_file="/usr/share/fzf/completion.zsh"
  [[ -e $completion_file ]] && source "$completion_file"
}

() {
  (( $+commands[fzf] )) || return 1
  set_opts
  load_completion
  load_key_bindings
  unfunction set_opts load_completion load_key_bindings
}

fzf-xdg-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  local exa_preview bat_preview copy_command

  local should_print=0
  local INITIAL_QUERY="${*:-}"
  local tmp_file="/tmp/fzf-should-print"
  local header_text="CTRL-D: Directories / CTRL-F: Files\nCTRL-O: Copy the path / ALT-O: XDG Open / ALT-P: Print selected"

  (( $+commands[exa] )) && exa_preview="[[ -f {} ]] || exa -1 --icons {}"
  (( $+commands[bat] )) && bat_preview="[[ -d {} ]] || bat --color=always {}"
  (( $+commands[wl-copy] || $+commands[xclip] )) &&
     copy_command="printf '%q' $(printf '%q' $PWD)/{} | { wl-copy -n || xclip -r -in -sel c }"

  local selected_item=$( \
  : | fzf \
    --reverse \
    --keep-right \
    --height "70%" \
    --preview $exa_preview \
    --query "$INITIAL_QUERY" \
    --prompt "🖿  Directories ❯ " \
    --header "$(echo -e $header_text)" \
    --bind "start:reload($FZF_ALT_C_COMMAND)" \
    --bind "alt-p:execute-silent(echo 1 > $tmp_file)+accept" \
    --bind "alt-o:execute-silent(xdg-open {} & disown)" \
    --bind "ctrl-o:execute-silent($copy_command)+abort" \
    --bind "ctrl-f:change-prompt(  Files ❯ )+reload($FZF_DEFAULT_COMMAND)+change-preview($bat_preview)" \
    --bind "ctrl-d:change-prompt(🖿  Directories ❯ )+reload($FZF_ALT_C_COMMAND)+change-preview($exa_preview)" \
  )

  [[ -e "$tmp_file" ]] && should_print=$('cat' $tmp_file)

  if [ "$should_print" -eq 1 ]; then
    LBUFFER+="${(q)selected_item}"
    rm -f $tmp_file
  else
    { [[ -d "$selected_item" ]] && cd "$selected_item" && redraw_prompt 1 } \
      || { [[ -f "$selected_item" ]] && $EDITOR "$selected_item" <$TTY && redraw_prompt } \
      || redraw_prompt
  fi

  redraw_prompt
}

fzf-text-search() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  (( $+commands[bat] && $+commands[rg] )) || return 1

  local INITIAL_QUERY="${*:-}"
  local search_text="Search text"
  local filter_items="Filter search items"
  local RG_PREFIX="rg --column --color=always --line-number --no-heading --smart-case {q} | head -n 10000"

  rm -f /tmp/rg-fzf-{r,f}
  : | fzf \
      --delimiter : \
      --height "60%" \
      --prompt "$search_text ❯ " \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --color "hl:underline,hl+:underline:reverse" \
      --header "CTRL-R: $search_text / CTRL-F: $filter_items" \
      --bind 'enter:become($EDITOR +{2} {1})' \
      --bind "start:reload($RG_PREFIX)+unbind(ctrl-r)" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt($filter_items ❯ )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
      --bind "ctrl-r:unbind(ctrl-r)+change-prompt($search_text ❯ )+disable-search+reload($RG_PREFIX || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'

  redraw_prompt
}

() {
  zle -N fzf-xdg-widget
  zle -N fzf-text-search

  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^[^[[B'  fzf-xdg-widget
    bindkey -M "$keymap" '^[[1;3B' fzf-xdg-widget
    bindkey -M "$keymap" '^[[1;9B' fzf-xdg-widget
    bindkey -M "$keymap" '^[f' fzf-text-search
  done
}
