#!/usr/bin/env bash

set -euo pipefail

DIR="$(pwd)" # hooks are always ran from the root of the repo

submodule_dirs=$(git submodule | awk '{ printf "-not -path '"$DIR"'/" $2 "/* " }')
set -f # disable globbing
# shellcheck disable=SC2086
sh_files=$(find "$DIR" \( -name '*.sh' -or -name '*.bash' \) -not -path "$DIR"/.testsupport/'*' $submodule_dirs)
# shellcheck disable=SC2086
exec_files=$(find "$DIR" -not -path "$DIR"/.testsupport/'*' $submodule_dirs -type f -exec sh -c 'head -n1 $1 | grep -qE '"'"'^#!(.*/|\/usr\/bin\/env +)bash'"'" sh {} \; -exec echo {} \;)
set +f
all_files=`echo -e "$sh_files\n$exec_files" | sort | uniq`
# shellcheck disable=SC2086
shellcheck --shell bash $all_files
