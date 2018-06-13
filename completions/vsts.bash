if [ -d  $HOME/lib/vsts-cli/bin ]; then
  export PATH=$PATH:$HOME/lib/vsts-cli/bin
  source "$HOME/lib/vsts-cli/vsts.completion"
fi
