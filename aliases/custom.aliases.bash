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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
alias pull='git pull'
complete -F _complete_alias pull
alias fixup='git fixup'
complete -F _complete_alias fixup
alias dif='git diff'
complete -F _complete_alias dif
if hash hub 2>/dev/null; then
  alias git=hub
fi
if hash kubectl 2>/dev/null; then
  alias k=kubectl
  complete -F _complete_alias k
fi
