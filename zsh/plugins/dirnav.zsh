redraw-prompt() {
  {
    builtin echoti civis
    builtin local f
    for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
      (( ! ${+functions[$f]} )) || "$f" &>/dev/null || builtin true
    done
    builtin zle reset-prompt
  } always {
    builtin echoti cnorm
  }
}

cd-rotate() {
  () {
    builtin emulate -L zsh
    while (( $#dirstack )) && ! builtin pushd -q $1 &>/dev/null; do
      builtin popd -q $1
    done
    (( $#dirstack ))
  } "$@" && redraw-prompt
}

cd-up()      { builtin cd -q .. && redraw-prompt; }
cd-back()    { cd-rotate +1; }
cd-forward() { cd-rotate -0; }

builtin zle -N cd-up
builtin zle -N cd-back
builtin zle -N cd-forward

() {
  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    builtin bindkey -M "$keymap" '^[^[[A'  cd-up
    builtin bindkey -M "$keymap" '^[[1;3A' cd-up
    builtin bindkey -M "$keymap" '^[[1;9A' cd-up
    builtin bindkey -M "$keymap" '^[^[[D'  cd-back
    builtin bindkey -M "$keymap" '^[[1;3D' cd-back
    builtin bindkey -M "$keymap" '^[[1;9D' cd-back
    builtin bindkey -M "$keymap" '^[^[[C'  cd-forward
    builtin bindkey -M "$keymap" '^[[1;3C' cd-forward
    builtin bindkey -M "$keymap" '^[[1;9C' cd-forward
  done
}

setopt AUTO_PUSHD
