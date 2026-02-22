# include device specific bashrc if it exists
if [ -f $HOME/.devicerc ]; then
  . $HOME/.devicerc
fi

# Fs aliases
alias l='ls -l'
alias ld='l --group-directories-first'
alias lx='l -X'
alias la='l -a'
alias ccd='cd ..'

# Git aliases
alias g='git status'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'

# Tmux aliases
alias ta='tmux a -t'
alias at='tmux a -t'
alias tnew='tmux new -s'
alias tls='tmux ls'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
function dit {
  docker exec -it $1 ${2:-'bash'}
}

# Other aliases
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

# Path
export PATH=~/bin:$PATH

# Prompt
GITRC=~/.git-prompt.sh
source $GITRC
force_color_prompt=yes

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
#export PS1='\u@\h [\w]$(__git_ps1 " [%s]")\$ '
export PS1='\[$(tput bold)\]\[\033[38;5;243m\]\u\[$(tput sgr0)\]\[\033[38;5;247m\]@\[$(tput sgr0)\]\[\033[38;5;253m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;172m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;30m\]$(__git_ps1 "[%s]")\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]'

# Set default editor for commands like crontab
export VISUAL=vim

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
