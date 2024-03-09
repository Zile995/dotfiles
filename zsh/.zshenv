ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh
ZCACHEDIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
ZPLUGINDIR=${ZDOTDIR}/plugins
ZPROMPTDIR=${ZDOTDIR}/prompts
ZFUNCTIONDIR=${ZDOTDIR}/functions
ZCOMPLETIONDIR=${ZDOTDIR}/completions

# Exports
(( $+commands[nano] )) && export EDITOR=nano

(( $+commands[bat] )) && { 
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
}

export ANTIDOTE_HOME=${ZPLUGINDIR}/remote

() {
  # Ensure fpath array does not contain duplicates
  typeset -gU fpath

  # Create necessary dirs
  [[ ! -d ZCACHEDIR ]]      && mkdir -pv "$ZCACHEDIR"
  [[ ! -d ZPLUGINDIR ]]     && mkdir -pv "$ZPLUGINDIR"
  [[ ! -d ZPROMPTDIR ]]     && mkdir -pv "$ZPROMPTDIR"
  [[ ! -d ZFUNCTIONDIR ]]   && mkdir -pv "$ZFUNCTIONDIR"
  [[ ! -d ZCOMPLETIONDIR ]] && mkdir -pv "$ZCOMPLETIONDIR"

  # Add the antidote path
  local antidote_path=/usr/share/zsh-antidote
  [[ ! -r ${antidote_path}/antidote.zsh ]] && {
    antidote_path=${ZDOTDIR}/.antidote
    [[ ! -r ${antidote_path}/antidote.zsh ]] && (( $+commands[git] )) &&
      git clone --depth=1 https://github.com/mattmc3/antidote.git $antidote_path
  }

  # Add functions paths
  fpath=(
    $ZFUNCTIONDIR
    $ZCOMPLETIONDIR
    ${antidote_path}/functions
    $fpath
  )
}
