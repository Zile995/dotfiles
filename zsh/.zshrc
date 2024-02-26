# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load zstyles
[[ -r ${ZDOTDIR}/.zstyles ]] && source ${ZDOTDIR}/.zstyles

# Autoload functions
autoload -Uz antidote ${ZDOTDIR}/functions/*

# Initialize remote plugins
antidote load

# ZSH syntax highlighting and history substring search
[[ -n $WAYLAND_DISPLAY || -n $DISPLAY || $PREFIX == *"com.termux"* ]] && {
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=23,fg=79,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=1,fg=217,bold'
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
