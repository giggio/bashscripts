if grep [Mm]icrosoft /proc/version > /dev/null; then
  export WSL=true
else
  export WSL=false
fi
function removeWindowsFromPath {
  if ! $WSL; then
    echo $PATH
    return
  fi
  echo `echo $PATH | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':'`
}
if ! $WSL; then return; fi
IS_SSH=false
if [ -v SSH_CLIENT ] || [ -v SSH_TTY ]; then
  IS_SSH=true
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) IS_SSH=true;;
  esac
fi
if [ -v WSL_INTEROP ] || [ -v WSL_INTEGRATION_CACHE ]; then
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
# start cron, add '%sudo ALL=NOPASSWD: /etc/init.d/cron start' via visudo if this fails
if ! pgrep cron > /dev/null; then
  if [ -f /etc/init.d/cron ]; then
    sudo /etc/init.d/cron start > /dev/null
  fi
fi
if hash cmd.exe 2> /dev/null; then
  pushd /mnt/c > /dev/null
  export WHOME=$(wslpath -u $(cmd.exe /c "echo %USERPROFILE%") | sed -e 's/[[:space:]]*$//')
  popd > /dev/null
  if [ "$WHOME" == "$(pwd)" ]; then
    cd
  fi
fi
if hash wslfetch 2>/dev/null; then
  wslfetch
fi

export WINDOWS_IP_ADDRESS=`ipconfig.exe | grep WSL -A3 | tail -n 1 | awk '{print $NF}' | tr -d '\r\n'`

# start proxy to Windows. Necessary until https://github.com/microsoft/WSL/issues/4517#issuecomment-621832142
# is fixed. See comment for details.
if ! powershell.exe -noprofile -c 'Get-Process -Name cow -ErrorAction SilentlyContinue' > /dev/null; then
  if hash cow-taskbar.exe 2> /dev/null; then
    cow-taskbar.exe &
    disown
  fi
fi
if powershell.exe -noprofile -c 'Get-Process -Name cow -ErrorAction SilentlyContinue' > /dev/null; then
  export https_proxy="http://$WINDOWS_IP_ADDRESS:7777"
  export http_proxy="http://$WINDOWS_IP_ADDRESS:7777"
fi
