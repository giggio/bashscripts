if [ -d "$HOME/.kube" ]; then
  KUBECONFIG=`find "$HOME"/.kube -maxdepth 1 -type f ! -name '*.bak' ! -name '*.backup' ! -name kubectx | sort | paste -sd ":" -`
  export KUBECONFIG
fi
