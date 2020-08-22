addCompletion $COMPLETIONS_DIR/deno
updateCompletionsCommands="$updateCompletionsCommands\nif hash deno 2>/dev/null; then deno completions bash > $COMPLETIONS_DIR/deno; fi"
