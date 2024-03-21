set_key_opts() {
  local bat_preview
  (( $+commands[bat] )) && bat_preview=' | bat -l bash --color always -pp --wrap=character'

  export FZF_CTRL_R_OPTS="--preview 'echo {}$bat_preview' --preview-window down:5:hidden:wrap"
  (( $+commands[eza] )) && export FZF_ALT_C_OPTS="--preview 'eza -1 --icons --color=always -- {}'"
  (( $+commands[bat] )) && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always -- {}'"

  (( $+commands[wl-copy] || $+commands[xclip] )) || return

  export FZF_CTRL_R_OPTS="$FZF_CTRL_R_OPTS
    --bind 'ctrl-o:execute-silent(echo -n {2..} | { wl-copy -n || xclip -r -in -sel c })+abort'
    --header 'Press CTRL-O to copy command into clipboard'
  "
}

set_command_opts() {
  (( $+commands[fd] )) || return

  local command='fd --hidden --exclude={.git,.hg,.svn}'

  # Set default commands. Use fd instead of the default find.
  export FZF_ALT_C_COMMAND="$command --type d"
  export FZF_DEFAULT_COMMAND="$command --type f"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Use fd for listing path candidates.
  _fzf_compgen_dir() {
    local command="$FZF_ALT_C_COMMAND"
    eval "$command" . "$1"
   }

  # Use fd to generate the list for directory completion.
  _fzf_compgen_path() {
    local command="$FZF_DEFAULT_COMMAND"
    eval "$command" . "$1"
  }
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

load_fzf() {
  set_opts

  local fzf_version="${$(fzf --version)%.*}"
  (( ${fzf_version//./} >= 048 )) && eval "$(fzf --zsh)" && return

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
        [[ -d $dir ]] && fzf_base="$dir"; break
      done
      ;;
  esac

  [[ -z $fzf_base ]] || {
    load_completion "$fzf_base"
    load_key_bindings "$fzf_base"
  }
}

fzf-ctrl-z() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  local current_jobs=("${(@f)$(jobs -l)}")
  [[ -n $current_jobs ]] || return

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
    [[ -z $selected_job ]] || { BUFFER="fg %$selected_job"; zle accept-line -w }
  else
    BUFFER="fg" && zle accept-line -w
  fi

  redraw_prompt
}

fzf-text-search() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  (( $+commands[bat] && $+commands[rg] )) || return

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

fzf-package-install() {
  (( $+commands[yay] && $+commands[pacman] )) || return

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
  (( $+commands[pacman] )) || return

  setopt localoptions pipefail no_aliases 2> /dev/null

  : | fzf \
    --multi \
    --reverse \
    --height "70%" \
    --query "$LBUFFER" \
    --preview "pacman -Qi {1}" \
    --header "[󱧖 Remove the packages]" \
    --prompt "󰣇 Search the packages ❯ " \
    --bind "start:reload(pacman -Qq)" | xargs -ro sudo pacman -Rns

  redraw_prompt
}

() {
  (( $+commands[fzf] )) || return

  load_fzf

  zle -N fzf-ctrl-z
  zle -N fzf-text-search
  zle -N fzf-package-remove
  zle -N fzf-package-install

  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^Z'      fzf-ctrl-z
    bindkey -M "$keymap" '^[f'     fzf-text-search
    bindkey -M "$keymap" '^[r'     fzf-package-remove
    bindkey -M "$keymap" '^[i'     fzf-package-install
  done

  unfunction set_opts load_completion load_key_bindings
}
