# these are aliases that only exist if you are on WSL
if ! $WSL; then return; fi
alias explorer=explorer.exe
alias cmd=cmd.exe
alias powershell=powershell.exe
alias start='pwsh.exe -NoProfile -NoLogo -c start'
alias clip=clip.exe
alias notepad=notepad.exe
alias wt=wt.exe
alias ver='pushd /mnt/c > /dev/null;cmd.exe /c ver; pushd > /dev/null'
alias gitk=gitk.exe
