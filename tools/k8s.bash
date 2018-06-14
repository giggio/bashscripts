if [ -d "$HOME/.kube" ]; then
  export KUBECONFIG=$(find $HOME/.kube -maxdepth 1 -type f ! -name *.backup |  paste -sd ":" -)
fi
