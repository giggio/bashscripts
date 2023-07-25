DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if grep '[Mm]icrosoft' /proc/version > /dev/null; then
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
  wslpath "$(cmd.exe /c 'echo|set /p=%'"$1"'%' 2> /dev/null)"
}
if [ -f /.dockerenv ] || grep docker /proc/1/cgroup -qa 2> /dev/null; then
  export RUNNING_IN_CONTAINER=true
else
  export RUNNING_IN_CONTAINER=false
fi
if ! $WSL || $RUNNING_IN_CONTAINER; then return; fi
# put your script here for WSL only
IS_SSH=false
if [ -v SSH_CLIENT ] || [ -v SSH_TTY ]; then
  IS_SSH=true
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) IS_SSH=true;;
  esac
fi
export IS_SSH
if [ -v WSL_INTEROP ] || [ -v WSL_INTEGRATION_CACHE ]; then
  export WSLVersion=2
else
  export WSLVersion=1
fi
if [ "$WSLVersion" == "1" ]; then
  export DOCKER_HOST="unix://$HOME/sockets/docker.sock"
  if hash tmux 2>/dev/null && hash docker-relay 2>/dev/null; then
    if ! pgrep socat > /dev/null; then
      tmux new -s docker-relay-session -d docker-relay
    fi
  fi
fi

if hash cmd.exe 2> /dev/null; then
  pushd /mnt/c > /dev/null
  # shellcheck disable=SC2155
  export WHOME=`windows_env_var USERPROFILE`
  popd > /dev/null
  if [ "$WHOME" == "$(pwd)" ]; then
    cd || exit
  fi
fi

# Do not run wslfetch, it is really slow to start, it adds several seconds to bash's startup.
# if hash wslfetch 2>/dev/null; then
#   wslfetch
# fi

WINDOWS_IP_ADDRESS=`ipconfig.exe | grep WSL -A3 | tail -n 1 | awk '{print $NF}' | tr -d '\r\n'`
export WINDOWS_IP_ADDRESS

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
if [ -f "$HOME"/certs/dotnet.pfx ]; then
  export Kestrel__Certificates__Default__Path=$HOME/certs/dotnet.pfx
  export Kestrel__Certificates__Default__Password=''
fi

if hash wslview 2>/dev/null; then
  BROWSER=`which wslview`
  export BROWSER
fi

# resolve `winhost` as windows ip:
source "$DIR"/winhost-set.sh

gpg_agent_running() {
    powershell.exe -noprofile -NonInteractive -c 'Get-Process gpg-agent -ErrorAction SilentlyContinue | Out-Null' \
    || gpg-connect-agent.exe /bye
}

forward_gpg() {
  # gpg relay to Windows
  # see https://github.com/Lexicality/wsl-relay/blob/main/scripts/gpg-relay
  # wsl-relay.exe should be in PATH on the Windows file system
  # related:
  # * https://blog.nimamoh.net/yubi-key-gpg-wsl2/
  # * https://justyn.io/blog/using-a-yubikey-for-gpg-in-wsl-windows-subsystem-for-linux-on-windows-10/
  # This allows for `gpg --card-status` to work
  # see https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP to view how to export a key to yubikey
  LOCALAPPDATA=`windows_env_var LOCALAPPDATA`
  if ! pgrep --full 'wsl-relay.*--gpg,' &> /dev/null; then
    AGENT_SOCKET_FILE=`gpgconf --list-dir | grep --color=never agent-socket | cut -d: -f2`
    rm -f "$AGENT_SOCKET_FILE"
    if hash wsl-relay.exe 2>/dev/null && hash gpg-connect-agent.exe 2>/dev/null; then
      if gpg_agent_running; then
        if [ -f "$LOCALAPPDATA/gnupg/S.gpg-agent" ]; then
          SCREENDIR=$HOME/.screen screen -dmS gpg-agent socat UNIX-LISTEN:"$AGENT_SOCKET_FILE",fork, EXEC:'wsl-relay.exe --input-closes --pipe-closes --gpg',nofork &
        fi
      fi
    fi
  fi
  if ! pgrep --full 'wsl-relay.*--gpg=S.gpg-agent.extra,' &> /dev/null; then
    AGENT_EXTRA_SOCKET_FILE=`gpgconf --list-dir | grep --color=never agent-extra-socket | cut -d: -f2`
    rm -f "$AGENT_EXTRA_SOCKET_FILE"
    if hash wsl-relay.exe 2>/dev/null && hash gpg-connect-agent.exe 2>/dev/null; then
      if gpg_agent_running; then
        if [ -f "$LOCALAPPDATA/gnupg/S.gpg-agent.extra" ]; then
          SCREENDIR=$HOME/.screen screen -dmS gpg-agent-extra socat UNIX-LISTEN:"$AGENT_EXTRA_SOCKET_FILE",fork, EXEC:'wsl-relay.exe --input-closes --pipe-closes --gpg=S.gpg-agent.extra',nofork &
        fi
      fi
    fi
  fi
}

ensure_gpg_ssh_agent() {
  if cmd.exe /c 'dir \\.\pipe\\openssh-ssh-agent' &>/dev/null; then
    return 0
  else
    # start gpg agent in Windows
    if gpg_agent_running; then
      if cmd.exe /c 'dir \\.\pipe\\openssh-ssh-agent' &>/dev/null; then
        return 0
      fi
    fi
  fi
  return 1
}

forward_ssh() {
  local SSH_AUTH_SOCK=/tmp/ssh_agent_socket
  if pgrep --full npiperelay &>/dev/null; then
    if ensure_gpg_ssh_agent; then
      export SSH_AUTH_SOCK
    fi
  else
    if hash npiperelay.exe 2>/dev/null && hash gpg-connect-agent.exe 2>/dev/null; then
      if gpg_agent_running; then
        SCREENDIR=$HOME/.screen screen -dmS ssh_auth_sock socat UNIX-LISTEN:"$SSH_AUTH_SOCK",unlink-close,unlink-early,group=giggio,mode=775,fork EXEC:'npiperelay.exe -ei -s //./pipe/openssh-ssh-agent',nofork &
        export SSH_AUTH_SOCK
      fi
    fi
  fi
}

forward_gpg

forward_ssh

# setup boot commands for wsl:
"$DIR"/wsl-boot.sh
