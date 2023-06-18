typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Alt-Delete]="${terminfo[kDC3]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
key[Control-Delete]="${terminfo[kDC5]}"
key[Control-Backspace]="${terminfo[cub1]}"

# Setup keys accordingly
() {
  builtin local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    bindkey -M "$keymap" '^D'  exit-zsh
    bindkey -M "$keymap" '^L'  clear-screen-and-scrollback
    bindkey -M "$keymap" '^[o' xdg-open-dir
    [[ -n "${key[Home]}"              ]] && bindkey -M "$keymap" "${key[Home]}"              beginning-of-line
    [[ -n "${key[End]}"               ]] && bindkey -M "$keymap" "${key[End]}"               end-of-line
    [[ -n "${key[Insert]}"            ]] && bindkey -M "$keymap" "${key[Insert]}"            overwrite-mode
    [[ -n "${key[Backspace]}"         ]] && bindkey -M "$keymap" "${key[Backspace]}"         backward-delete-char
    [[ -n "${key[Delete]}"            ]] && bindkey -M "$keymap" "${key[Delete]}"            delete-char
    [[ -n "${key[Up]}"                ]] && bindkey -M "$keymap" "${key[Up]}"                up-line-or-beginning-search
    [[ -n "${key[Down]}"              ]] && bindkey -M "$keymap" "${key[Down]}"              down-line-or-beginning-search
    [[ -n "${key[Left]}"              ]] && bindkey -M "$keymap" "${key[Left]}"              backward-char
    [[ -n "${key[Right]}"             ]] && bindkey -M "$keymap" "${key[Right]}"             forward-char
    [[ -n "${key[PageUp]}"            ]] && bindkey -M "$keymap" "${key[PageUp]}"            beginning-of-buffer-or-history
    [[ -n "${key[PageDown]}"          ]] && bindkey -M "$keymap" "${key[PageDown]}"          end-of-buffer-or-history
    [[ -n "${key[Shift-Tab]}"         ]] && bindkey -M "$keymap" "${key[Shift-Tab]}"         reverse-menu-complete
    [[ -n "${key[Alt-Delete]}"        ]] && bindkey -M "$keymap" "${key[Alt-Delete]}"        kill-word
    [[ -n "${key[Control-Left]}"      ]] && bindkey -M "$keymap" "${key[Control-Left]}"      backward-word
    [[ -n "${key[Control-Right]}"     ]] && bindkey -M "$keymap" "${key[Control-Right]}"     forward-word
    [[ -n "${key[Control-Delete]}"    ]] && bindkey -M "$keymap" "${key[Control-Delete]}"    kill-word
    [[ -n "${key[Control-Backspace]}" ]] && bindkey -M "$keymap" "${key[Control-Backspace]}" backward-kill-word
  done
}

# Finally, make sure the terminal is in application mode, when zle is active.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

exit-zsh() { exit }

xdg-open-dir() { xdg-open . }

clear-screen-and-scrollback() {
  echoti civis >"$TTY"
  printf '%b' '\e[H\e[2J' >"$TTY"
  zle .reset-prompt && zle -R
  printf '%b' '\e[3J' >"$TTY"
  echoti cnorm >"$TTY"
}

# Autoload widgets.
autoload -U select-word-style && select-word-style bash	
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

# Define new widgets
zle -N exit-zsh
zle -N xdg-open-dir
zle -N clear-screen-and-scrollback
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
