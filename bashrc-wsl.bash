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
if grep docker /proc/1/cgroup -qa; then
  export RUNNING_IN_CONTAINER=true
else
  export RUNNING_IN_CONTAINER=false
fi
if ! $WSL || $RUNNING_IN_CONTAINER; then return; fi
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

# Do not run wslfetch, it is really slow to start, it adds several seconds to bash's startup.
# if hash wslfetch 2>/dev/null; then
#   wslfetch
# fi

export WINDOWS_IP_ADDRESS=`ipconfig.exe | grep WSL -A3 | tail -n 1 | awk '{print $NF}' | tr -d '\r\n'`

# start proxy to Windows. Necessary until https://github.com/microsoft/WSL/issues/4517#issuecomment-621832142
# is fixed. See comment for details.
function proxyvpn {
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
}
# also related to the same issue, another workaround (and better): https://github.com/microsoft/WSL/issues/4517#issuecomment-628701283
function setMTU {
  sudo ifconfig eth0 mtu 1400
}

# TODO: remove when https://github.com/dotnet/aspnetcore/issues/7246 is fixed
if [ -f $HOME/certs/dotnet.pfx ]; then
  export Kestrel__Certificates__Default__Path=$HOME/certs/dotnet.pfx
  export Kestrel__Certificates__Default__Password=''
fi
