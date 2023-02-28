DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../lib/complete-alias/complete_alias

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
if hash exa 2>/dev/null; then
  alias ll='exa --long --group --all --all --group-directories-first'
else
  alias ll='ls -alF'
fi
alias la='ls -A'
alias l='ls -CF'
alias cls=clear

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias add='git add'
complete -F _complete_alias add
alias st='git status'
complete -F _complete_alias st
alias log='git log'
complete -F _complete_alias log
alias ci='git commit'
complete -F _complete_alias ci
alias push='git push'
complete -F _complete_alias push
alias co='git checkout'
complete -F _complete_alias co
alias pull='git pull'
complete -F _complete_alias pull
alias fixup='git fixup'
complete -F _complete_alias fixup
alias dif='git diff'
complete -F _complete_alias dif
alias pushsync='git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
if hash hub 2>/dev/null; then
  alias git=hub
fi
if hash kubectl 2>/dev/null; then
  if [ -f $DIR/../lib/kubectl-aliases/.kubectl_aliases ]; then
    source $DIR/../lib/kubectl-aliases/.kubectl_aliases
    ALIASES=`awk -F'[ =]' '/^alias / {print $2}' $DIR/../lib/kubectl-aliases/.kubectl_aliases`
    for ALIAS in $ALIASES; do
      complete -F _complete_alias $ALIAS
    done
  else
    alias k=kubectl
    complete -F _complete_alias k
  fi
fi
if hash istioctl 2>/dev/null; then
  alias istio=istioctl
  complete -F _complete_alias istio
fi
if hash terraform 2>/dev/null; then
  alias tf=terraform # completions for alias are on completions file for Terraform
fi
if hash pygmentize 2>/dev/null; then
  alias ccat='pygmentize -g -O style=vs -f console16m'
fi
alias cd-='cd -'
alias cd..='cd ..'
alias weather='curl -s wttr.in'

if ! hash bat 2>/dev/null && hash batcat 2>/dev/null; then
  alias bat=batcat
fi

if hash github-copilot-cli 2>/dev/null; then
  eval "$(github-copilot-cli alias -- "$0")"
fi
