if GOCOMPLETE=`which gocomplete`; then
  complete -C $GOCOMPLETE go
fi
unset GOCOMPLETE
