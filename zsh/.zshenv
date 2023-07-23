ZDOTDIR=$HOME/.config/zsh

# Exports
(( $+commands[nano] )) && export EDITOR=nano

(( $+commands[bat] )) && { 
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
}

# Ensure fpath array does not contain duplicates
typeset -gU fpath

# Add functions paths
fpath=(
  $ZDOTDIR/functions
  /usr/share/zsh-antidote/functions
  $fpath
)
