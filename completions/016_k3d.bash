addCompletion "$COMPLETIONS_DIR"/k3d
updateCompletionsCommands="$updateCompletionsCommands\nif hash k3d 2>/dev/null; then k3d completion bash > $COMPLETIONS_DIR/k3d; fi"
