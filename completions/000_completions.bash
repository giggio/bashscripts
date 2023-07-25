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

function addCompletion {
  if [ -f $1 ]; then
    source $1
  fi
}

updateCompletionsCommands=''
export COMPLETIONS_DIR=$HOME/.completions
function updateCompletions {
  echo Updating completions...
  mkdir -p "$COMPLETIONS_DIR"
  echo -e "$updateCompletionsCommands" | while read -r line; do bash -c "$line"; done
  echo Done.
}
