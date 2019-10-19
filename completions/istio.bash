if hash istioctl 2>/dev/null; then
  THIS_FILE=$BASH_SOURCE
  THIS_DIR=`dirname $THIS_FILE`
  if [ ! -f $THIS_DIR/istioctl.bash ]; then
    istioctl collateral completion --bash -o $THIS_DIR
    chmod +x $THIS_DIR/istioctl.bash
    source $THIS_DIR/istioctl.bash
  fi
fi
