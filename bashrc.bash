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
HISTSIZE=20000
HISTFILESIZE=20000

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if hash vim 2>/dev/null; then
  export EDITOR=vim
fi
export PATH=$THIS_DIR/bin:$HOME/bin:$HOME/.local/bin:$PATH
N_PREFIX=$HOME/.n
if [ -d $N_PREFIX ]; then
  export PATH=$N_PREFIX/bin:$PATH
  export N_PREFIX
fi
DENO_INSTALL=$HOME/.deno
if [ -d $DENO_INSTALL ]; then
  export PATH=$DENO_INSTALL/bin:$PATH
  export DENO_INSTALL
fi
if [ -d  /usr/local/go/bin ]; then
  export PATH=$PATH:/usr/local/go/bin
fi
if [ -d  $HOME/.dotnet/tools ]; then
  export PATH=$PATH:$HOME/.dotnet/tools
fi
export GPG_TTY=$(tty)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export LC_ALL=en_US.UTF-8
set -o vi
bind '"jj":"\e"'
tabs -4
export DOCKER_BUILDKIT=1
