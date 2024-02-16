ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

# Exports
(( $+commands[nano] )) && export EDITOR=nano

(( $+commands[bat] )) && { 
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
}

() {
  # Ensure fpath array does not contain duplicates
  typeset -gU fpath

  local antidote_path=/usr/share/zsh-antidote
  [[ ! -d $antidote_path ]] &&
    antidote_path="${ZDOTDIR}/.antidote"

  [[ ! -d $antidote_path ]] && (( $+commands[git] )) &&
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_path"

  local antidote_fpath="${antidote_path}/functions"

  # Add functions paths
  fpath=(
    $antidote_fpath
    $ZDOTDIR/functions
    $ZDOTDIR/completions
    $fpath
  )
}
