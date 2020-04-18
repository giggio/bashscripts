if ! [ -d $COMPLETIONS_DIR ]; then
  mkdir -p $COMPLETIONS_DIR
  updateCompletions
  THIS_FILE=$BASH_SOURCE
  THIS_DIR=`dirname $THIS_FILE`
  for completionsFile in `echo $THIS_DIR/*.bash`; do
    if [ -e "$completionsFile" ]; then
        source "$completionsFile"
    fi
  done
fi