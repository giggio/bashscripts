if [ -f $HOME/.rbenv/bin/rbenv ]; then
  export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  addCompletion $COMPLETIONS_DIR/rbenv
  updateCompletionsCommands="$updateCompletionsCommands\nrbenv init - > $COMPLETIONS_DIR/rbenv"
fi
