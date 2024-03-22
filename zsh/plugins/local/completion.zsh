() {
  setopt localoptions extendedglob

  local zcompcache=${ZCACHEDIR}/.zcompcache
  local zcompdump=${ZCACHEDIR}/.zcompdump

  # Enable the completion cache and set the cache-path
  zstyle ':completion:*' use-cache  "true"
  zstyle ':completion:*' cache-path "$zcompcache"

  # Load zsh completion
  autoload -Uz compinit && compinit -d "$zcompdump"

  # Load bash completion
  autoload -U +X bashcompinit && bashcompinit

  # zcompile completion files
  autoload -Uz zrecompile
  zrecompile -pq ${ZCACHEDIR}/^(*.zwc|*.zwc.old)(-.N)
}

# Completion
zstyle ':completion:*'                  menu              'select'
zstyle ':completion:*'                  verbose           'true'
zstyle ':completion:*'                  group-name        ''
zstyle ':completion:*'                  special-dirs      'false'
zstyle ':completion:*'                  single-ignored    'show'
zstyle ':completion:*'                  squeeze-slashes   'true'
zstyle ':completion:::::'               insert-tab        'pending'
zstyle ':completion:*'                  list-colors       ${(@s.:.)LS_COLORS}
zstyle ':completion:*'                  matcher-list      'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:options'          description       'yes'
zstyle ':completion:*:options'          auto-description  '%d'
zstyle ':completion:complete:*:options' sort              'false'
zstyle ':completion:*:functions'        ignored-patterns  '-*|_*'
zstyle ':completion:*:-subscript-:*'    tag-order         'indexes parameters'

# Fuzzy match mistyped completions
zstyle ':completion:*'               completer  _complete _match _approximate
zstyle ':completion:*:match:*'       original   only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Directory
zstyle ':completion:*:paths'     accept-exact-dirs  'true'
zstyle ':completion:*:*:cd:*'    tag-order          local-directories directory-stack path-directories
zstyle ':completion:*:-tilde-:*' group-order        'named-directories' 'path-directories' 'users' 'expand'

# Ignored patterns
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# Ignore multiple entries
zstyle ':completion:*:rm:*'             file-patterns '*:all-files'
zstyle ':completion:*:(rm|kill|diff):*' ignore-line   other

# Kill
zstyle ':completion:*:*:kill:*'         force-list  always
zstyle ':completion:*:*:kill:*'         insert-ids  single
zstyle ':completion:*:*:*:*:processes'  command     'ps -u $USER -o pid,user,comm -w -w'

# Git
zstyle ':completion:*:git-checkout:*'                      sort              'false'
zstyle ':completion:*:git-*:argument-rest:heads'           ignored-patterns  '(FETCH_|ORIG_|*/|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-local'     ignored-patterns  '(FETCH_|ORIG_|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-remote'    ignored-patterns  '*/HEAD'
zstyle ':completion:*:git-*:argument-rest:commits'         ignored-patterns  '*'
zstyle ':completion:*:git-*:argument-rest:commit-objects'  ignored-patterns  '*'
zstyle ':completion:*:git-*:argument-rest:recent-branches' ignored-patterns  '*'

# SSH/SCP/RSYNC
zstyle ':completion:*:ssh:argument-1:*'                    sort              'true'
zstyle ':completion:*:scp:argument-rest:*'                 sort              'true'
zstyle ':completion:*:ssh:*'                               group-order       users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(scp|rsync):*'                       group-order       users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*'                   tag-order         'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host'        ignored-patterns  '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain'      ignored-patterns  '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr'      ignored-patterns  '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
