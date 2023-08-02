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

  local antidote_package_path
  local antidote_zdotdir_path="${ZDOTDIR}/.antidote"
  [[ -e "/usr/share/zsh-antidote" ]] && antidote_package_path="/usr/share/zsh-antidote"
  local antidote_fpath=${antidote_package_path:-$antidote_zdotdir_path}/functions

  # Add functions paths
  fpath=(
    $antidote_fpath
    $ZDOTDIR/functions
    $ZDOTDIR/completions
    $fpath
  )
}
