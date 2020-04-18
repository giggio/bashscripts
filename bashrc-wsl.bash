if grep [Mm]icrosoft /proc/version > /dev/null; then
  export WSL=true
fi
function removeWindowsFromPath {
  if ! $WSL; then
    echo $PATH
    return
  fi
  echo `echo $PATH | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':'`
}
if [ ! "$WSL" = 'true' ]; then return; fi
if [ -v WSL_INTEROP ]; then
  export WSLVersion=2
else
  export WSLVersion=1
fi
# put your script here for WSL only
if [ "$WSLVersion" == "1" ]; then
  export DOCKER_HOST="unix://$HOME/sockets/docker.sock"
  if hash tmux 2>/dev/null && hash docker-relay 2>/dev/null; then
    if ! pgrep socat > /dev/null; then
      tmux new -s docker-relay-session -d docker-relay
    fi
  fi
fi
pushd /mnt/c > /dev/null
# start cron, add '%sudo ALL=NOPASSWD: /etc/init.d/cron start' via visudo if this fails
if ! pgrep cron > /dev/null; then
  sudo /etc/init.d/cron start > /dev/null
fi
export WHOME=$(wslpath -u $(cmd.exe /c "echo %USERPROFILE%") | sed -e 's/[[:space:]]*$//')
popd > /dev/null
if [ "$WHOME" == "$(pwd)" ]; then
  cd
fi
if hash wslfetch 2>/dev/null; then
  wslfetch
fi
