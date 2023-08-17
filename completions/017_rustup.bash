addCompletion $COMPLETIONS_DIR/rustup
addCompletion $COMPLETIONS_DIR/cargo
updateCompletionsCommands="$updateCompletionsCommands\nif hash rustup 2>/dev/null; then rustup completions bash > $COMPLETIONS_DIR/rustup; rustup completions bash cargo > $COMPLETIONS_DIR/cargo; fi"
