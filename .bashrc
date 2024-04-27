THIS_FILE="${BASH_SOURCE[0]}"
THIS_DIR=`dirname "$THIS_FILE"`
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

# if hash nix-env 2>/dev/null; then
#   LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
#   export LOCALE_ARCHIVE
# fi
if [ -f "$HOME"/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  # shellcheck source=/dev/null
  source "$HOME"/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
if hash vim 2>/dev/null; then
  export EDITOR=vim
fi
export PATH=$THIS_DIR/bin:$HOME/bin:$HOME/.local/bin:$PATH
export TMP=/tmp
export TEMP=/tmp
N_PREFIX=$HOME/.n
if [ -d "$N_PREFIX" ]; then
  export PATH=$N_PREFIX/bin:$PATH
  export N_PREFIX
fi
if [ -d  "$HOME"/.dotnet/tools ] && ! [[ $PATH =~ "$HOME"/.dotnet/tools ]]; then
  export PATH=$PATH:$HOME/.dotnet/tools
fi
if [ -f "$HOME"/.cargo/env ]; then
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi
if hash sccache 2>/dev/null; then
  RUSTC_WRAPPER=`which sccache`
  export RUSTC_WRAPPER
fi
if [ -d "$HOME"/.krew/bin ]; then
  export PATH=$PATH:$HOME/.krew/bin
fi
if [ -e "$HOME"/.go/bin/go ]; then
  export PATH=$PATH:$HOME/.go/bin
  if [ -d "$HOME"/go/bin ]; then
    export PATH=$PATH:$HOME/go/bin
  fi
fi
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
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
fi

SCRIPTS=`find "$THIS_DIR" -name '*.bash' -type f -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F'\0' '{print $3}'`
for SCRIPT in $SCRIPTS; do
  # shellcheck source=/dev/null
  source "$SCRIPT"
done

if ! $WSL; then
  GPG_TTY=$(tty)
  export GPG_TTY
fi

# I was considering using githhoks in templating mode, but I think I prefer manual mode
# I will leave this here in case I change my mind
# if [ -d "$HOME"/.gittemplate ] && [ -x "$(git config githooks.runner | envsubst)" ]; then
#   export GIT_TEMPLATE_DIR="$HOME"/.gittemplate
# fi

if ! [ -v XDG_RUNTIME_DIR ]; then
  XDG_RUNTIME_DIR=/run/user/`id -u`/
  export XDG_RUNTIME_DIR
  if ! [ -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 755 "$XDG_RUNTIME_DIR"
  fi
fi

# setup ssh-agent
# only setup ssh agent if not previosly set
if [ -v SSH_AUTH_SOCK ]; then
  if [ -S "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh" ]; then
    SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
    export SSH_AUTH_SOCK
  fi
else
  SSH_DIR=$XDG_RUNTIME_DIR/gnupg
  if ! [ -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
  fi
  SSH_AUTH_SOCK="$SSH_DIR"/ssh.sock
  if [ -S "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK
    if [ -f "$HOME/.ssh/ssh_pid" ]; then
      SSH_AGENT_PID="`cat "$HOME"/.ssh/ssh_pid`"
      export SSH_AGENT_PID
    fi
  else
    eval "`ssh-agent -s -a "$SSH_AUTH_SOCK"`" > /dev/null
    if ! [ -d "$HOME"/.ssh ]; then
      mkdir -p "$HOME/.ssh"
      chmod 700 "$HOME/.ssh"
    fi
    echo "$SSH_AGENT_PID" > "$HOME/.ssh/ssh_pid"
  fi
fi

# export SYSTEMD_LESS=FRSMK
