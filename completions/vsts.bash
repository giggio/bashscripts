if [ -d  $HOME/lib/vsts-cli/bin ]; then
  export PATH=$HOME/lib/vsts-cli/bin:$PATH
  source "$HOME/lib/vsts-cli/vsts.completion"
fi
