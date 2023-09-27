addCompletion $COMPLETIONS_DIR/dotnet-suggest
updateCompletionsCommands="$updateCompletionsCommands\nif hash dotnet-suggest 2>/dev/null; then dotnet-suggest script Bash | sed 's/\r$//' > $COMPLETIONS_DIR/dotnet-suggest; fi"
