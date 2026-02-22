# Make nvim run as vim
alias vim='nvim'

# Fs
alias l='ls -l'
alias lx='l -X'
alias la='l -a'

# Git
alias g='git status'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'

# Tmux
alias ta='tmux a -t'
alias at='tmux a -t'
alias tls='tmux ls'

t() {
  local name="${1:-$(basename "$PWD")}"
  tmux new -A -s "$name"
}

# Docker
alias d='docker'
alias dc='docker compose'
function dit {
  docker exec -it $1 ${2:-'bash'}
}

alias j='jobs'

function uuid {
  uuidgen | awk '{print tolower($0)}'
}

# Curl
function curlp {
  echo curl -X POST -d $2 $1
  curl -X POST -d $2 $1
}

# Token gen
function token {
  openssl rand -base64 $1
}

function tldr() {
  curl "https://cht.sh/$1"
}

# ssh
function ssh-md5 {
  ssh-keygen -l -f $1 -E md5
}
