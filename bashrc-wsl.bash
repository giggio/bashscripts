if ! [[ $(cat /proc/version) = *"Microsoft"* ]]; then
  return
fi
# put your script here for WSL only
export whome=$(wslpath -u $(cmd.exe /c "echo %USERPROFILE%") | sed -e 's/[[:space:]]*$//')
if [ "$whome" == "$(pwd)" ]; then
  cd ~
fi
