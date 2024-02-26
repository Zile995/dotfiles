set_key_opts() {
  local bat_preview
  (( $+commands[bat] )) && bat_preview=" | bat -l bash --color always -pp --wrap=character"

  export FZF_CTRL_R_OPTS="--preview 'echo {}$bat_preview' --preview-window down:5:hidden:wrap"
  (( $+commands[eza] )) && export FZF_ALT_C_OPTS="--preview 'eza -1 --icons {}'"
  (( $+commands[bat] )) && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"

  (( $+commands[wl-copy] || $+commands[xclip] )) || return 1

  export FZF_CTRL_R_OPTS="$FZF_CTRL_R_OPTS
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
    --bind ctrl-/:toggle-preview
    --bind bs:backward-delete-char/eof
    --bind btab:up,tab:down,change:top
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
  local base_dir="$1"
  local key_bindings_files=(
    "${base_dir}/key-bindings.zsh"
    "${base_dir}/_fzf_key_bindings"
    "/etc/zsh_completion.d/fzf-key-bindings"
  )

  for key_bindings in ${key_bindings_files}; do
    if [[ -r $key_bindings ]]; then
      source "$key_bindings" 2>/dev/null
      break
    fi
  done
}

load_completion() {
  local base_dir="$1"
  local completion_files=(
    "${base_dir}/completion.zsh"
    "${base_dir}/_fzf_completion"
    "${base_dir}/site-functions/_fzf"
    "${base_dir}/vendor-completions/_fzf"
  )

  for completion_file in ${completion_files}; do
    if [[ -r $completion_file ]]; then
      source "$completion_file" 2>/dev/null
      break
    fi
  done
}

fzf-ctrl-z() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  local current_jobs=("${(@f)$(jobs -l)}")
  [[ ! -n $current_jobs ]] && return 1

  if [[ ${#current_jobs} -gt 1 ]]; then
    local selected_job=$( \
      printf "%s\n" "${current_jobs[@]}" |
      fzf \
      --reverse \
      --bind "ctrl-z:accept" \
      --header "CTRL-Z/ENTER: Run job in the foreground" \
      --prompt="  Search jobs ❯ " |
      awk '{ print $1 }' |
      tr -d '[]' \
    )
    [[ -n $selected_job ]] && { BUFFER="fg %$selected_job"; zle accept-line -w }
  else
    BUFFER="fg" && zle accept-line -w
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

fzf-xdg-widget() {
  (( $+commands[eza] || $+commands[bat] )) || return 1

  setopt localoptions pipefail no_aliases 2> /dev/null

  local selected_item eza_preview bat_preview copy_command

  local INITIAL_QUERY="${*:-}"
  local tmp_file="/tmp/fzf-should-print"
  local header_text="CTRL-D: Directories / CTRL-F: Files\nCTRL-O: Copy the path / ALT-O: XDG Open / ALT-P: Print selected"

  eza_preview="[[ -f {} ]] || eza -1 --icons {}"
  bat_preview="[[ -d {} ]] || bat --color=always {}"
  (( $+commands[wl-copy] || $+commands[xclip] )) &&
    copy_command="printf '%q' $(printf '%q' $PWD)/{} | { wl-copy -n || xclip -r -in -sel c }"

  selected_item=$( \
  : | fzf \
    --reverse \
    --keep-right \
    --height "70%" \
    --preview "$eza_preview" \
    --query "$INITIAL_QUERY" \
    --prompt "󰉋  Directories ❯ " \
    --header "$(echo -e $header_text)" \
    --bind "start:reload($FZF_ALT_C_COMMAND)" \
    --bind "alt-p:execute-silent(echo 1 > $tmp_file)+accept" \
    --bind "alt-o:execute-silent(xdg-open {} & disown)" \
    --bind "ctrl-o:execute-silent($copy_command)+abort" \
    --bind "ctrl-f:change-prompt(  Files ❯ )+reload($FZF_DEFAULT_COMMAND)+change-preview($bat_preview)" \
    --bind "ctrl-d:change-prompt(󰉋  Directories ❯ )+reload($FZF_ALT_C_COMMAND)+change-preview($eza_preview)" \
  )

  [[ -r $tmp_file ]] && local should_print=$('cat' $tmp_file)

  if [ "$should_print" -eq 1 ]; then
    LBUFFER+="${(q)selected_item}"
    rm -f "$tmp_file"
  else
    { [[ -d $selected_item ]] && cd "$selected_item" && redraw_prompt 1 } && return 1 || \
      { [[ -f $selected_item ]] && $EDITOR "$selected_item" <$TTY }
  fi

  redraw_prompt
}

fzf-package-install() {
  (( $+commands[yay] && $+commands[pacman] )) || return 1

  setopt localoptions pipefail no_aliases 2> /dev/null

  local preview="yay -Si {1}"
  local yay_search="yay -Salq"
  local pacman_search="pacman -Slq"

  local logo="󰣇"
  local prompt_text="Search the packages ❯ "
  local header_text="[󱧕 Install the packages]\n[F1]: Official / [F2]: AUR"

  : | fzf \
    --multi \
    --reverse \
    --height "70%" \
    --preview "$preview" \
    --query "$LBUFFER" \
    --prompt "$logo [Official] $prompt_text" \
    --header "$(echo -e $header_text)" \
    --bind "start:reload($pacman_search)" \
    --bind "f2:change-prompt($logo [AUR] $prompt_text)+reload($yay_search)" \
    --bind "f1:change-prompt($logo [Official] $prompt_text)+reload($pacman_search)" | xargs -ro yay -S

  redraw_prompt
}

fzf-package-remove() {
  (( $+commands[pacman] )) || return 1

  setopt localoptions pipefail no_aliases 2> /dev/null

  local preview="pacman -Qi {1}"
  local pacman_search="pacman -Qq"

  : | fzf \
    --multi \
    --reverse \
    --height "70%" \
    --query "$LBUFFER" \
    --preview "$preview" \
    --header "[󱧖 Remove the packages]" \
    --prompt "󰣇 Search the packages ❯ " \
    --bind "start:reload($pacman_search)" | xargs -ro sudo pacman -Rns

  redraw_prompt
}

() {
  (( $+commands[fzf] )) || return 1

  local fzf_base

  case $PREFIX in
    *com.termux*)
      fzf_base="${PREFIX}/share/fzf"
      ;;
    *)
      local -a fzf_dirs=(
        "/usr/share/fzf"
        "/usr/local/opt/fzf"
        "/usr/local/share/zsh"
        "/usr/share/doc/fzf/examples"
        "/usr/local/share/examples/fzf"
        "${HOME}/.fzf"
        "${HOME}/.nix-profile/share/fzf"
        "${XDG_DATA_HOME:-$HOME/.local/share}/fzf"
      )

      for dir in ${fzf_dirs}; do
        if [[ -d $dir ]]; then fzf_base="$dir"; break; fi
      done
      ;;
  esac

  set_opts
  [[ -n $fzf_base ]] && {
    load_completion "$fzf_base"
    load_key_bindings "$fzf_base"
  }

  zle -N fzf-ctrl-z
  zle -N fzf-xdg-widget
  zle -N fzf-text-search
  zle -N fzf-package-remove
  zle -N fzf-package-install

  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^Z'      fzf-ctrl-z
    bindkey -M "$keymap" '^[f'     fzf-text-search
    bindkey -M "$keymap" '^[^[[B'  fzf-xdg-widget
    bindkey -M "$keymap" '^[[1;3B' fzf-xdg-widget
    bindkey -M "$keymap" '^[[1;9B' fzf-xdg-widget
    bindkey -M "$keymap" '^[r'     fzf-package-remove
    bindkey -M "$keymap" '^[i'     fzf-package-install
  done

  unfunction set_opts load_completion load_key_bindings
}
