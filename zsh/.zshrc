# Enable Powerlevel10k instant prompt
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] &&
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Load zstyles
[[ -r ${ZDOTDIR}/.zstyles ]] && source ${ZDOTDIR}/.zstyles

# Autoload functions
autoload -Uz antidote ${ZDOTDIR}/functions/*

# Load plugins
antidote load

256_colors && {
  # Set zsh syntax highlighting and history substring search colors
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=23,fg=79,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=1,fg=217,bold' 

  # Source the p10k prompt
  [[ ! -f ${ZPROMPTDIR}/.p10k.zsh ]] || source ${ZPROMPTDIR}/.p10k.zsh
} || {
  [[ ! -f ${ZPROMPTDIR}/.p10k-portable.zsh ]] || source ${ZPROMPTDIR}/.p10k-portable.zsh
}
