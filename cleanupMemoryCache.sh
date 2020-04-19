#!/bin/bash

# If on WSL2 add this to the root cron to run every minute, but be safe,
# first run a checksum with `sudo ./cleanupMemoryCache.sh -c`
# and on the root cron, add:
# sha256sum --status --strict -c /root/.cleanupMemoryCache-sha256sum && /path/to/bashscripts/cleanupMemoryCache.sh
# this will guarantee that if the file is tampered with it will not run anymore.
#
# To limit the number of the log file run:
# echo "$(tail -n 20 /var/log/cacheclean)" > /var/log/cacheclean
# It is also a good idea to run it every couple of hours or everyday.

set -euo pipefail

DATE_FORMAT=+%a\ %F\ %T\ %Z
if [ "$(whoami)" != "root" ]; then
  echo 2>&1 "$(date "$DATE_FORMAT") Must be run as root."
  exit 2
fi
FORCE=false
if [ "$#" -ge 1 ]; then
  if [ "$1" == '--force' ] || [ "$1" == '-f' ]; then
    FORCE=true
  fi
  if [ "$1" == '--generate-checksum' ] || [ "$1" == '-c' ]; then
    THIS_DIR=`realpath $(dirname $BASH_SOURCE)`
    CHECKSUM_FILE=$HOME/.cleanupMemoryCache-sha256sum
    sha256sum $THIS_DIR/cleanupMemoryCache.sh > $CHECKSUM_FILE
    echo "Generated checksum to '$CHECKSUM_FILE'."
    exit 0
  fi
fi
CACHED="$(cat /proc/meminfo | grep ^Cached | awk '{print $2}')"
if $FORCE; then
  echo "$(date "$DATE_FORMAT") Running with force." | tee -a /var/log/cacheclean
fi
if $FORCE || [ "$CACHED" -gt '3670016' ]; then
  sync
  echo 3 > /proc/sys/vm/drop_caches
  echo "$(date "$DATE_FORMAT") Cached memory cleaned." | tee -a /var/log/cacheclean
else
  echo "$(date "$DATE_FORMAT") Cached memory is low ($CACHED kBs), no need to clean." | tee -a /var/log/cacheclean
fi