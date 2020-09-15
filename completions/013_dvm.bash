addCompletion $COMPLETIONS_DIR/dvm
updateCompletionsCommands="$updateCompletionsCommands\nif hash dvm 2>/dev/null; then dvm completions bash > $COMPLETIONS_DIR/dvm; fi"
