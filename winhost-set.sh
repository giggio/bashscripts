#!/usr/bin/env bash

# add to [boot] "command" option (Windows 11). See https://docs.microsoft.com/en-us/windows/wsl/wsl-config#boot

# resolve `winhost` as windows ip, see issue and comment: https://github.com/microsoft/WSL/issues/4619#issuecomment-821142078
# and https://github.com/microsoft/WSL/issues/4619#issuecomment-966435432

winhost=$(grep nameserver /etc/resolv.conf | awk '{ print $2 }')
export winhost
# return if this script was sourced
if (return 0 2>/dev/null); then
  return 0
fi

# update winhost:
old_winhost=$(grep -P "[[:space:]]winhost" /etc/hosts | awk '{ print $1 }')
if [ -z "$old_winhost" ]; then
  if [ "`id -u`" == '0' ]; then
    echo -e "$winhost\twinhost" >> "/etc/hosts"
  else
    if ! sudo -n true 2> /dev/null; then
      echo "Will write winhost ($winhost) to /etc/hosts, needs auth:"
    fi
    echo -e "$winhost\twinhost" | sudo tee -a "/etc/hosts" > /dev/null
  fi
elif [ "$old_winhost" != "$winhost" ]; then
  if [ "`id -u`" == '0' ]; then
    sed -i "s/$old_winhost\twinhost/$winhost\twinhost/g" /etc/hosts
  else
    if ! sudo -n true 2> /dev/null; then
      echo "Will update winhost in /etc/hosts to value $winhost (was $old_winhost), needs auth:"
    fi
    sudo sed -i "s/$old_winhost\twinhost/$winhost\twinhost/g" /etc/hosts
  fi
fi

# sets owner to root, as this might run as root
THIS_FILE="${BASH_SOURCE[0]}"
if [ "`stat -c '%U:%G'`" != "root:root" ]; then
  if [ "`id -u`" == '0' ]; then
    chown root:root "$THIS_FILE"
  else
    if ! sudo -n true 2> /dev/null; then
      echo "Will update script ($THIS_FILE) file owner, needs auth:"
    fi
    sudo chown root:root "$THIS_FILE"
  fi
fi
