if hash terraform 2>/dev/null; then
  complete -C "`which terraform`" terraform
  complete -C "`which terraform`" tf
fi
