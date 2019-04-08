THIS_FILE=$BASH_SOURCE
THIS_DIR=`dirname $THIS_FILE`
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if cat /proc/version | grep Microsoft > /dev/null; then
  export WSL=true
fi
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=vim
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
if [ -d  /usr/local/go/bin ]; then
  export PATH=$PATH:/usr/local/go/bin
fi
if [[ -x "$THIS_DIR/lib/kubectx/kubectx" ]]; then export PATH="$PATH:$THIS_DIR/lib/kubectx"; fi
if [ "$WSL" ]; then
  export DOCKER_HOST="unix://$HOME/sockets/docker.sock"
  if ! pgrep socat > /dev/null; then
    tmux new -s docker-relay-session -d docker-relay
  fi
fi
if [ "$WSL" ]; then
  function removeWindowsFromPath {
    echo `echo $PATH | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':'`
  }
fi

export GPG_TTY=$(tty)
