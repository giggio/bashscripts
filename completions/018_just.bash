addCompletion $COMPLETIONS_DIR/just
updateCompletionsCommands="$updateCompletionsCommands\nif hash just 2>/dev/null; then just --completions bash  > $COMPLETIONS_DIR/just; fi"
