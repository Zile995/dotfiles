# dotfiles

## Necessary Arch Linux packages for zsh:
  * ```Shell
    sudo pacman -S bat exa fd fzf git-delta grc ripgrep kexec-tools zsh-completions
    ```
  * Install the Antidote plugin manager: `yay -S zsh-antidote`
    * Or simply clone the repo:
      ```Shell
      git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
      ```  
  * Install the clipboard command line tools: `wl-clipboard` for Wayland or `xclip` for X11/XWayland
