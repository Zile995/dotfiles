# Load zstyles
[[ -r $ZDOTDIR/.zstyles ]] && . $ZDOTDIR/.zstyles

# Autoload functions
autoload -Uz antidote $ZDOTDIR/functions/*

# Initialize plugins
antidote load

# Rehash
TRAPUSR1() { rehash }

# Zsh syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets line root)
