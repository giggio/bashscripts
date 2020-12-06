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
