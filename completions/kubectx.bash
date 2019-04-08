if hash kubectx 2>/dev/null; then
  KUBECTX_DIR=$(dirname $(which kubectx))
  source "$KUBECTX_DIR/completion/kubectx.bash"
fi
if hash kubens 2>/dev/null; then
  KUBENS_DIR=$(dirname $(which kubens))
  source "$KUBENS_DIR/completion/kubens.bash"
fi
