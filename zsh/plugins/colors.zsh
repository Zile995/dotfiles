# Autoload colors
autoload -U colors && colors

# Define LS_COLORS
(( $+commands[dircolors] )) && source <(dircolors -b) || {
  export LS_COLORS='fi=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:'
  LS_COLORS+='pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32'
}

() {
  local grc_plugin="/etc/grc.zsh"
  if [[ -e $grc_plugin ]]; then
    source "$grc_plugin" <$TTY
    unset -f ls
    unset -f journalctl
  fi
}
