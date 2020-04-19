#!/bin/bash

# if on WSL2 add this to a cron to run every minute
# to limit the number of the log file run:
# tail -n 20 /var/log/cacheclean > /var/log/cacheclean

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