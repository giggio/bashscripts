addCompletion $COMPLETIONS_DIR/node
updateCompletionsCommands="$updateCompletionsCommands\nif hash node 2>/dev/null; then node --completion-bash > $COMPLETIONS_DIR/node; fi"
