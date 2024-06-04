THIS_FILE="${BASH_SOURCE[0]}"
THIS_DIR=`dirname "$THIS_FILE"`

SCRIPTS=`find "$THIS_DIR" -name '*.bash' -type f -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F'\0' '{print $3}'`
for SCRIPT in $SCRIPTS; do
  # shellcheck source=/dev/null
  source "$SCRIPT"
done
