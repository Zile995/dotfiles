() {
  # Set the cache dir path
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  [[ ! -d $cache_dir ]] && mkdir -p "$cache_dir"

  # Enable the completion cache and set the cache-path
  zstyle ':completion:*' use-cache  "true"
  zstyle ':completion:*' cache-path "$cache_dir/.zcompcache"

  # Load zsh completion
  autoload -Uz compinit && compinit -d "$cache_dir/.zcompdump"
  autoload -U +X bashcompinit && bashcompinit
}

# Completion
zstyle ':completion:*'                  menu              "select"
zstyle ':completion:*'                  verbose           "true"
zstyle ':completion:*'                  group-name        ""
zstyle ':completion:*'                  special-dirs      "false"
zstyle ':completion:*'                  single-ignored    "show"
zstyle ':completion:*'                  squeeze-slashes   "true"
zstyle ':completion:*'                  list-colors       "${(@s.:.)LS_COLORS}"
zstyle ':completion:*'                  matcher-list      "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
zstyle ':completion:::::'               insert-tab        "pending"
zstyle ':completion:*:rm:*'             ignore-line       "other"
zstyle ':completion:*:rm:*'             file-patterns     "*:all-files"
zstyle ':completion:*:kill:*'           ignore-line       "other"
zstyle ':completion:*:diff:*'           ignore-line       "other"
zstyle ':completion:*:paths'            accept-exact-dirs "true"
zstyle ':completion:*:functions'        ignored-patterns  "-*|_*"
zstyle ':completion:*:-tilde-:*'        tag-order         "directory-stack" "named-directories" "users"
zstyle ':completion:*:-subscript-:*'    tag-order         "indexes parameters"
zstyle ':completion:*:*:*:*:processes'  command           "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:complete:*:options' sort              "false"

# Ssh
zstyle ':completion:*:ssh:argument-1:*'                    sort             'true'
zstyle ':completion:*:scp:argument-rest:*'                 sort             'true'

# Git
zstyle ':completion:*:git-checkout:*'                      sort             'false'
zstyle ':completion:*:git-*:argument-rest:heads'           ignored-patterns '(FETCH_|ORIG_|*/|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-local'     ignored-patterns '(FETCH_|ORIG_|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-remote'    ignored-patterns '*/HEAD'
zstyle ':completion:*:git-*:argument-rest:commits'         ignored-patterns '*'
zstyle ':completion:*:git-*:argument-rest:commit-objects'  ignored-patterns '*'
zstyle ':completion:*:git-*:argument-rest:recent-branches' ignored-patterns '*'
