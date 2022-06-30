THIS_FILE=$BASH_SOURCE
THIS_DIR=`dirname $THIS_FILE`
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't check mail when opening terminal.
unset MAILCHECK

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
export PATH=$THIS_DIR/bin:$HOME/bin:$HOME/.local/bin:$PATH
DENO_INSTALL=$HOME/.deno/bin
if hash dvm 2>/dev/null || [ -x DENO_INSTALL/deno ]; then
  if ! [ -d $DENO_INSTALL ]; then
    mkdir -p $DENO_INSTALL
  fi
  export PATH=$DENO_INSTALL:$PATH
fi
if [ -d  /usr/local/go/bin ]; then
  export PATH=$PATH:/usr/local/go/bin
fi
if [ -d  $HOME/.dotnet/tools ]; then
  export PATH=$PATH:$HOME/.dotnet/tools
fi
if [ -f $HOME/.cargo/env ]; then
  source "$HOME/.cargo/env"
fi
if hash sccache 2>/dev/null; then
  export RUSTC_WRAPPER=sccache
fi
if [ -e $HOME/.krew/bin/kubectl-krew ]; then
  export PATH=$PATH:$HOME/.krew/bin
fi
if [ -e $HOME/.go/bin/go ]; then
  export PATH=$PATH:$HOME/.go/bin
  if [ -d $HOME/go/bin ]; then
    export PATH=$PATH:$HOME/go/bin
  fi
fi
export GPG_TTY=$(tty)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export LC_ALL=en_US.UTF-8
set -o vi
bind '"jj":"\e"'
tabs -4
export DOCKER_BUILDKIT=1
export INPUTRC=$THIS_DIR/.inputrc

bind 'set completion-ignore-case on'

if hash starship 2>/dev/null; then
  eval "$(starship init bash)"
else
  echo "Install Starship to get a nice theme. Go to: https://starship.rs/"
fi

SCRIPTS=`find $THIS_DIR -name '*.bash' -type f -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F'\0' '{print $3}'`
for SCRIPT in $SCRIPTS; do
  source $SCRIPT
done
