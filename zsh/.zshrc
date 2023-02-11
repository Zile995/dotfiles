# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set autoloading functions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -U select-word-style && select-word-style bash

# Rehash
TRAPUSR1() { rehash }

# Zstyle fzf-tab
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' continuous-trigger 'space'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
#zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always --icons $realpath'

# Zstyle completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Keybindings
bindkey "^H" backward-kill-word

# Configure zsh syntax highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets line root)

# Load antidote
source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
