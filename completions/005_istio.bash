addCompletion $COMPLETIONS_DIR/istioctl.bash
updateCompletionsCommands="$updateCompletionsCommands\nif hash istioctl 2>/dev/null; then istioctl collateral completion --bash -o $COMPLETIONS_DIR; fi"
