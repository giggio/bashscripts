addCompletion $COMPLETIONS_DIR/npm
if hasBinaryInLinux npm; then
  updateCompletionsCommands="$updateCompletionsCommands\nnpm completion > $COMPLETIONS_DIR/npm"
fi
