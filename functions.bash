function hasBinary {
  hash $1 2>/dev/null
}
function hasBinaryInLinux {
  if ! $WSL; then
    hasBinary
    return
  fi
  PATH=`removeWindowsFromPath` hash $1 2>/dev/null
}
