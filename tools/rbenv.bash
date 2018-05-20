if hash $HOME/.rbenv/bin/rbenv 2>/dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
