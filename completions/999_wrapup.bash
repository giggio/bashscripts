if ! [ -d "$COMPLETIONS_DIR" ]; then
  mkdir -p "$COMPLETIONS_DIR"
  updateCompletions
fi

# auto complete all aliases
complete -F _complete_alias "${!BASH_ALIASES[@]}"
