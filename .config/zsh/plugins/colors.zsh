# Autoload colors
autoload -U colors && colors

# Define LS_COLORS via dircolors
source <(dircolors -b)

# Set ls, grep and exa colors
alias ls='ls --color=tty'
if (( $+commands[exa] )) ; then
  alias exa='exa --color=auto --icons'
fi
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then
  # Supported commands
  cmds=(
    as ant blkid cc configure curl cvs df diff dig dnf docker docker-compose \
    docker-machine du env fdisk findmnt free g++ gas gcc getfacl getsebool gmake \
    id ifconfig iostat ip iptables iwconfig kubectl last ldap lolcat ld lsattr lsblk \
    lsmod lsof lspci make mount mtr mvn netstat nmap ntpdate php  ping ping6 proftpd ps \
    sar semanage sensors showmount sockstat ss stat sysctl systemctl tcpdump traceroute \
    traceroute6 tune2fs ulimit uptime vmstat wdiff whois \
  );

  # Set alias for available commands.
  for cmd in $cmds ; do
    if (( $+commands[$cmd] )) ; then
      unalias $cmd &> /dev/null
      $cmd() {
        grc --colour=auto ${commands[$0]} "$@"
      }
    fi
  done

  # Clean up variables
  unset cmds cmd
fi
