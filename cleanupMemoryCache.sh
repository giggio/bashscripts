#!/bin/bash

# if on WSL2 add this to a cron to run every minute
# to limit the number of the log file run:
# tail -n 20 /var/log/cacheclean > /var/log/cacheclean

if [ "$(whoami)" != "root" ]; then
  echo "$(date) Must be run as root." | tee -a /var/log/cacheclean
  exit 2
fi
CACHED="$(cat /proc/meminfo | grep ^Cached | awk '{print $2}')"
if [ "$CACHED" -gt '3670016' ]; then
  sync
  echo 3 > /proc/sys/vm/drop_caches
  echo "$(date) Cached memory cleaned." | tee -a /var/log/cacheclean
else
  echo "$(date) Cached memory is low ($CACHED kBs), no need to clean." | tee -a /var/log/cacheclean
fi