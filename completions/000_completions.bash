function addCompletion {
  if [ -f "$1" ]; then
    # shellcheck source=/dev/null
    source "$1"
  fi
}

updateCompletionsCommands=''
if [ -v XDG_DATA_HOME ]; then
  export COMPLETIONS_DIR=$XDG_DATA_HOME/bash-completion/completions/
else
  export COMPLETIONS_DIR=$HOME/.local/share/bash-completion/completions/
fi
function updateCompletions {
  echo Updating completions...
  mkdir -p "$COMPLETIONS_DIR"
  echo -e "$updateCompletionsCommands" | while read -r line; do bash -c "$line"; done
  echo Done.
}
