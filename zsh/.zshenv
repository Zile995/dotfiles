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
  [[ ! -r ${antidote_path}/antidote.zsh ]] && {
    antidote_path="${ZDOTDIR}/.antidote"
  	[[ ! -r ${antidote_path}/antidote.zsh ]] && (( $+commands[git] )) &&
      git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_path"
  }

  # Add functions paths
  fpath=(
    ${ZDOTDIR}/functions
    ${ZDOTDIR}/completions
    ${antidote_path}/functions
    $fpath
  )
}
