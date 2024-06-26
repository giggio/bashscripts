#!/usr/bin/env bash

# put your script here for WSL only

if grep '[Mm]icrosoft' /proc/version -q &> /dev/null; then
  export WSL=true
else
  export WSL=false
fi
function removeWindowsFromPath {
  if ! $WSL; then
    echo "$PATH"
    return
  fi
  echo "$PATH" | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':'
}
function windows_env_var() {
  pushd /mnt/c > /dev/null
  wslpath "$(/mnt/c/Windows/System32/cmd.exe /c 'echo|set /p=%'"$1"'%' 2> /dev/null)"
  popd > /dev/null
}
function find_in_win_path () {
  if ! [ -v 1 ]; then return 1; fi
  binary=$1
  cd /mnt/c
  path=`/mnt/c/Windows/System32/cmd.exe /c "where.exe $binary 2> NUL" | head -n1 | awk '{gsub(/\r$/,"")} {print $0}'`
  if [ "$path" != '' ]; then
    wslpath "$path"
  fi
}
function run_in_win_path () {
  if ! [ -v 1 ]; then return 1; fi
  binary=$1
  shift
  path=`find_in_win_path "$binary"`
  if [ "$path" == '' ]; then return 1; fi
  "$path" "$@"
}
if [ -f /.dockerenv ] || grep docker /proc/1/cgroup -qa 2> /dev/null; then
  export RUNNING_IN_CONTAINER=true
else
  export RUNNING_IN_CONTAINER=false
fi
if ! $WSL || $RUNNING_IN_CONTAINER; then return; fi
if [[ $PATH =~ /mnt/.* ]]; then
  # shellcheck disable=SC2155
  export PATH=`removeWindowsFromPath`
fi
IS_SSH=false
if [ -v SSH_CLIENT ] || [ -v SSH_TTY ]; then
  IS_SSH=true
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) IS_SSH=true;;
  esac
fi
export IS_SSH

# shellcheck disable=SC2155
export WHOME=`windows_env_var USERPROFILE`

# Do not run wslfetch, it is really slow to start, it adds several seconds to bash's startup.
# if hash wslfetch 2>/dev/null; then
#   wslfetch
# fi

WINDOWS_IP_ADDRESS=$(run_in_win_path ipconfig.exe | grep WSL -A5 | grep IPv4 | tail -n 1 | awk '{print $NF}' | tr -d '\r\n')
export WINDOWS_IP_ADDRESS

# start proxy to Windows. Necessary until https://github.com/microsoft/WSL/issues/4517#issuecomment-621832142
# is fixed. See comment for details.
function proxyvpn {
  if ! run_in_win_path powershell.exe -noprofile -c 'Get-Process -Name cow -ErrorAction SilentlyContinue' > /dev/null; then
    if hash cow-taskbar.exe 2> /dev/null; then
      cow-taskbar.exe &
      disown
    fi
  fi
  if run_in_win_path powershell.exe -noprofile -c 'Get-Process -Name cow -ErrorAction SilentlyContinue' > /dev/null; then
    export https_proxy="http://$WINDOWS_IP_ADDRESS:7777"
    export http_proxy="http://$WINDOWS_IP_ADDRESS:7777"
  fi
}
# also related to the same issue, another workaround (and better): https://github.com/microsoft/WSL/issues/4517#issuecomment-628701283
function setMTU {
  sudo ifconfig eth0 mtu 1400
}

# TODO: remove when https://github.com/dotnet/aspnetcore/issues/7246 is fixed
if [ -f "$HOME"/certs/dotnet.pfx ]; then
  export Kestrel__Certificates__Default__Path=$HOME/certs/dotnet.pfx
  export Kestrel__Certificates__Default__Password=''
fi

if hash wslview 2>/dev/null; then
  BROWSER=`which wslview`
  export BROWSER
fi

# resolve `winhost` as windows ip:
winhost=$(grep nameserver /etc/resolv.conf | awk '{ print $2 }')
export winhost
