if [ -d "$HOME/.kube" ]; then
  export KUBECONFIG=$HOME/.kube/config:$(find $HOME/.kube -maxdepth 1 -type f ! -name *.bak ! -name *.backup ! -name config ! -name kubectx |  paste -sd ":" -)
fi
