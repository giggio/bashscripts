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
