DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  # shellcheck disable=SC2015 # we want to eval in the end in either case
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --hyperlink=always'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
if hash eza 2>/dev/null; then
  alias ll='eza --long --group --all --all --group-directories-first --hyperlink'
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
alias st='git status'
alias log='git log'
alias ci='git commit'
alias push='git push'
alias pushf='git push --force-with-lease'
alias co='git checkout'
alias pull='git pull'
alias fixup='git fixup'
alias dif='git diff'
alias pushsync='git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`'
if hash hub 2>/dev/null; then
  alias git=hub
fi
if hash kubectl 2>/dev/null; then
  if [ -f "$DIR"/../lib/kubectl-aliases/.kubectl_aliases ]; then
    if hash kubecolor 2>/dev/null; then
      # shellcheck source=/dev/null
      source "$DIR"/../lib/kubectl-aliases/.kubecolor_aliases
    else
      # shellcheck source=/dev/null
      source "$DIR"/../lib/kubectl-aliases/.kubectl_aliases
    fi
  else
    alias k=kubectl
  fi
fi
if hash istioctl 2>/dev/null; then
  alias istio=istioctl
fi
if hash terraform 2>/dev/null; then
  alias tf=terraform
fi
if hash pygmentize 2>/dev/null; then
  alias ccat='pygmentize -g -O style=vs -f console16m'
fi
alias cd-='cd -'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias weather='curl -s wttr.in'

if ! hash bat 2>/dev/null && hash batcat 2>/dev/null; then
  alias bat=batcat
  alias toyaml='bat --language yaml'
fi

if hash github-copilot-cli 2>/dev/null; then
  eval "$(github-copilot-cli alias -- "$0")"
fi

if hash kitty 2>/dev/null; then
  alias mg='kitty +kitten hyperlinked_grep --smart-case'
fi

alias hm='home-manager --flake ~/.dotfiles/config/home-manager --impure'

function gitignore () {
  if [ -v 1 ]; then
    case "$1" in
      -v|--version|-h|--help|-l|--list)
      git-ignore "$@"
      ;;
      *)
      git-ignore "$@" > .gitignore
      ;;
    esac
  else
    git-ignore -a > .gitignore
  fi
}
