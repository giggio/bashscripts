addCompletion $COMPLETIONS_DIR/rustup
addCompletion $COMPLETIONS_DIR/cargo
# todo: remove sed from the end when https://github.com/rust-lang/rustup/issues/3407 is fixed
updateCompletionsCommands="$updateCompletionsCommands\nif hash rustup 2>/dev/null; then rustup completions bash > $COMPLETIONS_DIR/rustup; rustup completions bash cargo > $COMPLETIONS_DIR/cargo; sed -i 's/\\/etc\\/bash_completion.d\\//\\/src\\/etc\\/bash_completion.d\\//' $COMPLETIONS_DIR/cargo; fi"
