if ! [ -d "$COMPLETIONS_DIR" ]; then
  mkdir -p "$COMPLETIONS_DIR"
  updateCompletions
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  for completionsFile in `echo "$DIR"/*.bash`; do
    if [ -e "$completionsFile" ]; then
      # shellcheck source=/dev/null
      source "$completionsFile"
    fi
  done
fi
