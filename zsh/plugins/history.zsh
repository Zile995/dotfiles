# Zsh history
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt HIST_VERIFY               # Show command with history expansion to user before running it
setopt SHARE_HISTORY             # Share history between all sessions.
setopt EXTENDED_HISTORY          # Record timestamp of command in HISTFILE
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
