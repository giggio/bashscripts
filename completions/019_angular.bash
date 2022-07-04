addCompletion $COMPLETIONS_DIR/ng
updateCompletionsCommands="$updateCompletionsCommands\nif hash ng 2>/dev/null; then ng completion script  > $COMPLETIONS_DIR/ng; fi"
