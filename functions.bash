function hasBinary {
  hash $1 2>/dev/null
}

function hasBinaryInLinux {
  if ! $WSL; then
    hasBinary $1
    return
  fi
  PATH=`removeWindowsFromPath` hash $1 2>/dev/null
}

function man {
    case "$(type -t -- "$1")" in
    builtin|keyword)
        help -m "$1" | less
        ;;
    *)
        command man "$@"
        ;;
    esac
}

function edit-var {
  declare -n VAR=$1
  if ! [ -v VAR ]; then
    echo "Variable with name '${!VAR}' does not exist."
    return
  fi
  local TMP=`mktemp`
  echo "${VAR}" > $TMP
  vim $TMP
  eval "${!VAR}"'=`cat '$TMP'`'
  rm $TMP
}

function lorem {
  if [ -z "$1" ]; then
    PARAGRAPHS=10
  else
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
      echo "Usage: lorem <number of paragraphs>"
      return
    fi
    PARAGRAPHS=$1
  fi
  perl -e 'use Text::Lorem;my $text = Text::Lorem->new();$paragraphs = $text->paragraphs('$PARAGRAPHS');print $paragraphs;'
}

function watchrun {
  while inotifywait -q -e close_write $1; do
    `realpath $1`
  done
}
