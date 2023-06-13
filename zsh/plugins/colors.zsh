# Autoload colors
autoload -U colors && colors

# Define LS_COLORS via dircolors
source <(dircolors -b)

() {
  local grc_plugin="/etc/grc.zsh"
  if [[ -e $grc_plugin ]]; then
    source "$grc_plugin" <$TTY
    unset -f ls
    unset -f journalctl
  fi
}
