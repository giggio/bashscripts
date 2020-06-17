if [ -d "$HOME/.kube" ]; then
  export KUBECONFIG=`find $HOME/.kube -maxdepth 1 -type f ! -name *.bak ! -name *.backup ! -name kubectx | sort | paste -sd ":" -`
fi
