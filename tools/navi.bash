if hash navi 2>/dev/null; then
  eval "$(navi widget bash)"
  BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  CHEATS_DIR="$BASEDIR/../../cheats"
  if [ -d "$CHEATS_DIR" ]; then
    CHEATS_DIR=$(realpath "$CHEATS_DIR")
    export NAVI_PATH="$CHEATS_DIR/dist/common/:$CHEATS_DIR/dist/bash/:$CHEATS_DIR/dist/linux/common/:$CHEATS_DIR/dist/linux/bash/"
  fi
fi
