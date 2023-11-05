#!/usr/bin/env bash

# this file will be added to the [boot] "command" option (Windows 11) when it first runs.
# See https://learn.microsoft.com/en-us/windows/wsl/wsl-config#boot-settings

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THIS_FILE="${BASH_SOURCE[0]}"
if (return 0 2>/dev/null); then
  echo "Don't source this script ($THIS_FILE)."
  exit 1
fi

WSL_CONF=/etc/wsl.conf

isSetup=$(python3 << EOF
import configparser
config = configparser.ConfigParser(allow_no_value=True)
config.read('$WSL_CONF')
print(config.has_option('boot', 'command') and config.has_option('automount', 'options'))
EOF
)

if [ "$EUID" != "0" ]; then
  if [ "$isSetup" != "True" ]; then
    if ! sudo -n true 2> /dev/null; then
      echo "Will run this script ($THIS_FILE) as root, needs auth:"
    fi
    sudo "$THIS_FILE"
  fi
  exit 0
fi

if ! [ -f $WSL_CONF ]; then
  sudo touch $WSL_CONF
fi

python3 << EOF
import configparser
config = configparser.ConfigParser(comment_prefixes='/', allow_no_value=True)
config.optionxform = lambda option: option
config.read('$WSL_CONF')

if not config.has_section('boot'):
  config.add_section('boot')
if not config.has_option('boot', 'command') or config['boot']['command'] != '$THIS_FILE':
  config['boot']['command'] = '$THIS_FILE'
  config.write(open('$WSL_CONF', 'w'))
if not config.has_section('automount'):
  config.add_section('automount')
if not config.has_option('automount', 'options') or config['automount']['options'] != '"metadata,umask=22,fmask=11"':
  config['automount']['options'] = '"metadata,umask=22,fmask=11"'
  config.write(open('$WSL_CONF', 'w'))
EOF

# sets owner to root, as this might run as root
if [ "`stat -c '%U:%G'`" != "root:root" ]; then
  sudo chown root:root "$THIS_FILE"
fi

# start cron, add '%sudo ALL=NOPASSWD: /etc/init.d/cron start' via visudo if this fails
if ! pgrep cron > /dev/null; then
  if [ -f /etc/init.d/cron ]; then
    sudo /etc/init.d/cron start > /dev/null
  fi
fi

sudo "$DIR"/winhost-set.sh
