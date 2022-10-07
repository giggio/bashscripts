DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
if [ -f /proc/1/cgroup ]; then
  if grep docker /proc/1/cgroup -qa; then
    export RUNNING_IN_CONTAINER=true
  else
    export RUNNING_IN_CONTAINER=false
  fi
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

if hash wslview 2>/dev/null; then
  export BROWSER=`which wslview`
fi

# resolve `winhost` as windows ip:
source $DIR/winhost-set.sh

# gpg relay to Windows
# see https://github.com/Lexicality/wsl-relay/blob/main/scripts/gpg-relay
# wsl-relay.exe should be in PATH on the Windows file system
# related:
# * https://blog.nimamoh.net/yubi-key-gpg-wsl2/
# * https://justyn.io/blog/using-a-yubikey-for-gpg-in-wsl-windows-subsystem-for-linux-on-windows-10/
# This allows for `gpg --card-status` to work
# see https://github.com/giggio/wsl-ssh-pageant-installer to view how to configure the relay to autostart
# see https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP to view how to export a key to yubikey
if ! ps aux | grep [w]sl-relay &> /dev/null; then
  rm -f $HOME/.gnupg/S.gpg-agent
  if hash wsl-relay.exe 2>/dev/null; then
    if `powershell.exe -noprofile -NonInteractive -c 'Write-Host (Test-Path $env:LOCALAPPDATA/gnupg/S.gpg-agent).ToString().ToLower()'`; then
      socat UNIX-LISTEN:$HOME/.gnupg/S.gpg-agent,fork, EXEC:'wsl-relay.exe --input-closes --pipe-closes --gpg',nofork &
      disown
    fi
  fi
fi

# ssh relay through gpg to Windows
# needs to run `wsl-ssh-pageant --winssh ssh-pageant --systray`
# see https://github.com/benpye/wsl-ssh-pageant
# related:
# * https://gist.github.com/matusnovak/302c7b003043849337f94518a71df777
if ps aux | grep [n]piperelay &> /dev/null; then
  export SSH_AUTH_SOCK=/tmp/wsl_ssh_pageant_socket
else
  rm -f /tmp/wsl-ssh-pageant.socket
  if hash npiperelay.exe 2>/dev/null && hash gpg-connect-agent.exe 2>/dev/null; then
    if `powershell.exe -noprofile -NonInteractive -c 'Write-Host ((Get-Process gpg-agent).Length -eq 1).ToString().ToLower()'` \
    || gpg-connect-agent.exe /bye; then
      WSL_SSH_PAGEANT_STARTED=false
      if `powershell.exe -noprofile -NonInteractive -c 'Write-Host (([array]([System.IO.Directory]::GetFiles("//./pipe/") | Where-Object { $_ -eq "//./pipe/ssh-pageant" })).Length -eq 1).ToString().ToLower()'`; then
        WSL_SSH_PAGEANT_STARTED=true
      else
        # start wsl-ssh-pageant.exe
        if hash wsl-ssh-pageant.exe 2> /dev/null; then
          wsl-ssh-pageant.exe --winssh ssh-pageant --systray &> /dev/null &
          if kill -0 $! &> /dev/null; then
            WSL_SSH_PAGEANT_STARTED=true
          else
            echo "Could not start WSL SSH Pageant"
          fi
        fi
      fi
      if $WSL_SSH_PAGEANT_STARTED; then
        socat UNIX-LISTEN:/tmp/wsl_ssh_pageant_socket,unlink-close,unlink-early,fork EXEC:'npiperelay.exe -ei -s //./pipe/ssh-pageant' &
        disown
        export SSH_AUTH_SOCK=/tmp/wsl_ssh_pageant_socket
      fi
    fi
  fi
fi

# setup boot commands for wsl:
$DIR/wsl-boot.sh
