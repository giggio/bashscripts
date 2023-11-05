if hash gocomplete 2>/dev/null; then
  if GOCOMPLETE=`which gocomplete`; then
    complete -C "$GOCOMPLETE" go
  fi
  unset GOCOMPLETE
fi
