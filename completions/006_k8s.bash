addCompletion $COMPLETIONS_DIR/kubectl
addCompletion $COMPLETIONS_DIR/kubecolor
updateCompletionsCommands="$updateCompletionsCommands\nif hash kubectl 2>/dev/null; then kubectl completion bash > $COMPLETIONS_DIR/kubectl; fi"
updateCompletionsCommands="$updateCompletionsCommands\nif hash kubecolor 2>/dev/null; then kubectl completion bash | sed 's/kubectl/kubecolor/g' > $COMPLETIONS_DIR/kubecolor; fi"
