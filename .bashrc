THIS_FILE="${BASH_SOURCE[0]}"
THIS_DIR=`dirname "$THIS_FILE"`

SCRIPTS=`find "$THIS_DIR" -name '*.bash' -type f | while read -r file; do
  dir=$(dirname "$file")
  depth=$(echo "$file" | tr -cd "/" | wc -c)
  printf "%s\x1F%d\x1F%s\n" "$dir" "$depth" "$file"
done | sort -t $'\x1F' -k2n | cut -d $'\x1F' -f3`
for SCRIPT in $SCRIPTS; do
  # shellcheck source=/dev/null
  source "$SCRIPT"
done
