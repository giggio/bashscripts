addCompletion $COMPLETIONS_DIR/kubectl
updateCompletionsCommands="$updateCompletionsCommands\nif hash kubectl 2>/dev/null; then kubectl completion bash > $COMPLETIONS_DIR/kubectl; fi"
