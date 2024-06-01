#!/usr/bin/env bash

set -euo pipefail

# hooks are always ran from the root of the repo

# get all files that have been changed
all_diff_files=`git diff --name-only --cached --ignore-submodules=all --diff-filter=ACM`
if [ -z "$all_diff_files" ]; then exit 0; fi
diff_files=`echo "$all_diff_files" | grep -v /.testsupport/`
# shellcheck disable=SC2086
exec_files=$(find $diff_files -exec sh -c 'head -n1 $1 | grep -qE '"'"'^#!(.*/|\/usr\/bin\/env +)bash'"'" sh {} \; -exec echo {} \;)
# shellcheck disable=SC2086
sh_files=$(find $diff_files \( -name '*.sh' -or -name '*.bash' \))
all_files=`echo -e "$sh_files\n$exec_files" | sort | uniq`
if [ -z "$all_files" ]; then
  echo "No shell files found to check"
  exit 0
fi
echo "Running shellcheck on the following files:"
echo "$all_files"
# shellcheck disable=SC2086
shellcheck --shell bash $all_files
