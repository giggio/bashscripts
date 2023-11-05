addCompletion "$COMPLETIONS_DIR"/gh
updateCompletionsCommands="$updateCompletionsCommands\nif hash helm 2>/dev/null; then gh completion -s bash > $COMPLETIONS_DIR/gh;fi"
