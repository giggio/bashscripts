addCompletion "$COMPLETIONS_DIR"/helm
updateCompletionsCommands="$updateCompletionsCommands\nif hash helm 2>/dev/null; then helm completion bash > $COMPLETIONS_DIR/helm;fi"
