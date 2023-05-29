# Set default commands. Use fd instead of the default find.
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# Use fd for listing path candidates.
_fzf_compgen_dir() { fd --type d --hidden --exclude .git . "$1" }

# Use fd to generate the list for directory completion.
_fzf_compgen_path() { fd --type f --hidden --exclude .git . "$1" }
