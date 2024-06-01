if ! [ -d "$COMPLETIONS_DIR" ]; then
  mkdir -p "$COMPLETIONS_DIR"
  updateCompletions
fi
